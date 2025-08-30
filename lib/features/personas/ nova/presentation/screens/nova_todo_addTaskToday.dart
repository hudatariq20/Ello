import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../shared/providers/providers.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../data/mock/mock_todos.dart';
import '../../domain/usecases/filter_todos.dart';
import '../widgets/nova_widgets.dart';

class NovaTodoAddTaskToday extends ConsumerStatefulWidget {
  const NovaTodoAddTaskToday({super.key});

  @override
  ConsumerState<NovaTodoAddTaskToday> createState() =>
      _NovaTodoAddTaskTodayState();
}

class _NovaTodoAddTaskTodayState extends ConsumerState<NovaTodoAddTaskToday> {
  int _currentIndex = 1;
  int _pageIndex = 1;
  final overdueTasks = getOverdueTasks(mockTodos);
  final todayTasks = getTodayTasks(mockTodos);
  PageController _controller = PageController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat("d MMM • EEEE").format(DateTime.now());

    var theme = ref.watch(personaThemeProvider);

    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "Today",
              style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          bottomNavigationBar: NovaTodoNavbar(
            currentIndex: _currentIndex,
            onTap: _onTabSelected,
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: theme.appBarColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_pageIndex == 0) ...[
                                Text(
                                  "Overdue",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ] else if (_pageIndex == 1) ...[
                                Text(
                                  formatted,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),

                              /// ---- Task Card ----
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: PageView(
                                    controller: _controller,
                                    onPageChanged: (index) {
                                      setState(() => _pageIndex =
                                          index); // 👈 updates pageIndex
                                    },
                                    children: [
                                      ListView(
                                        children: overdueTasks
                                            .map((task) => NovaTaskTodoCard(
                                                  task: task.task,
                                                  description: task.description,
                                                  deadline: task.deadline,
                                                ))
                                            .toList(),
                                      ),
                                      ListView(children: [
                                        ...todayTasks
                                            .map((task) => NovaTaskTodoCard(
                                                  task: task.task,
                                                  description: task.description,
                                                  deadline: task.deadline,
                                                ))
                                            .toList(),
                                        // Add button comes right after today’s list
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: AddTaskButton(onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled:
                                                  true, // <-- makes it go above keyboard
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            16)),
                                              ),
                                              backgroundColor: Colors
                                                  .transparent, //Remove the white color.
                                              builder: (context) => Container(
                                                  decoration: BoxDecoration(
                                                    color: theme.appBarColor,
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                            top:
                                                                Radius.circular(
                                                                    16)),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 12),
                                                  child: const AddTaskSheet()),
                                            );
                                            // open bottom sheet here later
                                          }),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ),
                              ),

                              Center(
                                child: SmoothPageIndicator(
                                  controller: _controller,
                                  count: 2, // only Overdue + Today
                                  effect: const WormEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: Colors.blueAccent,
                                    dotColor: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  height: 20), // Added vertical space
                            ],
                          ),
                        ),
                      ),
                      // The AddTaskButton will be moved here
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: ClipOval(
            child: FloatingActionButton(
              backgroundColor: Colors.blueAccent.shade400,
              child: const Icon(Icons.mic, color: Colors.white),
              onPressed: () {},
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}

class AddTaskButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddTaskButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.add, color: Colors.blueAccent),
          const SizedBox(width: 8),
          InkWell(
            onTap: onTap,
            child: Text(
              'Add Task',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
