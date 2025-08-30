import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser; //is the prompt from me

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          //  if (!isUser) ProfileBubble(prompt: isUser),
          if (!isUser)
            const SizedBox(
              width: 15,
            ),
          //Container for message
          Container(
            padding: const EdgeInsets.all(15),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            decoration: BoxDecoration(
              color: isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.onSecondary,
              borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(10),
                  topLeft: const Radius.circular(10),
                  bottomRight: Radius.circular(isUser ? 0 : 15),
                  bottomLeft: Radius.circular(isUser ? 15 : 0)),
            ),
            child: Text(
              message,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5A2F9E),
              ),
            ),
          ),

          if (isUser)
            const SizedBox(
              width: 15,
            ),
          // if (isUser) ProfileBubble(prompt: isUser),
        ],
      ),
    );
  }
}

class ProfileBubble extends StatelessWidget {
  const ProfileBubble({
    super.key,
    required this.prompt,
  });

  final bool prompt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: prompt
              ? Theme.of(context).colorScheme.onSecondary
              : Colors.grey.shade800,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomLeft: Radius.circular(prompt ? 0 : 15),
              bottomRight: Radius.circular(prompt ? 15 : 0))),
      child: Icon(
        prompt ? Icons.person : Icons.laptop,
      ),
    );
  }
}
