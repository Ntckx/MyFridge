import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:flutter/services.dart';

class EditItemInMyFridge extends StatefulWidget {
  final Function(String, String, int, String) updateItem;
  final String itemName;
  final String expiryDate;
  final int quantity;
  final String description;

  const EditItemInMyFridge({
    super.key,
    required this.updateItem,
    required this.itemName,
    required this.expiryDate,
    required this.quantity,
    required this.description,
  });

  @override
  EditItemInMyFridgeState createState() => EditItemInMyFridgeState();
}

class EditItemInMyFridgeState extends State<EditItemInMyFridge> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _expiryDateController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.itemName);
    _expiryDateController = TextEditingController(text: widget.expiryDate);
    _quantityController =
        TextEditingController(text: widget.quantity.toString());
    _descriptionController = TextEditingController(text: widget.description);
    _quantity = widget.quantity;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameController.text;
      final expiryDate = _expiryDateController.text;
      final description = _descriptionController.text;

      widget.updateItem(itemName, expiryDate, _quantity, description);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(),
            ),
          ),
          Center(
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Edit',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.darkblue,
                    ),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Name',
                                style: TextStyle(color: AppColors.darkblue)),
                            TextFormField(
                              controller: _itemNameController,
                              style: const TextStyle(color: AppColors.darkblue),
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkblue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkblue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                fillColor: AppColors.grey,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the item name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Quantity',
                                    style:
                                        TextStyle(color: AppColors.darkblue)),
                                FormField<int>(
                                  initialValue: _quantity,
                                  validator: (value) {
                                    if (value == null ||
                                        value <= 0 ||
                                        value > 99) {
                                      return 'Invalid quantity';
                                    }
                                    return null;
                                  },
                                  builder: (FormFieldState<int> state) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 150,
                                          child: InputQty.int(
                                            qtyFormProps: const QtyFormProps(
                                                cursorColor: AppColors.darkblue,
                                                style: TextStyle(
                                                  color: AppColors.darkblue,
                                                )),
                                            decoration: QtyDecorationProps(
                                              qtyStyle: QtyStyle.btnOnRight,
                                              orientation:
                                                  ButtonOrientation.vertical,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: state.hasError
                                                      ? AppColors.red
                                                      : AppColors.darkblue,
                                                ),
                                              ),
                                              btnColor: AppColors.darkblue,
                                              fillColor: AppColors.grey,
                                              borderShape:
                                                  BorderShapeBtn.square,
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
                                            initVal: _quantity,
                                            onQtyChanged: (val) {
                                              state.didChange(val);
                                              setState(() {
                                                _quantity = val;
                                              });
                                            },
                                          ),
                                        ),
                                        if (state.hasError)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              state.errorText!,
                                              style: const TextStyle(
                                                  color: AppColors.red,
                                                  fontSize: 15),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('EXP:',
                                      style:
                                          TextStyle(color: AppColors.darkblue)),
                                  TextFormField(
                                    controller: _expiryDateController,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    style: const TextStyle(
                                        color: AppColors.darkblue),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.darkblue),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.darkblue),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      fillColor: AppColors.grey,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the expiration date';
                                      }
                                      try {
                                        DateTime.parse(value);
                                      } catch (_) {
                                        return 'Invalid date format';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Description',
                                style: TextStyle(color: AppColors.darkblue)),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              style: const TextStyle(color: AppColors.darkblue),
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkblue),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.darkblue),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                fillColor: AppColors.grey,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\n')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the description';
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 1, color: AppColors.darkblue),
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
