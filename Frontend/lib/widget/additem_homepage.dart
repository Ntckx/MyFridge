import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class AddItemToMyFridge extends StatefulWidget {
  final Function(String, String, int, String) addItem;

  const AddItemToMyFridge({Key? key, required this.addItem}) : super(key: key);

  @override
  _AddItemToMyFridgeState createState() => _AddItemToMyFridgeState();
}

class _AddItemToMyFridgeState extends State<AddItemToMyFridge> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _quantity = 0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameController.text;
      final expiryDate = _expiryDateController.text;
      final description = _descriptionController.text;

      widget.addItem(itemName, expiryDate, _quantity, description);

      _itemNameController.clear();
      _expiryDateController.clear();
      _quantityController.clear();
      _descriptionController.clear();

      // Close the dialog
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
        // Close the dialog when user taps outside
        Navigator.of(context).pop();
      },
      child: Stack(
        children: [
          // Backdrop filter for the blur effect
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
              backgroundColor:
                  Colors.white, // Ensure the background color is set correctly
              title: Text(
                'Create',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  fontFamily: 'Itim',
                ),
              ),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name',
                                style: TextStyle(color: AppColors.darkblue)),
                            TextFormField(
                              controller: _itemNameController,
                              decoration: InputDecoration(
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
                                fillColor: AppColors.whiteSmoke,
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
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Quantity',
                                      style:
                                          TextStyle(color: AppColors.darkblue)),
                                  FormField<int>(
                                    initialValue: _quantity,
                                    validator: (value) {
                                      if (value == null || value <= 0) {
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
                                            width:
                                                150, // Increase width as needed
                                            child: InputQty.int(
                                              qtyFormProps: const QtyFormProps(
                                                cursorColor: Colors.black,
                                              ),
                                              decoration:
                                                  const QtyDecorationProps(
                                                qtyStyle: QtyStyle.btnOnRight,
                                                orientation:
                                                    ButtonOrientation.vertical,
                                                btnColor: Colors.black,
                                                fillColor: AppColors.whiteSmoke,
                                                borderShape:
                                                    BorderShapeBtn.square,
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
                                              initVal: 0,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Text(
                                                state.errorText!,
                                                style: TextStyle(
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
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('EXP:',
                                      style:
                                          TextStyle(color: AppColors.darkblue)),
                                  TextFormField(
                                    controller: _expiryDateController,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: InputDecoration(
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
                                      fillColor: AppColors.whiteSmoke,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the expiration date';
                                      }
                                      try {
                                        DateTime.parse(
                                            value); // Ensure the date can be parsed
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
                        margin: EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Description',
                                style: TextStyle(color: AppColors.darkblue)),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3, // Make this field multiline
                              decoration: InputDecoration(
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
                                fillColor: AppColors.whiteSmoke,
                              ),
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
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
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
