import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StarterChips extends StatelessWidget {
  final List<String> chipPhrase;
  final void Function(String) onChipSelected;
  const StarterChips(
      {super.key, required this.chipPhrase, required this.onChipSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Center(
            child: Text(
              'Tap the mic and say what you need:',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: chipPhrase
                .map((phrase) => GestureDetector(
                      onTap: () => onChipSelected(phrase),
                      child: Chip(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        label: Text(
                          phrase,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        //backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.surface),
                        ),
                        //onDeleted: () => onChipSelected(phrase),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
