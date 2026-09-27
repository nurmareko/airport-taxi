// error_widgets.dart
import 'package:flutter/material.dart';

class ErrorWidgets {
  static Widget buildErrorMessageWidget(
    String errorMessage,
    String message,
    IconData icon,
    Color iconColor,
    Color borderColor,
    Color backgroundColor,
    Color buttonColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.0),
        color: backgroundColor.withOpacity(0.3),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
