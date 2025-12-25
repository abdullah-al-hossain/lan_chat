import 'dart:convert';
import 'dart:io';

import '../models/message.dart';

class TcpServerService {
  static const int port = 4040;

  ServerSocket? _server;

  Future<void> start({
    required String myId,
    required void Function(Message message) onMessage,
  }) async {
    _server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      port,
    );

    _server!.listen((Socket client) {
      client.listen((data) {
        final text = utf8.decode(data);
        final json = jsonDecode(text);

        if (json['to'] != myId) return;

        final message = Message.fromJson(json);
        onMessage(message);
      });
    });
  }

  void stop() {
    _server?.close();
  }
}
