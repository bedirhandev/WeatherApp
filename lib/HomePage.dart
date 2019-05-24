import 'package:flutter/material.dart';
import 'package:weather_app/CityPage.dart';

class HomePage extends StatefulWidget {
  HomePage();

  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(),
      bottomNavigationBar: BottomAppBar(
          color: Colors.pink,
          child: Container(
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
                      MaterialPageRoute(builder: (context) => CityPage()),
                    );
                  }),
            ],
          ))),
    );
  }
}
