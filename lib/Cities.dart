import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Models.dart';

class ListViewCities extends StatefulWidget {
  ListViewCities();

  State<StatefulWidget> createState() {
    return _ListViewCitiesState();
  }
}

class _ListViewCitiesState extends State<ListViewCities> {
  @override
  Widget build(BuildContext context) {
    List<DutchCity> dutchCities = Provider.of<List<DutchCity>>(context) ?? null;

    if (dutchCities == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        child: ListView.builder(
          itemCount: dutchCities.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${dutchCities[position].city}',
                    style: TextStyle(
                        fontSize: 22.0, color: Colors.deepOrangeAccent),
                  ),
                  leading: Text((position + 1).toString() + '.'),
                  trailing: Transform.scale(
                      scale: 1.25,
                      child: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              DutchCity city = dutchCities[position];
                              city.checked = value;
                              // create favo city in db
                            });
                          },
                          value: dutchCities[position].checked)),
                  onTap: () => _onTapItem(context, dutchCities[position]),
                ),
              ],
            );
          },
        ),
      );
    }

    /*return Scaffold(
      appBar: AppBar(
        title: Text('Nederlandse steden.'),
      ),
      body: (dutchCities == null)
        ? Center(child: CircularProgressIndicator())
        : Container(
        child: ListView.builder(
          itemCount: dutchCities.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${dutchCities[position].city}',
                    style:
                        TextStyle(fontSize: 22.0, color: Colors.deepOrangeAccent),
                  ),
                  leading: Text((position + 1).toString() + '.'),
                  trailing: Transform.scale(
                      scale: 1.25,
                      child: Checkbox(
                          onChanged: (bool value) {
                            setState(() {
                              DutchCity city = dutchCities[position];
                              city.checked = value;
                              // create favo city in db
                            });
                          },
                          value: dutchCities[position].checked)),
                  onTap: () => _onTapItem(context, dutchCities[position]),
                ),
              ],
            );
          },
        ),
      ),
    );*/
  }

  void _onTapItem(BuildContext context, DutchCity city) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(
            'De stad ${city.city} ligt in de provincie ${city.admin}.')));
  }
}
