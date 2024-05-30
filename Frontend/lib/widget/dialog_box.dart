import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSaved;
  VoidCallback onCanceled;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSaved,
    required this.onCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a new item',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onSaved,
                  child: Text('Save'),
                ),
                TextButton(
                  onPressed: onCanceled,
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}