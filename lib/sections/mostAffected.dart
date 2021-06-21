import 'package:flutter/material.dart';

class MostAffected extends StatelessWidget {
  final List countryData;

  const MostAffected({Key key, this.countryData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Image.network(
                  countryData[index]['countryInfo']['flag'],
                  height: 25,
                  width: 50,
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 125,
                  child: Text(
                    countryData[index]['country'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text(
                    'Deaths : ' + countryData[index]['deaths'].toString(),
                    style:
                        TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          );
        },
        itemCount: 5,
      ),
    );
  }
}
