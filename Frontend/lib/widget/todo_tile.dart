import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget {
  final String itemsName;
  final bool isChecked;
  Function(bool?)? onChanged;

  ToDoTile({
    super.key,
    required this.itemsName,
    required this.isChecked,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left:25.0, right: 25.0, top: 25.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [Checkbox(value: isChecked, onChanged: onChanged, activeColor: Colors.black),
              Text(itemsName, style: TextStyle(decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none),
        )],
          ),
        ));
  }
}
