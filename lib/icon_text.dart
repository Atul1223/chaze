import 'package:flutter/material.dart';

class TextWithIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const TextWithIcon({super.key, 
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
