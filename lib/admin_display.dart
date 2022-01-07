import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'item.dart';

void main() => runApp(
    AdminDisplay()
);

class AdminDisplay extends StatefulWidget{
  _AdminDisplay createState() => _AdminDisplay();
}

class _AdminDisplay extends State<AdminDisplay>{

  final _formKey = GlobalKey<FormState>();
  final notesReference = FirebaseDatabase.instance.reference().child('item');
  late List<Item> items;
  late StreamSubscription<Event> _onNoteAddedSubscription;
  late StreamSubscription<Event> _onNoteChangedSubscription;

  late TextEditingController _name, _price;
  late String _txtname, _txtprice;

  @override
  void initState(){
    super.initState();
    items = [];
    // items = new List();
    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription = notesReference.onChildChanged.listen(_updateItem);
  }

  @override
  void dispose(){
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  void _onNoteAdded(Event event){
    setState((){
      items.add(new Item.fromSnapshot(event.snapshot));
    });
  }

  void _deleteItem(BuildContext context, Item item, int position) async{
    await notesReference.child(item.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _updateItem(Event event){
    var oldValue = items.singleWhere((item) => item.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldValue)] = new Item.fromSnapshot(event.snapshot);
    });
  }

  void _saveItem(String value1, String value2, Item item, int position){
    notesReference.child(item.id).set({
      'name': value1,
      'price': value2,
    }).then((_) {
      Navigator.pop(context);
    });
    notesReference.onChildChanged.listen(_updateItem);
  }

  void _editItem(String name, String price, Item item, int position){
    showDialog(
      context: context, barrierDismissible: false,
      builder: (BuildContext context){
        return Form(
          key: _formKey,
          child: AlertDialog(
            title: Text('Update Record'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    onSaved: (val) => setState(() => _txtname = val!),
                  ),
                  TextFormField(
                    initialValue: price,
                    decoration: InputDecoration(
                      labelText: 'Price',
                    ),
                    onSaved: (val) => setState(() => _txtprice = val!),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Save'),
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    _saveItem(_txtname, _txtprice, items[position], position);
                  }
                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, position){
          return Column(
            children: <Widget>[
              Divider(height: 15, thickness: 2),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[position].name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(items[position].price, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(width: 30.0),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          iconSize: 30,
                          onPressed: (){
                            _editItem(items[position].name, items[position].price, items[position], position);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          iconSize: 30,
                          onPressed: (){
                            _deleteItem(context, items[position],position);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      )
    );
  }
}