class Message {
  final String from;
  final String to;
  final String type; // text | image | file
  final String data;
  final DateTime time;

  Message({
    required this.from,
    required this.to,
    required this.type,
    required this.data,
    required this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json['from'],
      to: json['to'],
      type: json['type'],
      data: json['data'],
      time: DateTime.fromMillisecondsSinceEpoch(json['time']),
    );
  }
}
