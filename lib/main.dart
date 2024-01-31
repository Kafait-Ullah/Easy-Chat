import 'package:easy_chat/auth/signup_page.dart';
import 'package:easy_chat/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAjRqDmqeOBN6DQXeAsbB5sJL62_gezGZ4",
            authDomain: "easy-chat-4914c.firebaseapp.com",
            projectId: "easy-chat-4914c",
            storageBucket: "easy-chat-4914c.appspot.com",
            messagingSenderId: "441139235906",
            appId: "1:441139235906:web:2163cba3eef1c656ef31db",
            measurementId: "G-JQ9FWTSCG3"));
  } else {
    await Firebase.initializeApp();
  }
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
