import 'package:chat_app/chat_list.dart';
import 'package:chat_app/chat_model.dart';
import 'package:chat_app/data_access_object.dart';
// import 'package:chat_app/sender_receiver.dart';
import 'package:chat_app/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  ChatHome({Key? key, required this.user, required this.messageDao})
      : super(key: key);
  User user;
  MessageDao messageDao;
  @override
  State<StatefulWidget> createState() {
    return ChatState();
  }
}

class ChatState extends State<ChatHome> {
  TextEditingController receiverController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<ChatLists> chatsList = [];
  List<Message> messageArray = [];
  void _sendMessage(BuildContext context) {
    // final message = Message(
    //     message: messageController.text,
    //     date: DateTime.now().toString(),
    //     receiver: receiverController.text);
    // widget.messageDao.saveMessage(message);
    // messageArray.add(Message(
    //     content: messageController.text, date: DateTime.now().toString()));
    if (messageArray.isNotEmpty &&
        messageArray.last.receiver == receiverController.text) {
      messageArray.add(Message(
          sender: widget.user.email ?? '',
          receiver: receiverController.text,
          content: messageController.text,
          date: DateTime.now().toString()));
    } else {
      messageArray = [];
      messageArray.add(Message(
          sender: widget.user.email ?? '',
          receiver: receiverController.text,
          content: messageController.text,
          date: DateTime.now().toString()));
    }

    // widget.messageDao.createMessage(Chat(
    //     from: widget.user.email ?? '',
    //     to: receiverController.text,
    //     messages: messageArray));

    widget.messageDao
        .sendMessageToChat(
            ChatLists(
                users: '${widget.user.email}/${receiverController.text}',
                messages: messageArray),
            widget.user.email ?? '')
        .then((value) {
      if (!value) {
        widget.messageDao.createMessage(ChatListModel(
            chatLists: ChatLists(
                users: '${widget.user.email}/${receiverController.text}',
                messages: messageArray)));
      }
    }, onError: (e) {
      debugPrint(e);
    });

    messageController.clear();

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Message sent')));
  }

  @override
  void initState() {
    super.initState();
    getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Send Message'),
                      content: SizedBox(
                        height: 200,
                        child: Form(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'To'),
                                controller: receiverController,
                                validator: (value) {
                                  if (_formKey.currentState!.validate()) {
                                    return Validator.validateEmail(
                                        email: value);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(hintText: 'Message'),
                                controller: messageController,
                                validator: (value) {
                                  if (_formKey.currentState!.validate()) {
                                    return Validator.validateMessage(
                                        message: value);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  child: const Text('Send Message'),
                                  onPressed: () {
                                    _sendMessage(context);
                                    getChatList();
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.edit)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 85,
        width: MediaQuery.of(context).size.width * 90,
        color: Colors.red,
        child: _listView(context),
        padding: const EdgeInsets.all(10),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        var userA = chatsList[index].users.split('/').first;
        var userB = chatsList[index].users.split('/').last;

        return chartCards(
            context, widget.user.email == userA ? userB : userA, index);
      }),
      itemCount: chatsList.length,
    );
  }

  void getChatList() {
    Map<dynamic, dynamic> json = {};
    getEvent().then((value) {
      DatabaseEvent event = value;
      json = event.snapshot.value as Map<dynamic, dynamic>;
      json.forEach((key, value) {
        var chats = ChatListModel.fromJson(value);
        var sender = widget.user.email ?? '';

        debugPrint('Sender is : ${sender.split('@')}');
        if (chats.chatLists.users.contains(sender)) {
          var chatList = chats.chatLists;
          chatsList = [];
          // chats.messages.add(chat.messages.last);
          // newRef = ref.child(key).child("messages");
          setState(() {
            // chatsList.add(chats);
            chatsList.add(chatList);
          });
        }
      });
    }, onError: (e) {
      debugPrint(e);
    });
  }

  Future<DatabaseEvent> getEvent() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();
    return event;
  }

  Widget chartCards(BuildContext context, String user, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          const CircleAvatar(
            child: Icon(Icons.people),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    IconButton(
                        onPressed: () {
                          Future<String> futureName = receiverName();

                          futureName.then((value) {
                            if (value.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatListHome(
                                      messageDao: MessageDao(
                                          messagesRef:
                                              FirebaseDatabase.instance.ref()),
                                      receiver: value,
                                      user: widget.user,
                                      users: chatsList[index].users,
                                    );
                                  },
                                ),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.message))
                  ],
                ),
                Text(user)
              ],
            ),
          )
        ]),
      ),
    );
  }

  Future<String> receiverName() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;
      // Map<dynamic,Chat> chat = [];
      List<Message> chat = [];
      String receiver = '';
      var sender = widget.user.email ?? '';
      json.forEach((key, value) {
        // chat.addAll(Chat.fromJson(json));
        var chatListModel = ChatListModel.fromJson(value);
        if (chatListModel.chatLists.users.contains(sender)) {
          var message = chatListModel.chatLists.messages;
          var userA = chatListModel.chatLists.users.split('/').first;
          var userB = chatListModel.chatLists.users.split('/').last;
          receiver = sender == userA ? userB : userA;
          // sender == message.to
          //     ? receiver = message.from
          //     : receiver = message.to;

          // chat.add(message);
          chat = message;
        }

        // chat.addAll(message);
      });
      // Chat chat = Chat.fromJson(json);

      return receiver;
    } else {
      return '';
    }
  }

  // Future<Chat> chatList(String user) async {
  //   DatabaseReference ref = FirebaseDatabase.instance.ref();
  //   DatabaseEvent event = await ref.once();
  //   if (event.snapshot.value != null) {
  //     final json = event.snapshot.value as Map<dynamic, dynamic>;
  //     List<Chat> chat = [];
  //     json.forEach((key, value) {
  //       var message = Chat.fromJson(value);
  //       chat.add(message);
  //     });
  //     return chat.first;
  //   } else {
  //     List<Message> messageArray = [];
  //     messageArray.add(Message(
  //         content: messageController.text, date: DateTime.now().toString()));
  //     return Chat(
  //         to: 'anushkiran7@gmail.com',
  //         from: 'anush@nextazy.com',
  //         messages: messageArray);
  //   }
  // }
}
