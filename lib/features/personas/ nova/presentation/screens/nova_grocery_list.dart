import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../shared/providers/providers.dart';
import '../../../../../shared/widgets/widgets.dart';
import '../../domain/entities/nova_entities.dart';
import '../providers/grocery_respository_provider.dart';
import '../widgets/nova_widgets.dart';

class NovaGroceryList extends ConsumerStatefulWidget {
  const NovaGroceryList({super.key});

  @override
  ConsumerState<NovaGroceryList> createState() => _NovaGroceryListState();
}

class _NovaGroceryListState extends ConsumerState<NovaGroceryList> {
  @override
  Widget build(BuildContext context) {
    final activeGroceries = ref.watch(activeGroceriesProvider);
    final completedGroceries = ref.watch(completedGroceriesProvider);
    var theme = ref.watch(personaThemeProvider);
    //final player = AudioPlayer();

    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Groceries'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              // Panel grows with content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.appBarColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const GroceryHeading(title: 'Active Groceries'),
                      activeGroceries.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return Text(
                              "No active items",
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            );
                          }
                          return Column(
                            children: items
                                .map((item) => ActiveGroceries(item: item))
                                .toList(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text("Error: $e"),
                      ),
                      const GroceryHeading(title: 'Completed Groceries'),
                      completedGroceries.when(
                        data: (items) {
                          if (items.isEmpty) {
                            return Text(
                              "No completed items",
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                            );
                          }
                          return Column(
                            children: items
                                .map((item) => CompletedGroceries(item: item))
                                .toList(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text("Error: $e"),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          ref
                              .read(groceryRepositoryProvider)
                              .clearCompletedGroceries("demoUser");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Clear All Completed',
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        //  Add Grocery button fixed at bottom
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (context) => const NovaGroceryDialog());
                    },
                    child: Text(
                      'Add Grocery',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
        //const SizedBox(height: 100),
      ),
    );
  }
}

class ActiveGroceries extends StatelessWidget {
  final GroceryItem item;
  ActiveGroceries({super.key, required this.item});
  final player = AudioPlayer();
  void _playPopSound() {
    player.play(AssetSource('/sounds/pop.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.local_grocery_store_outlined,
                  color: Colors.black, size: 20),
              const SizedBox(width: 10),
              Text(
                item.name,
                style: GoogleFonts.urbanist(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ]),
            Consumer(builder: (context, ref, child) {
              return Row(
                children: [
                  Text(
                    "${item.quantity}x",
                    style: GoogleFonts.urbanist(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Checkbox(
                    value: item.purchased,
                    onChanged: (value) {
                      //MOVE TO THE COMPLETED LIST
                      if (value == true) {
                        _playPopSound(); // 🔊 play pop
                        ref
                            .read(groceryRepositoryProvider)
                            .addtoCompleted("demoUser", item);
                      }
                      //ref.read(groceryRepositoryProvider).addtoCompleted("demoUser", item);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    side: const BorderSide(color: Colors.blueGrey, width: 2),
                  )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class CompletedGroceries extends StatelessWidget {
  final GroceryItem item;
  const CompletedGroceries({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.menu, color: Colors.black, size: 20),
              const SizedBox(width: 10),
              Text(
                item.name,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                  decorationThickness: 2,
                  decorationColor: Colors.black,
                ),
              ),
            ]),
            Consumer(builder: (context, ref, child) {
              return InkWell(
                onTap: () {
                  ref
                      .read(groceryRepositoryProvider)
                      .reAddToActive("demoUser", item);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Re-add",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class GroceryHeading extends StatelessWidget {
  final String title;
  const GroceryHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.w500),
      ),
    );
  }
}
