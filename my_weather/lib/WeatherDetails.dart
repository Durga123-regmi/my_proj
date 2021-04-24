
class Mydetails {
 var description;
   var clouds;
   var tempMax;
   var countryName;
   var cityName;
   var pressure;
  var humidity;
   var windSpeed;

  Mydetails(
      {this.cityName,
      this.description,
      this.countryName,
      this.clouds,
      this.tempMax,
      this.humidity,
      this.pressure,
      this.windSpeed});

  Mydetails.fromJson(Map<String, dynamic>  json)
      : cityName = json['name'],
        description = json['weather'][0]['description'],
        countryName = json['sys']['country'],
        clouds = json['clouds']['all'],
        tempMax = json['main']['temp_max'],
        humidity = json['main']['humidity'],
        pressure = json['main']['pressure'],
        windSpeed = json['wind']['speed'];
}
