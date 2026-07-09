import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NovaTaskTodoCard extends StatefulWidget {
  final String task;
  final String? description;
  final DateTime? deadline;
  const NovaTaskTodoCard(
      {super.key, required this.task, this.description, this.deadline});

  @override
  State<NovaTaskTodoCard> createState() => _NovaTaskTodoCardState();
}

class _NovaTaskTodoCardState extends State<NovaTaskTodoCard> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    // A task is overdue if deadline is before todayStart
    final isOverdue =
        widget.deadline != null && widget.deadline!.isBefore(todayStart);

    final formattedOverdue = widget.deadline != null
        ? DateFormat("d MMM").format(widget.deadline!)
        : "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blueAccent.withOpacity(0.5), // 🔥 bright blue border
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<bool>(
            value: true,
            groupValue: _isSelected,
            onChanged: (val) {
              setState(() {
                _isSelected = !_isSelected;
              });
            },
            //color decided based on priorty.
            visualDensity: VisualDensity.compact, // 🔥 reduces extra padding
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Colors.blueAccent,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (widget.description != null &&
                    widget.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.description!,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],

                const SizedBox(height: 4),
                //THIS ROW WILL ONLY DISPLAY IN OVERDUE TASKS.
                if (isOverdue) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.deadline != null ? formattedOverdue : "",
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
