import 'package:flutter/material.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSaved;
  VoidCallback onCanceled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DialogBox({
    super.key,
    required this.controller,
    required this.onSaved,
    required this.onCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Container(
      height: 150,
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Enter item name"),
                  hintText: 'e.g. Milk',
                ),
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return 'Please enter a item name.';
                  }
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onCanceled,
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        onSaved();
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          )),
    ));
  }
}
