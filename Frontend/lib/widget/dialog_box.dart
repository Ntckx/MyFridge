import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myfridgeapp/theme/color_theme.dart';

class DialogBox extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: itemNameController,
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
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                    hintText: 'e.g. 1',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a quantity.';
                    }
                    try {
                      int.parse(value);
                      return null;
                    } catch (e) {
                      return 'Please input a number only.';
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: onCanceled,
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onSaved();
                        }
                      },
                      child: const Text('Save'),
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
