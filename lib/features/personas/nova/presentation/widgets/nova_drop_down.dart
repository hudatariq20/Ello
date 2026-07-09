import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NovaDropDown extends StatefulWidget {
  const NovaDropDown({super.key});

  @override
  State<NovaDropDown> createState() => _NovaDropDownState();
}

class _NovaDropDownState extends State<NovaDropDown> {
  String _selectedUnits = 'pcs/kg';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        //color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton2<String>(
        isExpanded: true,
        value: _selectedUnits,
        hint: Text(
          "Unit",
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        items: ["pcs/kg", "g", "litre", "ml", "bunch", "packet"]
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() => _selectedUnits = value!);
        },

        // Field styling
        buttonStyleData: ButtonStyleData(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Dropdown menu styling
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF6A80FF),
            borderRadius: BorderRadius.circular(12),
          ),
          offset: const Offset(0, 10), // push dropdown below field
        ),

        //  Icon styling
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          iconSize: 24,
        ),

        //  Items styling
        menuItemStyleData: const MenuItemStyleData(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),

      ),
    );
  }
}
