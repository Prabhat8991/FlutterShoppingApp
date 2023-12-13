import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  var _groceryList = [];

  @override
  Widget build(BuildContext context) {
    void onAddItem() async {
     var grocery =  await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NewItem()));

     if(grocery != null) {
       setState(() {
         _groceryList.add(grocery);
       });
     }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(onPressed: onAddItem, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
          itemCount: _groceryList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_groceryList[index].name),
              leading: Container(
                height: 24,
                width: 24,
                color: _groceryList[index].category.color,
              ),
              trailing: Text(_groceryList[index].quantity.toString()),
            );
          }),
    );
  }
}
