// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

ChatListModel chatListModelFromJson(String str) =>
    ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  ChatListModel({
    required this.chatLists,
  });

  ChatLists chatLists;

  factory ChatListModel.fromJson(Map<dynamic, dynamic> json) => ChatListModel(
        chatLists: ChatLists.fromJson(json["chat_lists"]),
      );

  Map<dynamic, dynamic> toJson() => {
        "chat_lists": chatLists.toJson(),
      };
}

class ChatLists {
  ChatLists({
    required this.users,
    required this.messages,
  });

  String users;
  List<Message> messages;

  factory ChatLists.fromJson(Map<dynamic, dynamic> json) => ChatLists(
        users: json["users"],
        messages: List<Message>.from(
            json["messages"].map((x) => Message.fromJson(x))),
      );

  Map<dynamic, dynamic> toJson() => {
        "users": users,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.sender,
    required this.receiver,
    required this.content,
    required this.date,
  });

  String sender;
  String receiver;
  String content;
  String date;

  factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
        sender: json["sender"],
        receiver: json["receiver"],
        content: json["content"],
        date: json["date"],
      );

  Map<dynamic, dynamic> toJson() => {
        "sender": sender,
        "receiver": receiver,
        "content": content,
        "date": date,
      };
}
