import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class ItemsTile extends StatelessWidget {
  final String itemsName;
  final bool isChecked;
  final int quantity;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteItem;

  ItemsTile(
      {super.key,
      required this.itemsName,
      required this.isChecked,
      required this.quantity,
      required this.onChanged,
      required this.deleteItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 25),
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
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.darkblue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Stack(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              quantity.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: AppColors.cream,
                                  ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: Text(
                              itemsName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: AppColors.cream,
                                  ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isChecked)
                      Positioned.fill(
                        child: Divider(
                          color: AppColors.black,
                          thickness: 0.5,
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
