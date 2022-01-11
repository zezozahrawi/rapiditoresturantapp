import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/continent_name.dart';
import 'package:resturante_de_tante/provider/provider.dart';
import 'package:resturante_de_tante/widget/custom_showmetoast.dart';

FirebaseAuth _user = FirebaseAuth.instance;

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    //Provider Watch
    MyProvider cart = context.watch<MyProvider>();

    return cart.items.isEmpty
        //in Case all the orders canceled will be appears
        ? Scaffold(
            appBar: AppBar(),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Cart is Empty'),
                ],
              ),
            ),
          )
        // Order is submitted
        // here the list of the provider will be mafkoka 
        : Scaffold(
            appBar: AppBar(
              title: const Text('Cart'),
            ),
            body: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Image.network(
                              cart.items[index]['ImageURL'],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      cart.items[index]['FoodName'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${cart.items[index]['Price'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'drop item',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.grey),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      iconSize: 30,
                                      onPressed: () {
                                        setState(() {
                                          //get compare the exsisting items
                                          cart.items.any((element) =>
                                                      element['FoodName'] ==
                                                      cart.items[index]
                                                          ['FoodName']) ==
                                                  true
                                              // when true remove the current item
                                              ? cart.remove((element) =>
                                                  element['FoodName'] ==
                                                  cart.items[index]['FoodName'])
                                              : null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Number of Order: ${cart.items.length.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '|| Total Price: ${cart.sum()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 15),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Orders')
                              .add({
                            'WaiterUid': user.currentUser!.uid,
                            'TotalPrice': cart.sum(),
                            'Order': cart.items,
                            //will be used in Chef page to get the order details
                            'Status': 'Pending',

                            //will be extanded with more details in the next version 2.0
                          });
                          // clean cart page
                          cart.items.clear();
                          //show the user the order has sent
                          tosat('order was sent');

                          //direct to the new order ...
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContinentName(),
                              ));
                        },
                        child: const Text('Order Now')),
                  ],
                ),
              ],
            ),
          );
  }
}
