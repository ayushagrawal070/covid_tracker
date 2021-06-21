import 'dart:convert';

import 'package:covid_tracker/datasource.dart';
import 'package:covid_tracker/pages/countryPage.dart';
import 'package:covid_tracker/sections/infoPanel.dart';
import 'package:covid_tracker/sections/mostAffected.dart';
import 'package:covid_tracker/sections/worldwidepanel.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String world_url = "https://corona.lmao.ninja/v2/all";
  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get(Uri.parse(world_url));
    setState(() {
      worldData = jsonDecode(response.body);
    });
  }

  String regional_url = "https://corona.lmao.ninja/v2/countries?sort=cases";
  List countryData;

  fetchCountryData() async {
    http.Response response = await http.get(Uri.parse(regional_url));
    setState(() {
      countryData = jsonDecode(response.body);
      // countryData.sort((a, b) => Comparable.compare(b["deaths"], a["deaths"]));
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.light ? Brightness.dark : Brightness.light);
              },
              icon: Icon(Theme.of(context).brightness == Brightness.light
                  ? Icons.lightbulb_outline
                  : Icons.highlight))
        ],
        centerTitle: false,
        title: Text('COVID-19 TRACKER'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.orange[100],
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              height: 100,
              child: Text(
                DataSource.quote,
                style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Worldwide',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CountryPage()));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: primaryBlack,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Regional',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            (worldData == null)
                ? CircularProgressIndicator()
                : WorldWidePanel(
                    worldData: worldData,
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                'Most Affected Countries',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            (countryData == null)
                ? CircularProgressIndicator()
                : MostAffected(
                    countryData: countryData,
                  ),
            SizedBox(
              height: 20,
            ),
            InfoPanel(),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              'WE ARE TOGETHER IN THE FIGHT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
