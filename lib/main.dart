import 'package:easy_chat/auth/signup_page.dart';
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
      projectId: "easy-chat-4914c",
      storageBucket: "easy-chat-4914c.appspot.com",
      messagingSenderId: "441139235906",
      appId: "1:441139235906:web:2163cba3eef1c656ef31db",
    ));
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
          headline6: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
        ),
      ),
      home: const SignupPage(),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _userInputController = TextEditingController();
//   final List<ChatBubble> _chatMessages = [];
//   String responseTxt = '';
//   late ResponseModel _responseModel;
//   String _systemRole = "generic";

//   Future<void> _completionFun(String userMessage) async {
//     setState(() => responseTxt = 'Loading...');

//     final response = await http.post(
//       Uri.parse('https://api.openai.com/v1/chat/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${dotenv.env['OPENAI_KEY']}',
//       },
//       body: jsonEncode(
//         {
//           "model": "gpt-3.5-turbo",
//           "messages": [
//             {
//               "role": "system",
//               "content":
//                   "You are a helpful $_systemRole. You only give info about the $_systemRole field and whenever someone is asking insted of tha give only one line answer and positively change the answer to the $_systemRole say sorry i can assist you only about $_systemRole field"
//             },
//             {"role": "user", "content": userMessage},
//           ],
//           "max_tokens": 250,
//           "temperature": 0,
//           "top_p": 1,
//         },
//       ),
//     );

//     try {
//       final Map<String, dynamic> responseMap = jsonDecode(response.body);

//       if (responseMap['choices'] is List && responseMap['choices'].isNotEmpty) {
//         _responseModel = ResponseModel.fromJson(responseMap);
//         final openAIResponse = _responseModel.choices[0]['message']['content'];

//         if (openAIResponse.contains('not in my domain')) {
//           // Provide a short answer for queries not relevant to the role
//           responseTxt = 'I am here to help with $_systemRole-related queries.';
//         } else {
//           // Display the response along with information about the role
//           responseTxt = '$_systemRole: $openAIResponse';
//         }

//         _chatMessages.add(ChatBubble(message: responseTxt, sender: "OpenAI"));
//       } else {
//         print('Unexpected response format: $responseMap');
//         responseTxt = 'Unexpected response format';
//       }
//     } catch (e) {
//       print('Error decoding response: $e');
//       responseTxt = 'Error decoding response';
//     }

//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Drawer(
//             backgroundColor: Colors.black87,
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.zero)),
//             child: ListView(
//               children: [
//                 DrawerHeader(
//                   child: Image.asset(
//                     "assets/images/logo.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   child: Container(
//                     margin: const EdgeInsets.all(8),
//                     child: TextField(
//                       onChanged: (value) {
//                         setState(() {
//                           _systemRole = value.toLowerCase();
//                         });
//                       },
//                       cursorColor: Colors.white,
//                       decoration: InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.blueAccent),
//                           borderRadius: BorderRadius.all(Radius.circular(15)),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white),
//                           borderRadius: BorderRadius.all(Radius.circular(15)),
//                         ),
//                         hintText: 'Enter system role...',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Text(
//                     "Easy Chat",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Expanded(
//                     child: ChatScreen(chatMessages: _chatMessages),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _userInputController,
//                             cursorColor: Colors.black45,
//                             decoration: const InputDecoration(
//                               hintText: 'Type your message...',
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.white),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(15)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(
//                             Icons.send,
//                             color: Colors.blueAccent,
//                           ),
//                           onPressed: () {
//                             final userMessage =
//                                 _userInputController.text.trim();
//                             if (userMessage.isNotEmpty) {
//                               setState(() {
//                                 _chatMessages.add(
//                                   ChatBubble(
//                                     message: userMessage,
//                                     sender: "User",
//                                   ),
//                                 );
//                               });

//                               // Call OpenAI API and update chat
//                               _completionFun(userMessage);

//                               _userInputController.clear();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final List<ChatBubble> chatMessages;

//   const ChatScreen({Key? key, required this.chatMessages}) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: widget.chatMessages.length,
//       itemBuilder: (context, index) {
//         return widget.chatMessages[index];
//       },
//     );
//   }

//   void scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void didUpdateWidget(covariant ChatScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     scrollToBottom();
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final String sender;

//   const ChatBubble({
//     Key? key,
//     required this.message,
//     required this.sender,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: sender == "User" ? Colors.blueAccent : Colors.grey,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Text(
//         message,
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }

// class ResponseModel {
//   List<Map<String, dynamic>> choices;

//   ResponseModel({required this.choices});

//   factory ResponseModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel(
//       choices: List<Map<String, dynamic>>.from(json['choices']),
//     );
//   }
// }






















// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<HomePage> {
//   final TextEditingController _userInputController = TextEditingController();
//   final List<ChatBubble> _chatMessages = [];
//   String responseTxt = '';
//   late ResponseModel _responseModel;
//   String _systemRole = "generic";

//   Future<void> _completionFun(String userMessage) async {
//     setState(() => responseTxt = 'Loading...');

