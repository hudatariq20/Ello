import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/screens/screens.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  ChatAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(personaThemeProvider);
    return AppBar(
      elevation: 4,
      surfaceTintColor: Colors.transparent,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(Icons.more_vert, color: theme.appBarIconColor),
            // icon: const Icon(Icons.more_vert, color: Color(0xFF8F54FF)),//ZEN
            //icon: const Icon(Icons.more_vert, color: Color(0xFF1565C0)), //NOVA
            onPressed: () {
              //open the persona presets screen
              //should when i open new screen, the old state should be saved
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonaPresets(initialText: ""),
                ),
              );
              // Add your menu action here
              //change the voice assistant here
            },
          ),
        ),
      ],
    );
    // return AppBar(
    //   title: BounceIn(child: const Text('AIA Orbis')),
    //   leading: const Icon(Icons.menu),
    //   centerTitle: true,
    //   elevation: 4,
    //   surfaceTintColor: Colors.transparent,
    //   backgroundColor: Theme.of(context)
    //       .colorScheme
    //       .secondaryContainer,
    //   shadowColor: Theme.of(context).colorScheme.shadow, // M3 shadow color
    //   actions: [
    //     Container(
    //       margin: const EdgeInsets.only(right: 8),
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //         color: Colors.white,
    //       ),
    //       child: IconButton(
    //         icon: const Icon(Icons.more_vert, color: Colors.black),
    //         onPressed: () {
    //           // Add your menu action here
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
