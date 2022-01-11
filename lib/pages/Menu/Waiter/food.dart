import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/cart.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/food_detalis.dart';
import 'package:resturante_de_tante/provider/provider.dart';

FirebaseAuth user = FirebaseAuth.instance;

class Food extends StatefulWidget {
  final String? food;
  const Food({Key? key, this.food}) : super(key: key);
  @override
  State<Food> createState() => _FoodState();
}

class _FoodState extends State<Food> {
  @override
  Widget build(BuildContext context) {
    MyProvider cart = context.watch<MyProvider>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chose Your Food'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: 150.0,
                width: 30.0,
                child: GestureDetector(
                  onTap: cart.items.isEmpty
                      ? null
                      : () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => const Cart())),
                  child: Stack(
                    children: [
                      const IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.red,
                        ),
                        onPressed: null,
                      ),
                      cart.items.isEmpty
                          ? Container()
                          : Positioned(
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.brightness_1,
                                    size: 20.0,
                                    color: Colors.green[800],
                                  ),
                                  Positioned(
                                      top: 3.0,
                                      right: 7.0,
                                      child: Center(
                                        child: Text(
                                          cart.items.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Food')
              //here must be country name inste of food !! 
              .where('Country', isEqualTo: widget.food)
              .snapshots(),
          builder: (context, dynamic snapshot) {
            if (snapshot.hasError) {
              return const CircularProgressIndicator();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            var data = snapshot.data.docs.toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataTable(
                    
                    columns: const [
                      DataColumn(label: Text('FoodName')),
                      DataColumn(
                        label: Text('Price'),
                       
                      ),
                      DataColumn(label: Text('Image')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      for (int index = 0; index < data.length; index++)
                        DataRow(cells: [
                          DataCell(GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FoodDetalis(
                                        foodName: data[index]['FoodName'],
                                        foodDetalis: data[index]['description'],
                                        foodPrice: data[index]['Price'],
                                        foodImage: data[index]['ImageURL'],
                                      ),
                                    ));
                              },
                              child: Text(data[index]['FoodName']))),
                          DataCell(Text(data[index]['Price'].toString())),
                          DataCell(
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Image.network(data[index]['ImageURL']),
                            ),
                          ),
                          DataCell(
                            //need to be explaind 
                            Checkbox(
                              value: cart.items.any((element) =>
                                          element['FoodName'] ==
                                          data[index]['FoodName']) ==
                                      true
                                  ? true
                                  : false,
                              onChanged: (value) {
                                setState(
                                  () {
                                    value == false
                                        ? value = true
                                        : value == true
                                            ? value = false
                                            : null;
                                    cart.items.any((element) =>
                                                element['FoodName'] ==
                                                data[index]['FoodName']) ==
                                            false
                                        ? cart.add({
                                            'FoodName': data[index]['FoodName'],
                                            'Price': data[index]['Price'],
                                            'ImageURL': data[index]['ImageURL'],
                                          })
                                        : cart.items.any((element) =>
                                                    element['FoodName'] ==
                                                    data[index]['FoodName']) ==
                                                true
                                            ? cart.remove((element) =>
                                                element['FoodName'] ==
                                                data[index]['FoodName'])
                                            : null;
                                  },
                                );
                              },
                            ),
                          )
                        ])
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
