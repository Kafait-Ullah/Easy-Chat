import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String sender;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sender == "User"
            ? const Color.fromARGB(255, 8, 19, 38)
            : const Color.fromARGB(255, 15, 84, 77),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
