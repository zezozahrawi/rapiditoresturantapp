import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resturante_de_tante/pages/Menu/Chef/chef_page.dart';
import 'package:resturante_de_tante/widget/custom_card.dart';

FirebaseAuth _user = FirebaseAuth.instance;

class ChefOrder extends StatelessWidget {
  const ChefOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Order'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('ChefUid', isEqualTo: _user.currentUser!.uid)
            .where('Status', isEqualTo: 'Start Order')
            .snapshots(),
        builder: (context, dynamic snapshot) {
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List _data = snapshot.data.docs.toList();

          return ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              List _order = _data[index]['Order'];
              return CustomCard(
                widget: Column(
                  children: [
                    for (int i = 0; i < _order.length; i++)
                      Text(_order[i]['FoodName']),
                    MaterialButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('Orders')
                            .doc(_data[index].id)
                            .update({
                          'Status': 'Finish',
                        });
                      },
                      color: Colors.red,
                      child: const Text('Ready'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
