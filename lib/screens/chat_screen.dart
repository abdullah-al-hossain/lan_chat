import 'package:flutter/material.dart';

import '../core/message_store.dart';
import '../models/message.dart';
import '../models/peer.dart';
import '../services/tcp_client_service.dart';

class ChatScreen extends StatefulWidget {
  final Peer peer;
  final String myId;

  const ChatScreen({
    super.key,
    required this.peer,
    required this.myId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _client = TcpClientService();

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final msg = Message(
      from: widget.myId,
      to: widget.peer.id,
      type: 'text',
      data: text,
      time: DateTime.now(),
    );

    await _client.send(
      ip: widget.peer.ip,
      port: widget.peer.port,
      payload: {
        'from': msg.from,
        'to': msg.to,
        'type': msg.type,
        'data': msg.data,
        'time': msg.time.millisecondsSinceEpoch,
      },
    );

    MessageStore.add(msg);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Scaffold handles keyboard
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.peer.name,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.peer.model,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: MessageStore.messages,
              builder: (_, __, ___) {
                final chat = MessageStore.forChat(
                  widget.peer.id,
                  widget.myId,
                );

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: chat.length,
                  itemBuilder: (_, i) {
                    final m = chat.reversed.toList()[i];
                    final isMe = m.from == widget.myId;

                    return Align(
                      alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.green.shade200
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(m.data),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// ✅ INPUT BAR (NO DOUBLE PADDING)
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Type message...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
