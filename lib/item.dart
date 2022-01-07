import 'package:firebase_database/firebase_database.dart';

class Item{
  late String _id;
  late String _name;
  late String _price;

  Item(this._id, this._name, this._price);

  Item.map(dynamic obj){
    this._id = obj['id'];
    this._name = obj['name'];
    this._price = obj['price'];
  }

  String get id => _id;
  String get name => _name;
  String get price => _price;

  Item.fromSnapshot(DataSnapshot snapshot){
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _price = snapshot.value['price'];
  }
}