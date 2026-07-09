import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

import '../widgets/nova_widgets.dart';

class NovaExplorer extends ConsumerStatefulWidget {
  const NovaExplorer({super.key});

  @override
  ConsumerState<NovaExplorer> createState() => _NovaExplorerState();
}

class _NovaExplorerState extends ConsumerState<NovaExplorer> {
  @override
  Widget build(BuildContext context) {
    var theme = ref.watch(personaThemeProvider);
    return GradientBackground(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Explore with Nova'),
        ),
      ),
      body: ZoomIn(
        duration: const Duration(milliseconds: 500),
        child: Stack(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        //show a modal with the grocery list screen
                        showDialog(context: context, builder: (context) => const NovaGroceryDialog());
                      },
                      child: NovaListButton(
                          theme: theme,
                          icon: SvgPicture.asset('assets/images/shopping-cart.svg',
                              width: 20, height: 20),
                          text: 'Add to Grocery List'),
                    ),
                    const SizedBox(height: 20),
                    NovaListButton(
                        theme: theme,
                        icon: SvgPicture.asset(
                            'assets/images/circle-chevron-down.svg',
                            width: 20,
                            height: 20),
                        text: 'Add a To-Do'),
                    const SizedBox(height: 20),
                    NovaListButton(
                        theme: theme,
                        icon: SvgPicture.asset('assets/images/clock-8.svg',
                            width: 20, height: 20),
                        text: 'Set a Reminder'),
                    const SizedBox(height: 20),
                    NovaListButton(
                        theme: theme,
                        icon: SvgPicture.asset('assets/images/mic-vocal.svg',
                            width: 20, height: 20),
                        text: 'Save a Voice Memo'),
                    const SizedBox(height: 20),
                    NovaListButton(
                        theme: theme,
                        icon: SvgPicture.asset('assets/images/zen_yoga.svg',
                            width: 20, height: 20),
                        text: 'Talk to Zen'),
                  ],
                ),
              ),
            ),
        
             Positioned(
              bottom: 100,
              right: 0,
              left: 0,
              child: Column(children: [
                 Text('Or Say: Hey Nova...',
                    style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: theme.appBarIconColor)),
                const SizedBox(height: 20),
                const NovaMic(width: 80, height: 80),
                //const SizedBox(height: 20),
               
              ]),
            )
          ],
        ),
      ),
    ));
  }
}

