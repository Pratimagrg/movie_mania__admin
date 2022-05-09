part of 'chatmessage_cubit.dart';

class ChatState {
  ChatState(
      {this.messageList = const [],
      this.connected = false,
      this.error = "",
      this.next});

  final List<MessageListModel> messageList;
  final bool connected;
  final String error;
  late dynamic next;

  List<Object> get props => [messageList, connected, error];

  ChatState copyWith(
      {List<MessageListModel>? messageList,
      bool? connected,
      String? error,
      dynamic next}) {
    return ChatState(
        messageList: messageList ?? this.messageList,
        connected: connected ?? this.connected,
        error: error ?? this.error,
        next: next ?? this.next);
  }

  void setNext(next) {
    this.next = next;
  }
}
