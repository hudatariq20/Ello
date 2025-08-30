import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/screens/screens.dart';

class ZenFeelingChatAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  ZenFeelingChatAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(personaThemeProvider);
    return AppBar(
      elevation: 4,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 100,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Zen',
            style: TextStyle(
                fontSize: 48, fontWeight: FontWeight.w400, fontFamily: 'Rubik'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.self_improvement,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              const Text(
                'Journal',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Rubik',
                    color: Color.fromARGB(255, 77, 51, 87)),
              ),
            ],
          ),
        ],
      ),

      //const Text('Zen', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w400, fontFamily: 'Rubik'),),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
