import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemsTile extends StatelessWidget {
  final String itemsName;
  final bool isChecked;
  final String expirationDate;
  final String description;
  final String storageLocation;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteItem;

  ItemsTile(
      {super.key,
      required this.itemsName,
      required this.isChecked,
      required this.expirationDate,
      required this.description,
      required this.storageLocation,
      required this.onChanged,
      required this.deleteItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
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
              const SizedBox(width: 8), // Adding space between checkbox and text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemsName,
                      style: TextStyle(
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4), // Adding space between lines
                    Text(
                      'Expiration Date: $expirationDate',
                      style: TextStyle(
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4), 
                    Text(
                      'Description: $description',
                      style: TextStyle(
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 4), 
                    Text(
                      'Storage Location: $storageLocation',
                      style: TextStyle(
                        decoration: isChecked
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
