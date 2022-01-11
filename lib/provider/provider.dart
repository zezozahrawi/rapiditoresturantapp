import 'package:flutter/foundation.dart';

// The priovider help us to hold the selected items along the pages
//to define Architectural Pattern ** setstatment ! to use inside the Cart Notification Counter
class MyProvider extends ChangeNotifier {
  
  
  /////this is the main list of our Cart 
  List items = [];

  add(item) {
    items.add(item);
    //listen to any change
    notifyListeners();
  }

  //remove from the Cart counter
  remove(item) {
    items.removeWhere(item);
    notifyListeners();
  }

  //to sum the total price from the items List in the Cart
  sum() => items.map((e) => e['Price']).reduce((a, b) => a + b);
}


