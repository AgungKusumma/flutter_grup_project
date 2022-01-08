import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'admin_home.dart';
import 'admin_new.dart';
import 'admin_display.dart';
import 'main_page.dart';

void main() => runApp(
    AdminPage()
);

class AdminPage extends StatefulWidget{
  _AdminPage createState() => _AdminPage();
}

class _AdminPage extends State<AdminPage>{

  int _selectedDestination = 0; //Active text overlay
  late Widget mainWidget;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void initState(){
    this._initial();
    super.initState();
  }

  void dispose(){
    super.dispose();
  }

  void _initial(){
    mainWidget = AdminHome();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Kali Linux'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: mainWidget,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Main Menu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
                title: Text('Home', style: TextStyle(fontSize: 15)),
                leading: Icon(Icons.home),
                selected: _selectedDestination == 0,
                selectedTileColor: Colors.lightBlue.shade100,
                onTap: (){
                  setState(() {
                    mainWidget = AdminHome();
                    _selectedDestination = 0;
                  });
                  Navigator.pop(context);
                }
            ),
            ListTile(
                title: Text('Display Record', style: TextStyle(fontSize: 15)),
                leading: Icon(Icons.view_agenda),
                selected: _selectedDestination == 1,
                selectedTileColor: Colors.lightBlue.shade100,
                onTap: (){
                  setState(() {
                    mainWidget = AdminDisplay();
                    _selectedDestination = 1;
                  });
                  Navigator.pop(context);
                }
            ),
            ListTile(
                title: Text('Add New Record', style: TextStyle(fontSize: 15)),
                leading: Icon(Icons.add),
                selected: _selectedDestination == 2,
                selectedTileColor: Colors.lightBlue.shade100,
                onTap: (){
                  setState(() {
                    mainWidget = AdminNew();
                    _selectedDestination = 2;
                  });
                  Navigator.pop(context);
                }
            ),
            ListTile(
                title: Text('Logout', style: TextStyle(fontSize: 15)),
                leading: Icon(Icons.logout),
                onTap: () async{
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                  
                  Toast.show("Logout Successfully", context);
                }
            ),
          ],
        ),
      ),
    );
  }
}