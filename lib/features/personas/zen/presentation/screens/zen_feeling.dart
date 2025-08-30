import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/zen/presentation/screens/zen_screens.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/services/services.dart';
import 'package:voice_input/shared/widgets/widgets.dart';
import 'package:voice_input/features/personas/zen/presentation/widgets/zen_widgets.dart';

class ZenFeelingChatScreen extends ConsumerStatefulWidget {
  final List<String> starterMessages = [
    "Today was difficult juggling both work and my little one.",
    "Just feeling overwhelmed",
    "Trying my best to stay positive",
    "I'm feeling grateful for the little things",
  ];

  final String? persona;
  ZenFeelingChatScreen({super.key, this.persona});

  @override
  ConsumerState<ZenFeelingChatScreen> createState() =>
      _ZenFeelingChatScreenState();
}

class _ZenFeelingChatScreenState extends ConsumerState<ZenFeelingChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(ChatProvider).reversed.toList();

    return Scaffold(
      appBar: ZenFeelingChatAppBar(),
      resizeToAvoidBottomInset: true, //added
      body: GradientBackground(
        child: ZoomIn(
          // duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: zenStarterChips(widget: widget),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16)),
                  child: ZenTextAndVoice(persona: widget.persona ?? 'Nova')),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class zenStarterChips extends StatelessWidget {
  const zenStarterChips({
    super.key,
    required this.widget,
  });

  final ZenFeelingChatScreen widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.starterMessages.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ZenJournalScreen(
                        persona: widget.persona,
                        initialText: widget.starterMessages[index],
                        heroTag: widget.starterMessages[index],
                      )));
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.purple.withOpacity(0.5),
        child: Hero(
          tag: widget.starterMessages[index],
          child: ZenBubble(
            message: widget.starterMessages[index],
          ),
        ),
      ),
    );
  }
}
