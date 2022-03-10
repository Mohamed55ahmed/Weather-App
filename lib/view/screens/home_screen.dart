import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/model/temp.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String weather = "clear";
  String abbr = "c";
  String location = "City";
  int temperature = 0;
  var woeid = 0;

  Future<void> fetchCity(String input) async {
    var url = Uri.parse(
        "https://www.metaweather.com/api/location/search/?query=$input");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body)[0];
    setState(() {
      location = responseBody["title"];
      woeid = responseBody["woeid"];
    });
  }
  Future<void> fetchTemperature() async {
    var url = Uri.parse(
        "https://www.metaweather.com/api/location/$woeid/");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body)["consolidated_weather"][0];
    setState(() {
      weather = responseBody["weather_state_name"].replaceAll(' ','').toLowerCase();
      abbr = responseBody["weather_state_abbr"];
      temperature=responseBody["the_temp"].round();
    });
  }
  Future<List<temp>> fetchTempeList() async {
    List<temp> list=[];
    var url = Uri.parse(
        "https://www.metaweather.com/api/location/$woeid/");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body)["consolidated_weather"];

   for(var i in responseBody){
     temp x=temp(i["weather_state_abbr"], i["min_temp"], i["max_temp"], i["applicable_date"]);
     list.add(x);
   }
    return list;
  }
  Future<void> textFiledOnSubmitted(String input) async {
    await fetchCity(input);
    await fetchTemperature();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/$weather.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child:
                      Image.network(
                        "https://www.metaweather.com/static/img/weather/png/$abbr.png",
                        width: 100,
                      ),
                    ),
                    Text(
                      "$temperature °C",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "$location",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: TextField(
                        style: TextStyle(color: Colors.white, fontSize: 30),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 30,
                          ),
                          hintText: "Search anather location..",
                          hintStyle:
                              TextStyle(color: Colors.white70, fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.white, style: BorderStyle.solid)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  color: Colors.black, style: BorderStyle.solid)),
                        ),
                        onSubmitted: (String input) {
                         textFiledOnSubmitted(input);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 170,
                      child:FutureBuilder(
                        future: fetchTempeList(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.hasData){
                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 20),
                                    child: Container(
                                      height: 170,
                                      width: 120,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Date: ${snapshot.data[index].applicable_date}",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                          Image.network(
                                            "https://www.metaweather.com/static/img/weather/png/$abbr.png",
                                            width: 30,
                                          ),
                                          Text(
                                            "$location",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Min: ${snapshot.data[index].min_temp.round()}",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            "Max: ${snapshot.data[index].max_temp.round()}",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },);
                          }else
                            return Text(" ");

                        },) ,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
