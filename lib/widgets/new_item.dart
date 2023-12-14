import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _quantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'flutter-prep-fe645-default-rtdb.firebaseio.com',
          'shopping-list.json');
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": _enteredName,
            "quantity": _quantity,
            "category": _selectedCategory.name
          }));

      if(!context.mounted) {
        return;
      }

      Navigator.of(context).pop();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 50,
                  decoration: const InputDecoration(label: Text('Name')),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1 ||
                        value.length > 50) {
                      return "Character length must be between 1 and 50";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                const SizedBox(height: 20),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Value must be valid positive number";
                        }
                        return null;
                      },
                      initialValue: _quantity.toString(),
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                                value: category.value,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      color: category.value.color,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(category.value.name)
                                  ],
                                ))
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text("Reset")),
                    ElevatedButton(
                        onPressed: _submitForm, child: const Text("Submit"))
                  ],
                )
              ],
            )),
      ),
    );
  }
}
