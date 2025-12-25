import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/peer.dart';

class UdpDiscoveryService {
  static const int discoveryPort = 45454;

  RawDatagramSocket? _socket;
  Timer? _broadcastTimer;

  final Map<String, Peer> _peers = {};

  Map<String, Peer> get peers => _peers;

  Future<void> start({
    required Map<String, String> device,
    required void Function(Map<String, Peer>) onPeersUpdated,
  }) async {
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      discoveryPort,
      reuseAddress: true,
    );

    _socket!.broadcastEnabled = true;

    // 🔊 Listen for incoming packets
    _socket!.listen((event) {
      if (event == RawSocketEvent.read) {
        final dg = _socket!.receive();
        if (dg == null) return;

        final msg = utf8.decode(dg.data);
        final data = jsonDecode(msg);

        if (data['id'] == device['id']) return;

        _peers[data['id']] = Peer(
          id: data['id'],
          name: data['name'],
          model: data['model'],
          ip: dg.address.address,
          port: data['port'],
          lastSeen: DateTime.now(),
        );

        onPeersUpdated(_peers);
      }
    });

    // 📡 Broadcast presence every 2 seconds
    _broadcastTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      final payload = jsonEncode({
        'id': device['id'],
        'name': device['name'],
        'model': device['model'],
        'port': 4040, // TCP chat port (later)
      });

      _socket!.send(
        utf8.encode(payload),
        InternetAddress('255.255.255.255'),
        discoveryPort,
      );
    });
  }

  void stop() {
    _broadcastTimer?.cancel();
    _socket?.close();
  }
}
