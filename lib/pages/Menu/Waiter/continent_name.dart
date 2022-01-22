import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/cart.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/city_name.dart';
import 'package:resturante_de_tante/provider/provider.dart';

import 'package:resturante_de_tante/widget/custom_card.dart';

FirebaseAuth user = FirebaseAuth.instance;
List image = [
  "assets/images/as.jpg",
  "assets/images/eu.jpg",
  "assets/images/af.jpg",
  "assets/images/am.jpg",
  "assets/images/au.jpg",
  //  NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/restru-414ae.appspot.com/o/pictures%2Fas.jpg?alt=media&token=2302427a-9e59-4269-affe-4f3f4cf69aee'),
  // NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/restru-414ae.appspot.com/o/pictures%2Feu.jpg?alt=media&token=de2f6088-2ae1-44ee-be2f-7d4b2f8439df'),
  // NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/restru-414ae.appspot.com/o/pictures%2Faf.jpg?alt=media&token=44ef9b9d-2336-45ab-9c42-9fefb5e478bd'),
  // NetworkImage(
  //     'https://firebasestorage.googleapis.com/v0/b/restru-414ae.appspot.com/o/pictures%2Fam.jpg?alt=media&token=a68a7c63-b36a-461b-a323-e6eee829be4b'),
  // NetworkImage(
  //     'https://console.firebase.google.com/project/restru-414ae/storage/restru-414ae.appspot.com/files/~2Fpictures'),
];

class ContinentName extends StatelessWidget {
  const ContinentName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //its responsble to watch the cart
    MyProvider cart = context.watch<MyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Continent Menu'),
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
      drawer: Drawer(
        child: Column(
          children: [
            // ListTile(
            //   title: const Text('My Order'),
            //   onTap: () => Navigator.push(context,
            //       MaterialPageRoute(builder: (_) => const ChefOrder())),
            // ),
            ListTile(
              title: const Text(
                'Sign out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () => FirebaseAuth.instance.signOut(),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ContinentName')
            //automatically will get the whole list without this line
            .doc('Fw2EXf5dhn1sm6WjgKNe')
            .snapshots(),
        builder: (context, dynamic snapshot) {
          //if somthing Went Wrong while refreshing required thiese conditiones
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //Snapshot will be saved in a map
          Map data = snapshot.data.data();

          List continentName = data['ContinentName'];

          /// list view == for(int index=0 ; index<continentName.length;index++)
          /// print(continecnName[index])
          return ListView.builder(
            itemCount: continentName.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    // print(continentName[index]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                //send the list to the next page with push

                                CityName(continentName: continentName[index])));
                  },
                  // Image.asset(image[index
                  // continentName[index]
                  //the child of the list will generate a list with the ContinentName ! cool
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomCard(
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              image[index],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              continentName[index],
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      )));
            },
          );
        },
      ),
    );
  }
}
