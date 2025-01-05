// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseURL = 'hadi12.atwebpages.com';
List<Lemonade> lemonades = [];

class Lemonade {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  String comment;

  Lemonade(this.id, this.name, this.description, this.price, this.category, this.imageUrl, {this.comment = ''});

  @override
  String toString() {
    return 'ID: $id Name: $name\nDescription: $description Price: $price\nCategory: $category';
  }
}

void updateLemonades(Function(bool) callback) async {
  lemonades.clear();
  try {
    final url = Uri.http(baseURL, 'getLemonades.php');
    final request = await http.get(url).timeout(Duration(seconds: 5));
    if (request.statusCode == 200) {
      final jsonObject = jsonDecode(request.body);
      for (var row in jsonObject) {
        Lemonade l = Lemonade(
           int.parse(row['id']),
            row['name'],
            row['description'],
            double.parse(row['price']),
            row['category'],
            row['image_url']);
        lemonades.add(l);
      }
      callback(true);
    } else {
      callback(false);
    }
  } catch (e) {
    callback(false);
  }
}

class ShowLemonades extends StatefulWidget {
  const ShowLemonades({super.key});

  @override
  _ShowLemonadesState createState() => _ShowLemonadesState();
}

class _ShowLemonadesState extends State<ShowLemonades> {
  String selectedSize = 'Medium'; 
  String comment = ''; 
  int selectedIndex = -1; 

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lemonades.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(lemonades[index].name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lemonades[index].description),
            Text('Price: \$${lemonades[index].price}'),
            if (lemonades[index].comment.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Comment: ${lemonades[index].comment}',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
          ],
        ),
        trailing: Text('\$${lemonades[index].price}'),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(lemonades[index].name),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(lemonades[index].imageUrl),
                  SizedBox(height: 10),
                  Text(lemonades[index].description),
                  Text('Price: \$${lemonades[index].price}'),
                  
                 
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedSize,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSize = newValue!;
                      });
                    },
                    items: <String>['Small', 'Medium', 'Large']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        comment = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    setState(() {
                      lemonades[index].comment = comment;
                      selectedIndex = index;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
