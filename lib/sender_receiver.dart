// // To parse this JSON data, do
// //
// //     final chat = chatFromJson(jsonString);

// import 'dart:convert';

// Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

// String chatToJson(Chat data) => json.encode(data.toJson());

// class Chat {
//   Chat({
//     required this.from,
//     required this.to,
//     required this.messages,
//   });

//   String from;
//   String to;
//   List<Message> messages;

//   factory Chat.fromJson(Map<dynamic, dynamic> json) => Chat(
//         from: json["from"],
//         to: json["to"],
//         messages: List<Message>.from(
//             json["messages"].map((x) => Message.fromJson(x))),
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "from": from,
//         "to": to,
//         "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
//       };
// }

// class Message {
//   Message({
//     required this.content,
//     required this.date,
//   });

//   String content;
//   String date;

//   factory Message.fromJson(Map<dynamic, dynamic> json) => Message(
//         content: json["content"],
//         date: json["date"],
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "content": content,
//         "date": date,
//       };
// }
