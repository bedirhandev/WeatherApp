import 'package:flutter/material.dart';

import 'Cities.dart';

class CityPage extends StatefulWidget {
  CityPage();

  State<StatefulWidget> createState() {
    return _CityPageState();
  }
}

class _CityPageState extends State<CityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nederlandse steden"),
        ),
        body: ListViewCities());
  }
}
