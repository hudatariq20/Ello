import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

import '../../data/models/mood_model.dart';

class ZenJournalScreen extends ConsumerStatefulWidget {
  final String? persona;
  final String initialText;
  final String? heroTag;
  ZenJournalScreen(
      {super.key,
      this.persona,
      required this.initialText,
      required this.heroTag}) {
    debugPrint('initialText: $initialText');
  }

  @override
  ConsumerState<ZenJournalScreen> createState() => _ZenJournalScreenState();
}

class _ZenJournalScreenState extends ConsumerState<ZenJournalScreen> {
  String? selectedMood;
  late TextEditingController _journalController;
  bool _showTextField = false;

  @override
  void initState() {
    super.initState();
    _journalController = TextEditingController(text: widget.initialText);
    Future.delayed(const Duration(milliseconds: 700), () {
      setState(() {
        _showTextField = true;
      });
    });
  }

  void _selectMood(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    return Scaffold(
        body: GradientBackground(
            //zen journal screen
            child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.appBarIconColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                //const SizedBox(width: 8),
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                      fontSize: 24,
                      color: theme.appBarIconColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Rubik'),
                ),
              ],
            ),
            //title
            //replace the text with the initial text from the feeling screen

            const SizedBox(height: 8),
            //mood emoji picker with a selected mood indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: moodOptions
                  .map((mood) => GestureDetector(
                        onTap: () => _selectMood(mood.emoji),
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedMood == mood.emoji
                                ? theme.appBarIconColor
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            mood.emoji,
                            style: TextStyle(
                                fontSize: 24,
                                color: selectedMood == mood.emoji
                                    ? Colors.white
                                    : theme.appBarIconColor),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            //journal entry text field
            Hero(
              tag: widget.heroTag ?? '',
              child: Material(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2ECFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.appBarIconColor.withOpacity(0.5),
                        width: 1.5),
                  ),
                  child: AnimatedOpacity(
                    opacity: _showTextField ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 700),
                    child: Stack(children: [
                      TextField(
                        controller: _journalController,
                        autofocus: true,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Rubik'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.transparent,
                          hintText: widget.initialText,
                          hintStyle: TextStyle(
                              color: theme.appBarIconColor.withOpacity(0.5)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.mic_none,
                              color: theme.appBarIconColor),
                          onPressed: () {
                            // Trigger voice input
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //instead of elevated button, using a container with background color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFCBAEFF),
                // gradient:const LinearGradient(
                //   colors: [
                //     Color(0xFFE5CDFF),
                //     Color(0xFFCBAEFF),
                //   ],
              ),
              child: const Center(
                child: Text(
                  'Save Entry',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
                child: const Text(
              '📜 View Past Entries',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Rubik'),
            ))
          ],
        ),
      ),
    )));
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }
}
