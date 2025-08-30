
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/features/personas/%20nova/presentation/widgets/nova_widgets.dart';

class NovaGroceryDialog extends StatefulWidget {
  const NovaGroceryDialog({super.key});

  @override
  State<NovaGroceryDialog> createState() => _NovaGroceryDialogState();
}

class _NovaGroceryDialogState extends State<NovaGroceryDialog> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              //colors: [Color(0xFF8F54FF), Color(0xFF4E9FFF)],
              colors : [
                  Color(0xFFA974FF), // lighter purple
                  Color(0xFF6EB5FF), // lighter blue
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.2, 0.8],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Add to Grocery List',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_itemNameController, 'Item Name'),
            const SizedBox(height: 10),
            //Quanity + unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(_quantityController, 'Quantity'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 3,
                  child: NovaDropDown(),
                  //   child: DropdownButton2<String>(
                  //     items: ["litre","pcs/kg", "g",  "ml", "bunch", "packet"]
                  //         .map((e) => DropdownMenuItem(
                  //             value: e,
                  //             child: Text(
                  //               e,
                  //               style: GoogleFonts.urbanist(
                  //                 fontSize: 16,
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.white,
                  //               ),
                  //             )))
                  //         .toList(),
                  //     decoration: InputDecoration(
                  //       filled: true,
                  //       fillColor: Colors.white.withOpacity(0.25),
                  //       hintText: "Unit",
                  //       hintStyle: GoogleFonts.urbanist(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: Colors.white,

                  //       ),
                  //       contentPadding: const EdgeInsets.symmetric(
                  //         horizontal: 12,
                  //         vertical: 14, // 👈 give breathing room
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //     ),
                  //     dropdownColor: const Color(
                  //         0xFF6A80FF), // matches gradient background
                  //     icon: const Icon(Icons.arrow_drop_down,
                  //         color: Colors.white),

                  //     onChanged: (value) {
                  //       setState(() {
                  //         _selectedUnits = value!;
                  //       });
                  //     },
                  //     value: _selectedUnits,
                  //     style: GoogleFonts.urbanist(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.white,
                  //     ),
                  //     dropdownStyleData: DropdownStyleData(
                  //         maxHeight: 200,
                  //         offset: const Offset(0, 8), // 👈 shift menu down
                  //       ),
                  //      // 👇 fixes overlap
                  //     // offset: const Offset(0, 8), // try 8–12 for perfect spacing
                  //     // menuMaxHeight: 250,
                  //   ),
                  // ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildTextField(_notesController, 'Notes'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade900,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Add to Grocery List',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        ));
  }

  // Container NovaDropDown() {
  //   return 
  // }
}

Widget _buildTextField(TextEditingController controller, String hint) {
  return TextField(
    controller: controller,
    style: GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}
