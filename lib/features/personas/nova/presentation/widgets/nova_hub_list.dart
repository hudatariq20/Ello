import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/widgets/task_tile.dart';
import '../../../../../shared/models/shared_models.dart';

class HubList extends StatelessWidget {
  const HubList({
    super.key,
    required this.theme,
    required this.tasksAsync,
  });

  final PersonaTheme theme;
  final AsyncValue<List<TaskItem>> tasksAsync;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height *
            0.55, // Adjust height as needed
        decoration: BoxDecoration(
          color: theme.appBarColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.gradientColors[0].withOpacity(0.5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Talking to :Nova",
                        style: GoogleFonts.urbanist(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ]),
              ),
            ),
            const SizedBox(
              height: 10,
            ), // Add spacing between the text and the list
            Expanded(
              child: tasksAsync.when(
                data: (tasks) => ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      icon: task.icon!,
                      title: task.title,
                      detail: task.detail,
                      
                    );
                  },
                ),
                error: (error, stack) => Text('Error: $error'),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.appBarColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.alarm_add_rounded,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "View Task History",
                          style: GoogleFonts.urbanist(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
