import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myfridgeapp/theme/color_theme.dart';
import 'package:myfridgeapp/widget/custom_appbar.dart';
import 'package:myfridgeapp/widget/myfridge_item.dart';
import 'package:myfridgeapp/widget/nav_bar.dart';
import 'package:myfridgeapp/widget/additem_homepage.dart';
import 'package:myfridgeapp/widget/edititem_homepage.dart';
import '../services/api_service.dart';
import 'package:myfridgeapp/services/service.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final Service _service = Service();
  List<Map<String, dynamic>> items = [];
  bool isPremium = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final fetchedItems = await _apiService.getAllItems(widget.userId);
      print('Fetched items: $fetchedItems');
      setState(() {
        items = fetchedItems;
      });
    } catch (e) {
      print('Error fetching items: $e');
    }
  }

  void deleteItem(int index) async {
    try {
      await _apiService.deleteItem(items[index]['ItemID']);
      setState(() {
        items.removeAt(index);
      });
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  void _addItem(String itemName, String expiryDate, int quantity, String description) async {
    final currentDate = DateTime.now();
    final expDate = DateTime.parse(expiryDate);

    final newItem = {
      "ItemName": itemName,
      "Quantity": quantity,
      "ExpirationDate": expiryDate,
      "Description": description,
    };

    try {
      await _apiService.createItem(widget.userId, newItem);
      _fetchItems(); // Refetch items after adding
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  void _updateItem(int index, String itemName, String expiryDate, int quantity, String description) async {
    final currentDate = DateTime.now();
    final expDate = DateTime.parse(expiryDate);

    final updatedItem = {
      "ItemName": itemName,
      "Quantity": quantity,
      "ExpirationDate": expiryDate,
      "Description": description
    };

    try {
      await _apiService.updateItem(items[index]['ItemID'], updatedItem);
      _fetchItems(); // Refetch items after updating
    } catch (e) {
      print('Error updating item: $e');
    }
  }

  void _showAddItemDialog() async {
  try {
    // Fetch the latest user data and update the state
     await _fetchUserData();
    

    if (!isPremium && items.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Non-premium users can only add up to 5 items. Upgrade to premium for unlimited items.'),
        ),
      );
      return;
    }

    // Show the dialog to add a new item
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddItemToMyFridge(addItem: _addItem);
      },
    );
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

Future<void> _fetchUserData() async {
  try {
    // Assume this function fetches the user data and updates the isPremium variable
    final userData = await _service.fetchUserData(widget.userId);
    
    // Update the state with the latest user data
    setState(() {
      isPremium = userData['isPremium'];
      // Update other user-related state if necessary
    });
  } catch (e) {
    print('Error fetching user data: $e');
  }
}

  void _showEditItemDialog(int index, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditItemInMyFridge(
          updateItem: (itemName, expiryDate, quantity, description) {
            _updateItem(index, itemName, expiryDate, quantity, description);
          },
          itemName: item['ItemName'],
          expiryDate: item['ExpirationDate'],
          quantity: item['Quantity'],
          description: item['Description'],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: CustomAppBar(
          title:'Your inventory',
        ),
        
      ),
      bottomNavigationBar: const BottomNav(path: "/"),
      backgroundColor: AppColors.blue,
      body: Stack(
        children: [
          Container(
            color: AppColors.blue,
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(60.0),
                ),
              ),
              height: MediaQuery.of(context).size.height - 50,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                print('Rendering item: $item');

                return Center(
                  child: Container(
                    width: 350,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Slidable(
                      key: Key('$item'),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              _showEditItemDialog(index, item);
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.grey,
                            icon: Icons.edit,
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              deleteItem(index);
                            },
                            borderRadius: BorderRadius.circular(10),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                        ],
                      ),
                      child: MyFridgeItemCard(
                        itemId: item['ItemID'], // Pass itemId
                        initialQuantity: item['Quantity'] ?? 0,
                        itemName: item['ItemName'] ?? '',
                        isExpired: item['isExpired'] ?? false,
                        expiryDate: item['ExpirationDate'] ?? '',
                        description: item['Description'] ?? '',
                        deleteItem: (context) => deleteItem(index),
                        editItem: (context) => _showEditItemDialog(index, item),
                        fetchItems: _fetchItems, // Pass the fetchItems method
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        backgroundColor: const Color(0xFFF9DD6D),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
