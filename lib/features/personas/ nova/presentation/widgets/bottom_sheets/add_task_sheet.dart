import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../nova_widgets.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "e.g., Practice math problems daily at 4pm",
              hintStyle: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: " Description ",
              hintStyle: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              border: InputBorder.none, // 🔥 clean, no box
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                NovaActionChip(
                    icon: Icons.today,
                    label: 'Today',
                    onPressed: () {},
                    color: Colors.green[800]),
                const SizedBox(width: 4),
                NovaActionChip(
                    icon: Icons.track_changes,
                    label: 'Deadline',
                    onPressed: () {}),
                const SizedBox(width: 4),
                NovaActionChip(
                    icon: Icons.flag_outlined,
                    label: 'Priority',
                    onPressed: () {}),
                const SizedBox(width: 4),
                NovaActionChip(
                    icon: Icons.alarm, label: 'Reminder', onPressed: () {}),
                const SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus(); // 👈 hide keyboard
              // collect title/description here
              Navigator.pop(context); // close sheet
            },
            child: const Text("Save Task"),
          ),
        ],
      ),
    );
  }
}
