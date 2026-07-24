import 'package:flutter/material.dart';
import 'package:voice_input/features/ello/presentation/models/ello_intro_data.dart';
import 'package:voice_input/shared/theme/persona_presets.dart';

class ElloIntroCard extends StatelessWidget {
  final ElloIntroData data;
  final VoidCallback onTap;

  const ElloIntroCard({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final personaTheme = personaThemes[data.type]!;

    return Material(
      color: Colors.white.withOpacity(0.55),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 14,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: 28,
                color: personaTheme.appBarIconColor,
              ),
              const SizedBox(height: 12),
              Text(
                data.category,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}