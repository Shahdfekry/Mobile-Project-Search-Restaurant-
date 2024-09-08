import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Model/resturantmodel.dart';
import 'package:project/Model/sign_in.dart';
import 'package:project/Model/sign_up.dart';
import 'package:project/resturant_screen.dart';
import 'package:project/si_in_ui.dart';
import 'package:project/si_up_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return            
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RestaurantCubit()),
     
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/signup',
        routes: {
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen(),
          '/rseturant': (context) => resturantscreen(),
         
        },
      ),
    );
  
  }
}
