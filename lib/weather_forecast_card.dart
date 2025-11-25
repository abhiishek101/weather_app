import 'package:flutter/material.dart';

class WeatherForecastCard extends StatelessWidget {
  final String temp;
  final String time;
  final IconData icon;


  const WeatherForecastCard({super.key,
  required this. temp,
  required this.time, 
  required this.icon,

  });

  @override
  Widget build(BuildContext context) {
    return Card(
                    elevation: 20,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child:  Column(
                        children: [
                          Text(time,style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,                         
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          ),
                      
                          const SizedBox(height: 8,),
                      
                          Icon(icon,size: 32,),//small sloud icon
                      
                          const SizedBox(height: 8,),
                      
                          Text(temp,style:const  TextStyle(                          
                            fontWeight: FontWeight.bold,                         
                          ),
                          ),
                      
                        ],
                      ),
                    ),
                  );
  }
}