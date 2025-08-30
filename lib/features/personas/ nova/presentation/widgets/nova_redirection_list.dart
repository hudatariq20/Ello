import 'package:flutter/material.dart';
import '../../../../../shared/models/shared_models.dart';
import '../../../../../shared/widgets/widgets.dart';

class NovaRedirectionList extends StatelessWidget {
  const NovaRedirectionList({
    super.key,
    required this.theme,
    required this.redirectionTiles,
  });

  final PersonaTheme theme;
  final List<PersonaRedirection> redirectionTiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        color: theme.appBarColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SizedBox(
        // Remove Expended and use SizedBox for Height Control
        height: 70, // Controll heigh with SizedBox.
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: redirectionTiles.length,
          itemBuilder: (BuildContext context, int index) {
            final tile = redirectionTiles[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 100,
                child: PersonaCard(
                  icon: tile.icon,
                  title: tile.title,
                  subtitle: tile.subtitle,
                  gradientColors: tile
                      .gradientColors, 
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}