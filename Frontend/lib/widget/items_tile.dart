import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemsTile extends StatelessWidget {
  final String itemsName;
  final bool isChecked;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteItem;

  ItemsTile(
      {super.key,
      required this.itemsName,
      required this.isChecked,
      required this.onChanged,
      required this.deleteItem
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: deleteItem,
                icon: Icons.delete,
                foregroundColor: Colors.white,
                backgroundColor: Colors.red.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: onChanged,
                    activeColor: Colors.black),
                Text(
                  itemsName,
                  style: TextStyle(
                      decoration: isChecked
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                )
              ],
            ),
          ),
        ));
  }
}
