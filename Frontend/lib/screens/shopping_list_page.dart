import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/dialog_box.dart';
import 'package:myfridgeapp/widget/items_tile.dart';
import 'package:myfridgeapp/services/service.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ShoppingListPage extends StatefulWidget {
  final int userId;

  const ShoppingListPage({super.key, required this.userId});
  
  @override
  ShoppingListPageState createState() => ShoppingListPageState();
}

class ShoppingListPageState extends State<ShoppingListPage> {
  final Service _service = Service();
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  late List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _fetchListData();
  }

  final Logger _logger = Logger('ShoppingListPage');
  void _fetchListData() async {
    try {
      final items = await _service.fetchListData(widget.userId);
      setState(() {
        this.items = items;
      });
    } catch (e) {
      _logger.severe('Error fetching list data: $e');
    }
  }

  void _checkBoxChanged(bool? value, int index) async {
    try {
      await _service.checkBoxChanged(items[index]['ListID'], value);
      setState(() {
        items[index]['isChecked'] = value;
      });
    } catch (e) {
      _logger.severe('Error updating check box: $e');
    }
  }

  void _saveNewItem() async {
    try {
      await _service.saveNewItem(
          widget.userId,
          _itemNameController.text,
          int.parse(_quantityController.text));
      _fetchListData();
      _itemNameController.clear();
      _quantityController.clear();
      Navigator.of(context).pop();
    } catch (e) {
      _logger.severe('Error creating new item: $e');
    }
  }

  void createNewItem() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          itemNameController: _itemNameController,
          quantityController: _quantityController,
          onSaved:  _saveNewItem,
          onCanceled: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _deleteItem(int index) async {
    try {
      await _service.deleteItem(items[index]['ListID']);
      setState(() {
        items.removeAt(index);
      });
    } catch (e) {
      _logger.severe('Error deleting item: $e');
    }
  }

  void _clearAllItems() async {
    try {
      await _service.clearAllItems(widget.userId);
      setState(() {
        items.clear();
      });
    } catch (e) {
      _logger.severe('Error deleting all items: $e');
    }
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20.0),
          backgroundColor: AppColors.darkblue,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  "Are you sure you want to clear all the list?",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                    side: WidgetStateProperty.all<BorderSide>(
                      const BorderSide(color: AppColors.white),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.darkblue),
                  ),
              child: Text("Cancel",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                _clearAllItems();
                Navigator.of(context).pop();
              },
              style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.white),
                  ),
              child: Text(
                "Clear all",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: AppColors.darkblue),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Shopping List',
        ),
        bottomNavigationBar: const BottomNav(path: "/home/shoppinglist"),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewItem,
          child: const Icon(Icons.add),
        ),
        body: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Wrapper(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 10),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: items.isNotEmpty
                            ? ElevatedButton(
                                onPressed: _showClearDialog,
                                child: Text(
                                  'clear all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: AppColors.white),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    items.isEmpty
                        ? const Center(
                            child: Text(
                              'No items in the list. Add some items!!',
                              style: TextStyle(color: AppColors.darkblue),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return ItemsTile(
                                    isChecked: items[index]['isChecked'],
                                    itemsName: items[index]['ListName'],
                                    quantity: items[index]['Quantity'],
                                    onChanged: (value) {
                                      _checkBoxChanged(value, index);
                                    },
                                    deleteItem: (context) => _deleteItem(index),
                                  );
                                },
                              ),
                            ),
                          )
                  ],
                ),
              ),
            )));
  }
}
