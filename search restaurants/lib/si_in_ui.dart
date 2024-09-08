import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Logic/s_in.dart';
import 'package:project/Model/sign_in.dart';
import 'package:project/resturant_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In Page',
        style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 240, 143, 69),
        toolbarHeight: 85,
      ),
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.isSuccess) {
            _showSuccessDialog(context);
          } else if (state.error != null) {
            _showErrorDialog(context, state.error!);
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return state.isLoading
                ? Center(child: CircularProgressIndicator())
                : LoginForm();
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Login successful!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                // Use pushReplacement to replace current screen with RestaurantScreen
                MaterialPageRoute(
                  builder: (context) => resturantscreen(),
                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Error: $error'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
