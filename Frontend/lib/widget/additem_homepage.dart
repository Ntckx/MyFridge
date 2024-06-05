import 'dart:ui';
import 'package:flutter/material.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameController.text;
      final expiryDate = _expiryDateController.text;
      final quantity = int.parse(_quantityController.text);
      final description = _descriptionController.text;

      widget.addItem(itemName, expiryDate, quantity, description);

      // Clear the form
      _itemNameController.clear();
      _expiryDateController.clear();
      _quantityController.clear();
      _descriptionController.clear();

      // Close the dialog
      Navigator.of(context).pop();
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
          AlertDialog(
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
                      child: TextFormField(
                        controller: _itemNameController,
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the item name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            child: TextFormField(
                              controller: _quantityController,
                              decoration:
                                  InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the quantity';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            child: TextFormField(
                              controller: _expiryDateController,
                              decoration: InputDecoration(labelText: 'EXP:'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the expiration date';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
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
        ],
      ),
    );
  }
}
