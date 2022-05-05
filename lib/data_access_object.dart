import 'package:chat_app/chat_model.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageDao {
  MessageDao({required this.messagesRef});
  DatabaseReference messagesRef;

  // void saveMessage(Message message) {
  //   messagesRef.push().set(message.toJson());
  //   // messagesRef.push().set(user.message.toJson());
  // }

  // void sendMessage(Chat chat, String sender) async {
  //   // final ref = messagesRef;
  //   // debugPrint('is Sender anush kiran ?${sender.split('7').last}');
  //   // DatabaseEvent event = await ref.once();
  //   // final json = event.snapshot.value as Map<dynamic, dynamic>;
  //   // List<Chat> chatList = [];
  //   // Message lastMessage = chat.messages.last;
  //   // json.forEach((key, value) {
  //   //   var chats = Chat.fromJson(value);
  //   //   chats.messages.add(lastMessage);

  //   //   if (chats.from == sender) {
  //   //     // chats.messages.add(chat.messages.last);
  //   //     messagesRef.child(key).update({
  //   //       "messages": List<dynamic>.from(chats.messages.map((x) => x.toJson()))
  //   //     });
  //   //   } else if (chats.to == sender) {
  //   //     // messagesRef.update({key: chats.toJson()});
  //   //     messagesRef.child(key).set(chats.toJson());
  //   //   } else {
  //   //     chatList.add(chats);
  //   //     messagesRef.push().set(chats.toJson());
  //   //   }
  //   // });
  // }

  Future<bool> sendMessageToChat(ChatLists messageList, String sender) async {
    bool closure = false;
    final ref = messagesRef;
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;
      json.forEach((key, value) {
        var chatList = ChatListModel.fromJson(value);
        if (chatList.chatLists.users.contains(sender)) {
          messagesRef.child(key).child("chat_lists").update({
            "messages":
                List<dynamic>.from(messageList.messages.map((x) => x.toJson()))
          });
          closure = true;
        }
      });
    }
    return closure;
  }

  void createMessage(ChatListModel chatListModel) {
    messagesRef.push().set(chatListModel.toJson());
  }

  Query getMessageQuery() {
    return messagesRef;
  }

  Query getMessages(DatabaseReference ref) {
    return ref;
  }
}
