import 'package:flutter/material.dart';
import 'package:weather_app/CityPage.dart';

// My custom class
import 'Authentication.dart';

class HomePage extends StatefulWidget {
  final AuthImplementation auth;
  // A callback to method setAuthentication inside the Authentication model
  final VoidCallback setAuthentication;

  HomePage({this.auth, this.setAuthentication});

  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pink,
        child: Container(

          //margin: const EdgeInsets.only(left: 50.0, right: 50.0),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,

            children: <Widget>[
              IconButton(
                icon: Icon(Icons.explore),
                iconSize: 100,
                color: Colors.white,
                tooltip: 'Voeg een nieuwe locatie toe',
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => CityPage(auth: widget.auth, setAuthentication: widget.setAuthentication)),
                  );
                }
              ),
            ],
          )
        )
      ),
    );
  }
}