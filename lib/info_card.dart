import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;//after adding this it'll ask for the icon
  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  
  });

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
                width: 117,
                child: Column(
                  children: [

                    Icon(icon,size: 32,),
                                
                    const SizedBox(height: 8,),
                                
                    
                       Text(label 
                       ,style: TextStyle(
                        fontSize: 12
                       ),),
                                
                     const SizedBox(height: 8,),
                
                       Text(value,
                       style: const TextStyle(
                         fontSize: 16,
                        fontWeight: FontWeight.bold,
                       ),
                       
                       ),
                                
                
                
                                
                     
                  ],
                ),
              );
  }
}