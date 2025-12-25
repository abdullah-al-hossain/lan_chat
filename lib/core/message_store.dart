import 'package:flutter/foundation.dart';
import '../models/message.dart';

class MessageStore {
  static final ValueNotifier<List<Message>> messages =
  ValueNotifier<List<Message>>([]);

  static void add(Message msg) {
    messages.value = [...messages.value, msg];
  }

  static List<Message> forChat(String peerId, String myId) {
    return messages.value.where((m) =>
    (m.from == peerId && m.to == myId) ||
        (m.from == myId && m.to == peerId)).toList();
  }
}
