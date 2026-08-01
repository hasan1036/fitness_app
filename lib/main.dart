import 'package:flutter/material.dart';
import 'package:workoutfitnesstool/common/color_extention.dart';
//import 'package:workoutfitnesstool/view/login/on_boarding_view.dart';
import 'package:workoutfitnesstool/view/menu/menu_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Workout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: TColor.primary),
        useMaterial3: false
      ),
     // home:const onboard
      home: const  MenuView(),
    );
  }
}

