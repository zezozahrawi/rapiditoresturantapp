import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resturante_de_tante/widget/custom_card.dart';

FirebaseAuth _user = FirebaseAuth.instance;

class ChefHistory extends StatelessWidget {
  const ChefHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .where('ChefUid', isEqualTo: _user.currentUser!.uid)
            .where('Status', isEqualTo: 'Finish')
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
              return Column(
                children: [
                  for (int i = 0; i < _order.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomCard(
                          widget: Column(
                        children: [
                          Image.network(_order[i]['ImageURL']),
                          const SizedBox(height: 30),
                          Text(_order[i]['FoodName']),
                          const SizedBox(height: 30),
                        ],
                      )),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
