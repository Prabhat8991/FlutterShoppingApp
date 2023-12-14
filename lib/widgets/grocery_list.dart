import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  var _groceryList = [];
  var _isLoading = true;
  late Future<List<GroceryItem>> _loadItemsFuture;

  @override
  void initState() {
    super.initState();
    _loadItemsFuture = _loadItems();
  }

  Future<List<GroceryItem>> _loadItems() async {
    final url = Uri.https(
        'flutter-prep-fe645-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> itemList = json.decode(response.body);
    List<GroceryItem> _loadedItems = [];
    for (final entry in itemList.entries) {
      Category category = categories.entries
          .firstWhere(
              (element) => element.value.name == entry.value['category'])
          .value;
      _loadedItems.add(GroceryItem(
          id: entry.key,
          name: entry.value['name'],
          quantity: entry.value['quantity'],
          category: category));
    }
    return _loadedItems;
  }

  @override
  Widget build(BuildContext context) {
    void onAddItem() async {
      var grocery = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewItem()));
      _loadItems();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(onPressed: onAddItem, icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
        future: _loadItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  leading: Container(
                    height: 24,
                    width: 24,
                    color: snapshot.data![index].category.color,
                  ),
                  trailing: Text(snapshot.data![index].quantity.toString()),
                );
              });
        },
      ),
    );
  }
}
