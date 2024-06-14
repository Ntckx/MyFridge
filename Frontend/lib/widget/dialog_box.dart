import 'package:flutter/material.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:input_quantity/input_quantity.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController itemNameController;
  final TextEditingController quantityController;
  VoidCallback onSaved;
  VoidCallback onCanceled;

  DialogBox({
    super.key,
    required this.itemNameController,
    required this.quantityController,
    required this.onSaved,
    required this.onCanceled,
  });

  @override
  _DialogBoxState createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Create list",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.darkblue,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(color: AppColors.darkblue),
                  controller: widget.itemNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Item name",
                    hintText: 'e.g. Milk',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an item name.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                FormField<int>(
                  initialValue: int.tryParse(widget.quantityController.text),
                  validator: (value) {
                    if (value == null || value <= 0) {
                      return 'Invalid quantity';
                    }
                    return null;
                  },
                  builder: (FormFieldState<int> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 50,
                          child: InputQty.int(
                            qtyFormProps: const QtyFormProps(
                                cursorColor: AppColors.darkblue,
                                style: TextStyle(
                                  color: AppColors.darkblue,
                                )),
                            decoration: QtyDecorationProps(
                              qtyStyle: QtyStyle.btnOnRight,
                              orientation: ButtonOrientation.vertical,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: state.hasError
                                      ? AppColors.red
                                      : AppColors.darkblue,
                                ),
                              ),
                              btnColor: AppColors.darkblue,
                              fillColor: AppColors.grey,
                              borderShape: BorderShapeBtn.square,
                              plusBtn: const Icon(
                                Icons.arrow_drop_up_rounded,
                                color: AppColors.darkblue,
                              ),
                              minusBtn: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.darkblue,
                              ),
                            ),
                            minVal: 1,
                            initVal:
                                int.tryParse(widget.quantityController.text) ?? 0,
                            onQtyChanged: (val) {
                              state.didChange(val);
                              setState(() {
                                widget.quantityController.text = val.toString();
                              });
                            },
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              state.errorText!,
                              style:
                                  const TextStyle(color: AppColors.red),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: widget.onCanceled,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 1, color: AppColors.darkblue),
                      ),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSaved();
                        }
                      },
                      child: Text('Add',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
