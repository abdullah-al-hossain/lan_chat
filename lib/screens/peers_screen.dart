import 'package:flutter/material.dart';

import '../models/peer.dart';
import 'chat_screen.dart';

class PeersScreen extends StatelessWidget {
  final List<Peer> peers;
  final String myId;

  const PeersScreen({
    super.key,
    required this.peers,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Devices")),
      body: peers.isEmpty
          ? const Center(child: Text("No devices found"))
          : ListView.builder(
        itemCount: peers.length,
        itemBuilder: (_, i) {
          final p = peers[i];
          return ListTile(
            leading: const Icon(Icons.phone_android),
            title: Text(p.name),
            subtitle: Text(p.model),
            trailing: const Text("Online"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    peer: p,
                    myId: myId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
