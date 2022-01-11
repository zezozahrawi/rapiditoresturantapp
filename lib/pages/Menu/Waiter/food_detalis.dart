import 'package:flutter/material.dart';
import 'package:resturante_de_tante/widget/custom_card.dart';

// ignore: must_be_immutable
class FoodDetalis extends StatelessWidget {
  final String? foodName;
  // ignore: prefer_typing_uninitialized_variables
  var foodPrice;
  final String? foodDetalis;
  final String? foodImage;
  FoodDetalis(
      {Key? key,
      this.foodName,
      this.foodPrice,
      this.foodDetalis,
      this.foodImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(foodName!),
        title: const Text('Dich Description'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              widget: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    //food image
                    Image.network(foodImage!),

                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Text(
                        foodName!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    //Price and Name
                    Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 50),
                      child: Text(
                        foodDetalis!,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              'Item price',
              style: TextStyle(fontSize: 25, color: Colors.grey),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              '\$ ${foodPrice.toString()}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
