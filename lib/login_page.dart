import 'package:chat_app/chat_page.dart';
import 'package:chat_app/data_access_object.dart';
import 'package:chat_app/firebase_auth.dart';
import 'package:chat_app/register_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<LoginHome> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                textFieldElements(context, emailController, 'Email'),
                textFieldElements(context, passwordController, 'Password',
                    isPassword: true),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      User? user = await FireAuth.signInUsingEmailPassword(
                          email: emailController.text,
                          password: passwordController.text,
                          context: context);
                      if (user != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatHome(
                              user: user,
                              messageDao: MessageDao(
                                  messagesRef: FirebaseDatabase.instance.ref()),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
