import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/info_card.dart';
import 'package:weather_app/secrets.dart';
import 'package:weather_app/weather_forecast_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  //constructor

  // double temp =0;
  // bool isLoading=false; //we don't use (late double temp;) bczz data need ssome time to fetch from the api, in that time build fn gets built!!!, so we initialize at 0.

  // @override
  // void initState() {
  //   super.initState();

  // }
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // setState(() {
      //   isLoading= true;//isLoading is now true rebuild the bulid function
      // });
      String cityName = 'London,uk';
      String cityName2 = 'Delhi,in';

      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName2&units=metric&APPID=$openWeatherApiKey',
        ),
      );

      final data = jsonDecode(
        res.body,
      ); // to decode res.body as it is still in string format.

      if (data['cod'] != '200') {
        //to check if the api call is successful, and if it not 200(given by api) we show an error.
        throw 'An unexpected error occured';
      }
      // setState(() {
      //   //setstate is used for rebuilding the build function

      return data; //return data incase of status code of 200
      //   temp =
      // data['list'][0]['main']['temp']; //this data is retrieved but it is an enclosed func, so we need to create a global variable.(double temp=0), in constructor.

      // });
    } catch (e) {
      throw e.toString(); //error throw
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              'Weather',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 7,
            ),
          ],
          
        ),
        centerTitle: true,
        actions: [
          //Iconbutton has a overall padding which inkwell and gesturebutton does not.
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: /*temp == 0
          ? Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: const CircularProgressIndicator(),
              ),
            )
          : */ FutureBuilder(
        future: weather,
        builder:
            (
              context,
              snapshot,
            ) /* a wrapper that tells you what’s happening right now 
            with your async operation (loading, success, error, no data).a snapshot basically 
            is a class that handles states in your app
            , loading state, a data state, a error state*/ {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error
                        .toString(), //added to string bcs text can not handle
                    //object its handles string.
                  ),
                );
              }

              final data = snapshot.data!;
              final currentWeatherData = data['list'][0];

              final currentTemp = currentWeatherData['main']['temp'];
              final currentSky = currentWeatherData['weather'][0]['main'];
              final currentPressure = currentWeatherData['main']['pressure'];
              final currentWindSpeed = currentWeatherData['wind']['speed'];
              final currentHumidity = currentWeatherData['main']['humidity'];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //maincard
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ), //to separate from the blur
                        elevation: 15,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ), //blur
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    '$currentTemp°C',
                                    style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  Icon(
                                    currentSky == 'Clouds'
                                        ? Icons.cloud
                                        : currentSky == 'Rain'
                                        ? Icons.electric_bolt_rounded
                                        : currentSky == 'Clear'
                                        ? Icons.sunny
                                        : Icons.help_outline,
                                    size: 32,
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    currentSky,
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    //weather FORECAST text
                    const Text(
                      'Weather Forecast',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    //Weather Forecast Cards
                    //  SingleChildScrollView(
                    //   //for scrolling
                    //   scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       for(int i = 1; i<5;i++)
                    //       WeatherForecastCard(
                    //         time: data['list'][i+1]['dt'].toString(),
                    //         icon: data['list'][i+1]['weather'][0]['main']=='Rain'? Icons.electric_bolt_rounded:
                    //         data['list'][i+1]['weather'][0]['main']=='Clear'? Icons.cloudy_snowing:
                    //         data['list'][i+1]['weather'][0]['main']=='Clouds'? Icons.cloud:
                    //         Icons.help_outlined,
                    //         temp:data['list'][i+1]['main']['temp'].toString(),
                    //       ),

                    //     ],
                    //   ),
                    // ),


                    //Weather Forecast Cards
                    SizedBox(
                      height: 121,
                      child: ListView.builder(
                        //we chose this over 'SingleChildScrollView' bcs 'SingleChildScrollView' displays all the items at the same time
                        //ListView.builder allows lazy loading of widgets, increasing apps performance.
                        //ListView.builder
                        itemCount: 8,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final forecastData = data['list'][index + 1];
                          final forcastSky =
                              data['list'][index + 1]['weather'][0]['main'];
                          final forcastTemp = forecastData['main']['temp']
                              .toString();
                          final time = DateTime.parse(forecastData['dt_txt']);
                          return WeatherForecastCard(
                            temp: '${forcastTemp}°C',
                            time: DateFormat.j().format(time),
                            icon: forcastSky == 'Rain'
                                ? Icons.electric_bolt_rounded
                                : forcastSky == 'Clear'
                                ? Icons.cloudy_snowing
                                : forcastSky == 'Clouds'
                                ? Icons.cloud
                                : Icons.help_outlined,
                          );
                        },
                      ),
                    ),

                    //weather forecast card
                    const SizedBox(height: 20),

                    //additional info card
                    const Text(
                      'Additional Information',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InfoCard(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: "${currentHumidity}%"
                              .toString(), //toString bcs it can only handle string.
                        ),
                        InfoCard(
                          icon: Icons.air_outlined,
                          label: 'Wind Speed',
                          value: "${currentWindSpeed.toStringAsFixed(1)} m/s",
                        ),
                        InfoCard(
                          icon: Icons.beach_access_sharp,
                          label: 'Pressure',
                          value:"${ currentPressure.toString()}hPa",
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            
      ),
      bottomNavigationBar: 
      FutureBuilder(
        future: weather,

        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const SizedBox(
              height: 50,
             
            );
            
          }
        if(snapshot.hasError){
          return SizedBox(height: 50,
          child: Text(snapshot.error.toString()
          ),
          );
        
        }

final data = snapshot.data!;
final currentDate= data['list'][0]['dt_txt'];
final parsedDate = DateTime.parse(currentDate);
final formattedDate= DateFormat('EEE,d MMM').format(parsedDate);
 
        return  Padding(
          padding: const EdgeInsets.all(50.0),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: Text(formattedDate,style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
          ),
        );
        },
      ),
      
    );
  }
}
