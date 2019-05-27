import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Models.dart';
import 'ServiceProvider.dart';

class ListViewCities extends StatefulWidget {
  final auth = FirebaseAuth.instance;

  ListViewCities();

  State<StatefulWidget> createState() {
    return _ListViewCitiesState();
  }
}

class _ListViewCitiesState extends State<ListViewCities> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final citiesProvider = Provider.of<DutchCities>(context);

    citiesProvider.fetchCities(user);

    if (citiesProvider.cities.length == 0) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
        child: ListView.builder(
      itemCount: citiesProvider.cities.length,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, position) {
        return Column(
          children: <Widget>[
            Divider(height: 5.0),
            ListTile(
              title: Text(
                '${citiesProvider.cities[position].city}',
                style:
                    TextStyle(fontSize: 22.0, color: Colors.deepOrangeAccent),
              ),
              leading: Text((position + 1).toString() + '.'),
              trailing: Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                      onChanged: (bool value) => citiesProvider.setFavoCity(
                          position,
                          citiesProvider.cities[position].city,
                          value,
                          user),
                      value: citiesProvider.cities[position].checked)),
              onTap: () => _onTapItem(context, citiesProvider.cities[position]),
            ),
          ],
        );
      },
    ));
  }

  void _onTapItem(BuildContext context, DutchCity city) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
            'De stad ${city.city} ligt in de provincie ${city.admin}.')));
  }
}
