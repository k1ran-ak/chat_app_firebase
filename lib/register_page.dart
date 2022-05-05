import 'package:chat_app/firebase_auth.dart';
import 'package:chat_app/login_page.dart';
import 'package:chat_app/validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/firebase_options.dart';

class RegiserHome extends StatefulWidget {
  const RegiserHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegiserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginHome()));
            },
            icon: const Icon(Icons.login),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: registerWidget(context),
        ),
      ),
    );
  }

  Widget registerWidget(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    final _formKey = GlobalKey<FormState>();
    Future<FirebaseApp> _initializeFirebase() async {
      WidgetsFlutterBinding.ensureInitialized();
      FirebaseApp firebaseApp = await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      return firebaseApp;
    }

    return FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Form(
                key: _formKey,
                child: Column(
                  children: [
                    textFieldElements(context, emailController, 'Email'),
                    textFieldElements(context, passwordController, 'Password',
                        isPassword: true),
                    textFieldElements(context, nameController, 'Name'),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                              User? user =
                                  await FireAuth.registerUsingEmailPassword(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      context: context);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginHome()),
                            );
                          },
                          child: const Text('Register')),
                    )
                  ],
                ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

Widget textFieldElements(
    BuildContext context, TextEditingController controller, String fieldName,
    {bool isPassword = false}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text('$fieldName :'),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: 'Enter $fieldName',
            ),
            controller: controller,
            validator: (value) {
              if (fieldName.toLowerCase() == 'email') {
                return Validator.validateEmail(email: value);
              } else if (fieldName.toLowerCase() == 'password') {
                return Validator.validatePassword(password: value);
              } else {
                return Validator.validateName(name: value);
              }
            }),
      )
    ],
  );
}
