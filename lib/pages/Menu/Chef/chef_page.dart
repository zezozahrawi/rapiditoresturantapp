import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resturante_de_tante/pages/Menu/Waiter/cart.dart';
import 'package:resturante_de_tante/pages/Menu/Chef/chef_history.dart';
import 'package:resturante_de_tante/pages/Menu/Chef/chef_order.dart';
import 'package:resturante_de_tante/widget/custom_card.dart';

FirebaseAuth _user = FirebaseAuth.instance;

class ChefPage extends StatelessWidget {
  const ChefPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Orders'),
        actions: [
          //SignOut Button 
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      //Drawer Menu : ( Current Order , History , Profile Picture .. etc)
      drawer: Drawer(
        child: Column(
          children: [
            ListTile(
              title: const Text('Current Order'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChefOrder())),
            ),
            ListTile(
              title: const Text('History'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChefHistory())),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            //Nice Trick : how to define the peniding !
            .collection('Orders')
            .where('Status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, dynamic snapshot) {
          //Loading Status ! Very very very imporatant ! 
          if (snapshot.hasError) {
            return const CircularProgressIndicator();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List data = snapshot.data.docs.toList();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {

              List order = data[index]['Order'];
              
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCard(
                  widget: Column(
                    children: [
                      const SizedBox(height: 25),
                      for (int i = 0; i < order.length; i++)
                        Column(
                          children: [
                            Image.network(order[i]['ImageURL']),
                            Text(order[i]['FoodName']),
                            const SizedBox(height: 25),
                          ],
                        ),
                      Text(data[index]['Status']),
                      MaterialButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('Orders')
                              .doc(data[index].id)
                              .update({
                            'ChefUid': _user.currentUser!.uid,
                            'Status': 'Start Order'
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ChefOrder(),
                              ));
                        },
                        child: const Text('Start Order'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
