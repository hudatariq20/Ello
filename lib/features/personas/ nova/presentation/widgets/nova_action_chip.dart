import 'package:flutter/material.dart';

class NovaActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const NovaActionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color ?? Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: color ?? Colors.black54),
          ),
        ],
      ),
      labelPadding: const EdgeInsets.only(left: 4, right: 8),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      clipBehavior: Clip.antiAlias,
      onPressed: onPressed,
    );
  }
}
