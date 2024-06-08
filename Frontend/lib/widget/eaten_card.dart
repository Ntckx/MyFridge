import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import '../theme/color_theme.dart';

class EatenCard extends StatefulWidget {
  final int initialQuantity;
  final Function(int) onEaten;

  const EatenCard({
    Key? key,
    required this.initialQuantity,
    required this.onEaten,
  }) : super(key: key);

  @override
  _EatenCardState createState() => _EatenCardState();
}

class _EatenCardState extends State<EatenCard> {
  late int inputQty;

  @override
  void initState() {
    super.initState();
    inputQty = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('How many have you eaten?'),
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
                    cursorColor: Colors.black,
                  ),
                  decoration: const QtyDecorationProps(
                    qtyStyle: QtyStyle.btnOnRight,
                    orientation: ButtonOrientation.vertical,
                    btnColor: Colors.black,
                    fillColor: AppColors.whiteSmoke,
                    borderShape: BorderShapeBtn.square,
                    plusBtn: Icon(
                      Icons.arrow_drop_up_rounded,
                      size: 30,
                    ),
                    minusBtn: Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 30,
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
