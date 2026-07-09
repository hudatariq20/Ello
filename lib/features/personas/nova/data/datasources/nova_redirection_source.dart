import 'package:flutter/material.dart';
import '../../../../../shared/models/shared_models.dart';


class NovaRedirectionSource {
  static List<PersonaRedirection> getTiles() => const [
        PersonaRedirection(
          icon: Icons.person_outline,
          title: "Nova",
          subtitle: "Helpful",
          gradientColors: [
            Color(0xFF42A5F5),
            Color(0xFF64B5F6),
            Color(0xFFBBDEFB),
          ],
        ),
        PersonaRedirection(
          icon: Icons.self_improvement,
          title: "Zen",
          subtitle: "Mindful",
          gradientColors: [
            Color(0xFFE858FF),
            Color(0xFF8F54FF),
            Color(0xFF4E9FFF),
          ],
        ),
        PersonaRedirection(
          icon: Icons.flash_on,
          title: "Spark",
          subtitle: "Energetic",
          gradientColors: [
            Color(0xFFFFB74D),
            Color(0xFFFF8A65),
            Color(0xFFFFCC80),
          ],
        ),
        PersonaRedirection(
          icon: Icons.school,
          title: "Sage",
          subtitle: "Wise",
          gradientColors: [
            Color(0xFF8D6E63),
            Color(0xFF6D4C41),
            Color(0xFFA1887F),
          ],
        ),
      ];
}
