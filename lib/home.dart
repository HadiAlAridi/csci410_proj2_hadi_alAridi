// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'product.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool load = false;

  @override
  void initState() {
    updateLemonades(update);
    super.initState();
  }

  void update(bool success) {
    setState(() {
      load = true;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Can't get data")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lemonade Menu'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
         
      ),
      body: load
          ? ShowLemonades()
          : Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(color: Colors.orange),
              ),
            ),
    );
  }
}
