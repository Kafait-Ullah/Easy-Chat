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
                  "You are a helpful $_systemRole so welcome with one line intro about yourself. Provide useful answers related to $_systemRole. If someone asks about another field instead of $_systemRole, politely inform them about your specialization in $_systemRole."
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
          responseTxt = 'I am here to help with $_systemRole-related queries.';
        } else {
          final rolePrefix = '$_systemRole: ';
          responseTxt = openAIResponse.startsWith(rolePrefix)
              ? openAIResponse.substring(rolePrefix.length)
              : openAIResponse;
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

    _scrollToBottom();

    setState(() {});
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
      setState(() {
        _chatMessages.add(
          ChatBubble(
            message: userMessage,
            sender: "User",
          ),
        );
      });

      _completionFun(userMessage);

      _userInputController.clear();
      _textFieldFocusNode.requestFocus();
    }
  }

  void _resetScreen() {
    setState(() {
      _chatMessages.clear();
      responseTxt = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
              _resetScreen();
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  left: 50, right: 50, top: 15, bottom: 10),
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
                            focusNode: _textFieldFocusNode,
                            onSubmitted: (String value) {
                              _sendMessage();
                            },
                            cursorColor: Colors.black45,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  color: Color.fromARGB(255, 15, 84, 77),
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
