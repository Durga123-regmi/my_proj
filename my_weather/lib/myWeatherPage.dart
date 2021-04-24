import 'dart:io';
import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_whether/WeatherDetails.dart';
import 'package:my_whether/loadingWIdget.dart';
import 'package:my_whether/myListTile.dart';
import 'package:my_whether/splashScreen.dart';

class MyWeatherPage extends StatefulWidget {
  @override
  _MyWeatherPageState createState() => _MyWeatherPageState();
}

class _MyWeatherPageState extends State<MyWeatherPage> {
  List<Widget> _detailTiles = [];
  double _photoOpacity = 0;
  double _opacity = 0;
  bool hasError = false;
  String cityName = '';
  TextEditingController _cityNameController;
  bool loading = true;
  bool cityGot = false;
  bool showSplashScreen = true;

  Color eColor = Colors.red;
  bool errorCityName = false;

  Mydetails _mydetails;

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
    });
    getWeather();
  }

  void getWeather() async {
    var uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=4b9fcd96d264f6732b300fb8509350d9");
    var response = await http.get(uri);

    print(response.statusCode);

    if (response.statusCode == 200) {
      var decodeData = convert.jsonDecode(response.body);
      print(decodeData.toString());
      _mydetails = Mydetails.fromJson(decodeData);
      buildDetailsTileList(_mydetails);

      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _photoOpacity = 1.0;
          this.hasError = false;
          cityGot = true;

          this.loading = false;
        });
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

  void dispose() {
    super.dispose();
  }

  showSnackBar(BuildContext context) {
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          content: Text('invalid city name or an error occured!')));
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    if (showSplashScreen || cityGot == false) {
      return SplashScreen();
    }

    return SafeArea(
      child: Container(
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
                child: loading
                    ? Center(
                        child: Center(
                          child: LoadignWidget(),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              _mydetails.description.toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Center(
                              child: Text(
                                '${_mydetails.tempMax}°',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                          Center(
                              child: Text(
                                _mydetails.cityName.toString() +
                                    ',' +
                                    _mydetails.countryName.toString(),
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
      ),
    );
  }

  buildSearchBar(
      BuildContext context, String cityName, TextEditingController controller) {
    return TextFormField(
      onFieldSubmitted: (val) {
        getWeather();
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
                setState(() {
                  loading = true;
                });
                getWeather();
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
    return SingleChildScrollView(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: _detailTiles.length,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return _detailTiles[index];
          }),
    );
  }

  void buildDetailsTileList(Mydetails dtls) {
    _detailTiles = [
      MyListTile(
        title: 'Pressure',
        subTitle: dtls.pressure,
        imagePath: 'p',
        
      ),
      MyListTile(
        title: 'Humidity',
        subTitle: dtls.humidity,
        imagePath: 'h',),
       
      MyListTile(
        title: 'Wind Speed',
        subTitle: dtls.windSpeed,
        imagePath: 'w',
        
      ),
      MyListTile(
        title: 'Clouds',
        subTitle: dtls.clouds,
        imagePath: 'c',
       
      ),
    ];
  }
}
