import 'package:flutter/material.dart';

import 'core/device_identity.dart';
import 'core/message_store.dart';
import 'models/message.dart';
import 'models/peer.dart';
import 'services/tcp_server_service.dart';
import 'services/udp_discovery_service.dart';
import 'screens/peers_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiscoveryHost(),
    );
  }
}

class DiscoveryHost extends StatefulWidget {
  const DiscoveryHost({super.key});

  @override
  State<DiscoveryHost> createState() => _DiscoveryHostState();
}

class _DiscoveryHostState extends State<DiscoveryHost> {
  final _discovery = UdpDiscoveryService();
  final _tcpServer = TcpServerService();

  Map<String, Peer> _peers = {};
  Map<String, String>? _device;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _device = await DeviceIdentity.getIdentity();

    // 🔥 Start TCP Server (receive messages)
    await _tcpServer.start(
      myId: _device!['id']!,
      onMessage: (Message msg) {
        MessageStore.add(msg);
        debugPrint("📩 ${msg.from}: ${msg.data}");
      },

    );

    // 🔎 Start UDP Discovery (find peers)
    await _discovery.start(
      device: _device!,
      onPeersUpdated: (data) {
        if (mounted) {
          setState(() => _peers = data);
        }
      },
    );
  }

  @override
  void dispose() {
    _tcpServer.stop();
    _discovery.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_device == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PeersScreen(
      peers: _peers.values.toList(),
      myId: _device!['id']!,
    );
  }
}
