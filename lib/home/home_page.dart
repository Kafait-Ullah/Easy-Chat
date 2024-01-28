import 'dart:async';
import 'dart:convert';
import 'package:easy_chat/home/chat_bubble.dart';
import 'package:easy_chat/home/chat_screen.dart';
import 'package:easy_chat/home/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final TextEditingController _userInputController = TextEditingController();
  final List<ChatBubble> _chatMessages = [];
  String responseTxt = '';
  late ResponseModel _responseModel;
  String _systemRole = "generic";
  final FocusNode _textFieldFocusNode = FocusNode();
  late ScrollController _scrollController;

  Future<void> _completionFun(String userMessage) async {
    setState(() => responseTxt = 'Loading...');

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['OPENAI_KEY']}',
      },
      body: jsonEncode(
        {
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a helpful $_systemRole. You only give info about the $_systemRole field and whenever someone is asking instead of that give only one line answer and positively change the answer to the $_systemRole. Say sorry, I can assist you only about $_systemRole field."
            },
            {"role": "user", "content": userMessage},
          ],
          "max_tokens": 250,
          "temperature": 0,
          "top_p": 1,
        },
      ),
    );

    try {
      final Map<String, dynamic> responseMap = jsonDecode(response.body);

      if (responseMap['choices'] is List && responseMap['choices'].isNotEmpty) {
        _responseModel = ResponseModel.fromJson(responseMap);
        final openAIResponse = _responseModel.choices[0]['message']['content'];

        if (openAIResponse.contains('not in my domain')) {
          // Provide a short answer for queries not relevant to the role
          responseTxt = 'I am here to help with $_systemRole-related queries.';
        } else {
          // Display the response along with information about the role
          responseTxt = '$_systemRole: $openAIResponse';
        }

        _chatMessages.add(ChatBubble(message: responseTxt, sender: "OpenAI"));
      } else {
        print('Unexpected response format: $responseMap');
        responseTxt = 'Unexpected response format';
      }
    } catch (e) {
      print('Error decoding response: $e');
      responseTxt = 'Error decoding response';
    }

    // Scroll to the bottom after adding a new message
    _scrollToBottom();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _sendMessage() {
    final userMessage = _userInputController.text.trim();
    if (userMessage.isNotEmpty) {
      // Add the user's message to the chat
      setState(() {
        _chatMessages.add(
          ChatBubble(
            message: userMessage,
            sender: "User",
          ),
        );
      });

      // Call OpenAI API and update chat
      _completionFun(userMessage);

      // Clear the input field
      _userInputController.clear();

      // Request focus back to the text field
      _textFieldFocusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyDrawer(
            systemRole: _systemRole,
            onRoleChanged: (value) {
              setState(() {
                _systemRole = value.toLowerCase();
              });
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ai Assistant',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(width: 5),
                      const FaIcon(
                        Icons.assistant_outlined,
                        size: 25,
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ChatScreen(
                      chatMessages: _chatMessages,
                      scrollController: _scrollController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _userInputController,
                            focusNode: _textFieldFocusNode, // Add this line

                            onSubmitted: (String value) {
                              _sendMessage();
                            },
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () {
                                  _sendMessage();
                                },
                              ),
                              hintText: 'Type your message...',
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponseModel {
  List<Map<String, dynamic>> choices;

  ResponseModel({required this.choices});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      choices: List<Map<String, dynamic>>.from(json['choices']),
    );
  }
}
