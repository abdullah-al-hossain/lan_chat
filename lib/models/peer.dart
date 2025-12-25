class Peer {
  final String id;
  final String name;
  final String model;
  final String ip;
  final int port;
  DateTime lastSeen;

  Peer({
    required this.id,
    required this.name,
    required this.model,
    required this.ip,
    required this.port,
    required this.lastSeen,
  });
}
