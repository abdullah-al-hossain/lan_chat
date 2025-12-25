import 'dart:convert';
import 'dart:io';

class TcpClientService {
  Future<void> send({
    required String ip,
    required int port,
    required Map<String, dynamic> payload,
  }) async {
    final socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 3));
    socket.add(utf8.encode(jsonEncode(payload)));
    await socket.flush();
    await socket.close();
  }
}
