import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'eaten_card.dart';
import '../theme/color_theme.dart';
import '../services/api_service.dart';

class MyFridgeItemCard extends StatefulWidget {
  final int itemId;
  final int initialQuantity;
  final String itemName;
  final String expiryDate;
  final bool isExpired;
  final String description;
  final Function(BuildContext)? deleteItem;
  final Function(BuildContext)? editItem;
  final Future<void> Function() fetchItems;

  const MyFridgeItemCard({
    super.key,
    required this.itemId,
    required this.initialQuantity,
    required this.itemName,
    required this.isExpired,
    required this.expiryDate,
    required this.description,
    required this.deleteItem,
    required this.editItem,
    required this.fetchItems,
  });

  @override
  MyFridgeItemCardState createState() => MyFridgeItemCardState();
}

class MyFridgeItemCardState extends State<MyFridgeItemCard> {
  late int quantity;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  String getShortDescription(String fullDescription) {
    final words = fullDescription.split(' ');
    if (words.length <= 5) return fullDescription;
    return '${words.sublist(0, 5).join(' ')}...';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 200,
      width: 450,
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            // SlidableAction(
            //   onPressed: (context) {
            //     if (widget.editItem != null) {
            //       widget.editItem!(context);
            //     }
            //   },
            //   backgroundColor: const Color(0xFF36454F),
            //   foregroundColor: Colors.white,
            //   icon: Icons.edit,
            //   label: 'Edit',
            //   borderRadius: BorderRadius.circular(15),
            // ),
            SlidableAction(
              onPressed: (context) {
                if (widget.deleteItem != null) {
                  widget.deleteItem!(context);
                }
              },
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Card(
          color: AppColors.grey,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: InkWell(
            onTap: () => _showItemDetails(context),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 2),
                  _buildExpiryRow(),
                  const SizedBox(height: 2.0),
                  _buildDescriptionRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          quantity.toString(),
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.darkblue,
              ),
        ),
        const SizedBox(width: 20),
        Text(
          widget.itemName,
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.darkblue,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (widget.editItem != null) {
              widget.editItem!(context);
            }
          },
          icon: const Icon(Icons.edit, color: AppColors.green),
        )
      ],
    );
  }

  Row _buildExpiryRow() {
    final expirationDate = DateTime.parse(widget.expiryDate);
    final formattedDate = DateFormat('yyyy-MM-dd').format(expirationDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'EXP: $formattedDate',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: widget.isExpired
                    ? const Color(0xffB75050)
                    : AppColors.darkblue,
              ),
        ),
        if (widget.isExpired)
          Text(
            ' (Expired!!!)',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: const Color(0xFFB75050)),
          )
      ],
    );
  }

  Row _buildDescriptionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            getShortDescription(widget.description),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: AppColors.green),
            softWrap: true,
          ),
        ),
        Visibility(
          visible: !widget.isExpired,
          child: ElevatedButton(
            onPressed: () {
              _showEatenCard();
            },
            child: Text(
              'Eaten',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.grey),
            ),
          ),
        ),
      ],
    );
  }

  void _showEatenCard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EatenCard(
          initialQuantity: 1,
          onEaten: (int qtyEaten) async {
            try {
              await _apiService.markItemAsEaten(widget.itemId, qtyEaten);
              await widget.fetchItems();
            } catch (e) {
              Logger('Error marking item as eaten: $e');
            }
          },
        );
      },
    );
  }

  void _showItemDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AlertDialog(
            title: Text(widget.itemName),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ${quantity.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'EXP: ${widget.expiryDate}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: widget.isExpired
                            ? const Color(0xffB75050)
                            : Colors.black,
                      ),
                ),
                Text(
                  'Description: ${widget.description}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
