
import 'package:easy_chat/home/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final List<ChatBubble> chatMessages;
  final ScrollController scrollController;

  const ChatScreen({
    Key? key,
    required this.chatMessages,
    required this.scrollController,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.chatMessages.length,
      itemBuilder: (context, index) {
        return widget.chatMessages[index];
      },
    );
  }

  void _scrollToBottom() {
    if (widget.scrollController.hasClients) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void didUpdateWidget(covariant ChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if new messages are added before scrolling
    if (widget.chatMessages.length > oldWidget.chatMessages.length) {
      _scrollToBottom();
    }
  }
}