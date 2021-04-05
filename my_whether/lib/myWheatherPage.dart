import 'dart:io';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_whether/splashScreen.dart';

class MyWeatherPage extends StatefulWidget {
  @override
  _MyWeatherPageState createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<MyWeatherPage> {
  bool hasError = false;
  String cityName = '';
  TextEditingController _cityNameController;
  bool loading = true;
  bool cityGot = true;
  bool showSplashScreen = true;

  var allData;
  Color eColor = Colors.red;
  bool errorCityName = false;

  var description;
  var citiName;
  var temp_max;
  var countryName;

  changeScreen() {
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        showSplashScreen = false;
      });
    });
  }

  Future<dynamic> getCurrentCity() async {
    final geoPostion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final _longitude = geoPostion.longitude;
    final _latitude = geoPostion.latitude;
    final _cordinates = Coordinates(_latitude, _longitude);
    var _addresses =
        await Geocoder.local.findAddressesFromCoordinates(_cordinates);

    var _city = _addresses.first.locality;

    print(_city);
    setState(() {
      cityName = _city;

      cityGot = false;
    });
    getWheather();
  }

  void getWheather() async {
    var uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=4b9fcd96d264f6732b300fb8509350d9");
    var response = await http.get(uri);

    print(response.statusCode);

    if (response.statusCode == 200) {
      var decodeData = convert.jsonDecode(response.body);
      if (mounted) {
        setState(() {
          this.hasError = false;
          this.allData = decodeData;
          this.description = decodeData['weather'][0]['description'];
          this.errorCityName = false;
          this.citiName = decodeData['name'];

          this.temp_max = decodeData['main']['temp_max'];
          this.countryName = decodeData['sys']['country'];
          this.loading = false;
        });
        print(allData);
      }
    } else if (response.statusCode == 404) {
      setState(() {
        hasError = true;
        _cityNameController.text = cityName + '*';
      });
      showSnackBar(context);
    }
  }

  void initState() {
    super.initState();
    getCurrentCity();
    changeScreen();

    _cityNameController = new TextEditingController(text: cityName);
  }

  showSnackBar(BuildContext context) {
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('invalid city name or an error occured!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (loading || cityGot||showSplashScreen) {
      return SplashScreen();
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.redAccent[200],
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(200, 100),
                      bottomRight: Radius.elliptical(200, 100))),
              height: height * 1 / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      description.toString(),
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Center(
                      child: Text(
                    '$temp_max °',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                  Center(
                      child: Text(
                    citiName + ',' + countryName,
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              flex: 1,
              child: buildSearchBar(context, cityName, _cityNameController)),
          Expanded(
            flex: 3,
            child: builWheatherDetail(context),
          )
        ],
      ),
    );
  }

  buildSearchBar(
      BuildContext context, String cityName, TextEditingController controller) {
    return TextFormField(
      onFieldSubmitted: (val) {
        getWheather();
      },
      onChanged: (val) {
        setState(() {
          this.cityName = val;
        });
      },
      controller: controller,
      style: TextStyle(
        fontSize: 25,
        color: hasError ? eColor : Colors.redAccent[100],
        fontWeight: FontWeight.bold,
      ),
      cursorColor: Colors.redAccent[200],
      decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.redAccent[100]),
          hintText: 'Type city name',
          prefixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.redAccent[200],
              ),
              onPressed: () async {
                getWheather();
              }),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent[100]),
              borderRadius: BorderRadius.circular(25)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(width: 2, color: Colors.redAccent[200]))),
    );
  }

  builWheatherDetail(BuildContext context) {
    return ListView(
      children: [
        buildListTile('Pressure', allData['main']['pressure'].toString(), 'p'),
        buildListTile(
            'Humidity', allData['main']['humidity'].toString() + '%', 'h'),
        buildListTile('Wind Speed', allData['wind']['speed'].toString(), 'w'),
        buildListTile('Clouds', allData['clouds']['all'].toString(), 'c')
      ],
    );
  }

  buildListTile(String s, allData, String path) {
    return Card(
      elevation: 5,
      child: Container(
          height: 100,
          width: 400,
          decoration: BoxDecoration(color: Colors.white54),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ListTile(
                  title: Text(
                    s,
                    style: TextStyle(
                        color: Colors.redAccent[200],
                        fontSize: 29,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    allData,
                    style: TextStyle(
                        color: Colors.red[100],
                        fontWeight: FontWeight.w600,
                        fontSize: 25),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: 0.7,
                      child: Image.asset(
                        'image/$path.jpg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ))
            ],
          )),
    );
  }
}
