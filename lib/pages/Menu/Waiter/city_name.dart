import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/food.dart';
import 'package:resturante_de_tante/provider/provider.dart';

import 'package:resturante_de_tante/widget/custom_card.dart';

import 'cart.dart';

class CityName extends StatelessWidget {

//parameter 
  final String continentName;

  const CityName({Key? key, required this.continentName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    MyProvider cart = context.watch<MyProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('chose City'),
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
      //body
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Country')
            .where('ContinentName', isEqualTo: continentName)
            .snapshots(),
        builder: (context, dynamic snapshot) {
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data.docs.toList();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Food(
                              food: data[index]['Country'],
                            ),
                          ));
                    },
                    child: CustomCard(
                      widget: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Text(
                              data[index]['Country'],
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
