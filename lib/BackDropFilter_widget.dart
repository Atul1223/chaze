import 'package:flutter/material.dart';
import 'dart:ui';

class BackDropFilterWidget extends StatelessWidget {
  const BackDropFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        );
  }
}
