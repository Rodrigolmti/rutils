import 'package:flutter/material.dart';

Future<T?> customBottomSheet<T>({
  required BuildContext context,
  required Widget body,
  double padding = 24,
  bool showIndicator = true,
  bool isDismissible = true,
  bool isScrollControlled = true,
}) =>
    showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (context) => FractionallySizedBox(
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (showIndicator)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFD5DAE2),
                    ),
                    height: 3,
                    width: 44,
                  ),
                if (showIndicator) const SizedBox(height: 32),
                body
              ],
            ),
          ),
        ),
      ),
    );
