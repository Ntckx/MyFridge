import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import '../theme/color_theme.dart';

class EatenCard extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onEaten;

  const EatenCard(
      {super.key, required this.initialQuantity, required this.onEaten});
  @override
  EatenCardState createState() => EatenCardState();
}

class EatenCardState extends State<EatenCard> {
  late int inputQty;

  @override
  void initState() {
    super.initState();
    inputQty = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'How many have you eaten?',
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              color: AppColors.darkblue,
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                child: InputQty.int(
                  qtyFormProps: const QtyFormProps(
                      cursorColor: AppColors.darkblue,
                      style: TextStyle(
                        color: AppColors.darkblue,
                      )),
                  decoration: const QtyDecorationProps(
                    qtyStyle: QtyStyle.btnOnRight,
                    orientation: ButtonOrientation.vertical,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.darkblue,
                      ),
                    ),
                    btnColor: AppColors.darkblue,
                    fillColor: AppColors.grey,
                    borderShape: BorderShapeBtn.square,
                    plusBtn: Icon(
                      Icons.arrow_drop_up_rounded,
                      color: AppColors.darkblue,
                    ),
                    minusBtn: Icon(
                      Icons.arrow_drop_down_rounded,
                      color: AppColors.darkblue,
                    ),
                  ),
                  minVal: 1,
                  initVal: inputQty,
                  onQtyChanged: (val) {
                    setState(() {
                      inputQty = val;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onEaten(inputQty);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
