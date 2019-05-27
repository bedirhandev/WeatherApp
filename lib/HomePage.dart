import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/CityPage.dart';

import 'ServiceProvider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final citiesProvider = Provider.of<DutchCities>(context);

    if (citiesProvider.cities.length == 0) {
      citiesProvider.initialise(user);
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: citiesProvider.favoCities.length,
            padding: const EdgeInsets.all(15.0),
            itemBuilder: (context, position) {
              return Column(children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${citiesProvider.favoCities[position].city}',
                    style: TextStyle(
                        fontSize: 22.0, color: Colors.deepOrangeAccent),
                  ),
                  trailing: Text(
                      '${citiesProvider.favoCities[position].tmp} \u00B0C'),
                )
              ]);
            }),
      ),
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
