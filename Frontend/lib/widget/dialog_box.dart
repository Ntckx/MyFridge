import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final itemNameController;
  final expirationDateController;
  final descriptionController;
  final storageLocationController;
  VoidCallback onSaved;
  VoidCallback onCanceled;

  DialogBox({
    super.key,
    required this.itemNameController,
    required this.expirationDateController,
    required this.descriptionController,
    required this.storageLocationController,
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
                const Center(
                  child: Text(
                    "Add New Item",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Item name"),
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
                  controller: expirationDateController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Expiration Date',
                    hintText: 'e.g. 12/31/2022',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an expiration date.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                    hintText: 'e.g. Brand, Quantity, etc.',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: storageLocationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Storage Location',
                    hintText: 'e.g. Fridge, Pantry, etc.',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a storage location.';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: onCanceled,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
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