//     final response = await http.post(
//       Uri.parse('https://api.openai.com/v1/chat/completions'),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer ${dotenv.env['OPENAI_KEY']}',
//       },
//       body: jsonEncode(
//         {
//           "model": "gpt-3.5-turbo",
//           "messages": [
//             {
//               "role": "system",
//               "content":
//                   "You are a helpful $_systemRole. You only give info about the $_systemRole field and whenever someone is asking instead of that give only one line answer and positively change the answer to the $_systemRole. Say sorry, I can assist you only about $_systemRole field."
//             },
//             {"role": "user", "content": userMessage},
//           ],
//           "max_tokens": 250,
//           "temperature": 0,
//           "top_p": 1,
//         },
//       ),
//     );

//     try {
//       final Map<String, dynamic> responseMap = jsonDecode(response.body);

//       if (responseMap['choices'] is List && responseMap['choices'].isNotEmpty) {
//         _responseModel = ResponseModel.fromJson(responseMap);
//         final openAIResponse = _responseModel.choices[0]['message']['content'];

//         if (openAIResponse.contains('not in my domain')) {
//           // Provide a short answer for queries not relevant to the role
//           responseTxt = 'I am here to help with $_systemRole-related queries.';
//         } else {
//           // Display the response along with information about the role
//           responseTxt = '$_systemRole: $openAIResponse';
//         }

//         _chatMessages.add(ChatBubble(message: responseTxt, sender: "OpenAI"));
//       } else {
//         print('Unexpected response format: $responseMap');
//         responseTxt = 'Unexpected response format';
//       }
//     } catch (e) {
//       print('Error decoding response: $e');
//       responseTxt = 'Error decoding response';
//     }

//     // Scroll to the bottom after adding a new message
//     _scrollToBottom();

//     setState(() {});
//   }

//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Drawer(
//             backgroundColor: Colors.black87,
//             shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.zero)),
//             child: ListView(
//               children: [
//                 DrawerHeader(
//                   child: Image.asset(
//                     "assets/images/logo.png",
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 50),
//                 Container(
//                   margin: const EdgeInsets.all(8),
//                   child: Container(
//                     margin: const EdgeInsets.all(8),
//                     child: TextField(
//                       onChanged: (value) {
//                         setState(() {
//                           _systemRole = value.toLowerCase();
//                         });
//                       },
//                       cursorColor: Colors.white,
//                       decoration: const InputDecoration(
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.blueAccent),
//                           borderRadius: BorderRadius.all(Radius.circular(15)),
//                         ),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white),
//                           borderRadius: BorderRadius.all(Radius.circular(15)),
//                         ),
//                         hintText: 'Enter system role...',
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   Text(
//                     "Easy Chat",
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                   Expanded(
//                     child: ChatScreen(
//                       chatMessages: _chatMessages,
//                       scrollController: _scrollController,
//                     ),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.all(8),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _userInputController,
//                             cursorColor: Colors.black45,
//                             decoration: const InputDecoration(
//                               hintText: 'Type your message...',
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.white),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(15)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(
//                             Icons.send,
//                             color: Colors.blueAccent,
//                           ),
//                           onPressed: () {
//                             final userMessage =
//                                 _userInputController.text.trim();
//                             if (userMessage.isNotEmpty) {
//                               setState(() {
//                                 _chatMessages.add(
//                                   ChatBubble(
//                                     message: userMessage,
//                                     sender: "User",
//                                   ),
//                                 );
//                               });

//                               // Call OpenAI API and update chat
//                               _completionFun(userMessage);

//                               _userInputController.clear();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatScreen extends StatefulWidget {
//   final List<ChatBubble> chatMessages;
//   final ScrollController scrollController;

//   const ChatScreen({
//     Key? key,
//     required this.chatMessages,
//     required this.scrollController,
//   }) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       controller: widget.scrollController,
//       itemCount: widget.chatMessages.length,
//       itemBuilder: (context, index) {
//         return widget.chatMessages[index];
//       },
//     );
//   }

//   void _scrollToBottom() {
//     if (widget.scrollController.hasClients) {
//       widget.scrollController.animateTo(
//         widget.scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   @override
//   void didUpdateWidget(covariant ChatScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     // Check if new messages are added before scrolling
//     if (widget.chatMessages.length > oldWidget.chatMessages.length) {
//       _scrollToBottom();
//     }
//   }
// }

// class ChatBubble extends StatelessWidget {
//   final String message;
//   final String sender;

//   const ChatBubble({
//     Key? key,
//     required this.message,
//     required this.sender,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: sender == "User" ? Colors.blueAccent : Colors.grey,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Text(
//         message,
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }

// class ResponseModel {
//   List<Map<String, dynamic>> choices;

//   ResponseModel({required this.choices});

//   factory ResponseModel.fromJson(Map<String, dynamic> json) {
//     return ResponseModel(
//       choices: List<Map<String, dynamic>>.from(json['choices']),
//     );
//   }
// }
