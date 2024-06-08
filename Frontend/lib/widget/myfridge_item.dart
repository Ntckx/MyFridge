import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'eaten_card.dart';
import '../theme/color_theme.dart';

class MyFridgeItemCard extends StatefulWidget {
  final int initialQuantity;
  final String itemName;
  final String expiryDate;
  final bool isExpired;
  final String description;
  final Function(BuildContext)? deleteItem;
  final Function(BuildContext)? editItem;

  const MyFridgeItemCard({
    super.key,
    required this.initialQuantity,
    required this.itemName,
    required this.isExpired,
    required this.expiryDate,
    required this.description,
    required this.deleteItem,
    required this.editItem,
  });

  @override
  _MyFridgeItemCardState createState() => _MyFridgeItemCardState();
}

class _MyFridgeItemCardState extends State<MyFridgeItemCard> {
  late int quantity;

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
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 200,
      width: 450,
      child: Slidable(
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                if (widget.editItem != null) {
                  widget.editItem!(context);
                }
              },
              backgroundColor: Color(0xFF36454F),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: BorderRadius.circular(15),
            ),
            SlidableAction(
              onPressed: (context) {
                if (widget.deleteItem != null) {
                  widget.deleteItem!(context);
                }
              },
              backgroundColor: Color(0xFFEF5350),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
        child: Card(
          color: AppColors.whiteSmoke,
          shape: RoundedRectangleBorder(
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
          style: const TextStyle(color: AppColors.darkblue, fontSize: 30.0),
        ),
        const SizedBox(width: 20),
        Text(
          widget.itemName,
          style: const TextStyle(color: AppColors.darkblue, fontSize: 30.0),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            if (widget.editItem != null) {
              widget.editItem!(context);
            }
          },
          icon: Icon(Icons.edit, color: AppColors.green),
        )
      ],
    );
  }

  Row _buildExpiryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'EXP: ${widget.expiryDate}',
          style: TextStyle(
            fontSize: 20.0,
            color: widget.isExpired ? Color(0xffB75050) : AppColors.darkblue,
          ),
        ),
        if (widget.isExpired)
          const Text(' (Expired!!!)',
              style: TextStyle(color: Color(0xFFB75050), fontSize: 20)),
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
            style: const TextStyle(fontSize: 20.0, color: AppColors.green),
            softWrap: true,
          ),
        ),
        Visibility(
          visible: !widget.isExpired,
          child: ElevatedButton(
            onPressed: () {
              _showEatenCard(context);
            },
            child: Text(
              'Eaten',
              style: TextStyle(fontSize: 25),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.darkblue),
              foregroundColor:
                  MaterialStateProperty.all<Color>(AppColors.cream),
              splashFactory: NoSplash.splashFactory,
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEatenCard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EatenCard(
          initialQuantity: 1,
          onEaten: (int qtyEaten) {
            setState(() {
              // Ensure the quantity does not go below zero
              if (quantity - qtyEaten < 0) {
                quantity = 0;
              } else {
                quantity -= qtyEaten;
              }
            });
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
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                ),
                Text(
                  'EXP: ${widget.expiryDate}',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: widget.isExpired ? Color(0xffB75050) : Colors.black,
                  ),
                ),
                Text(
                  'Description: ${widget.description}',
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF5E92A3)),
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
