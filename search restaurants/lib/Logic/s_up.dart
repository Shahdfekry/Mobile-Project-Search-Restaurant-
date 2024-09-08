import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Model/sign_up.dart';

class SignUpForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const SignUpForm({Key? key, required this.formKey}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

// ignore: must_be_immutable
class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  String? _selectedGender;
  String? _selectedLevel;
  bool obscurePassword = true;
  bool obscureconPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter your email';
                } else if (!_isFCIEmail(value)) {
                  return 'Please Enter a valid FCI Email address';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Student ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your student ID';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                  child: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter a password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: confirmController,
              obscureText: obscureconPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureconPassword = !obscureconPassword;
                    });
                  },
                  child: Icon(
                    obscureconPassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value.length < 8) {
                  return 'Confirm Password must be at least 8 characters';
                } else if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              value: _selectedLevel,
              decoration: InputDecoration(labelText: 'Select Level'),
              items: ['1', '2', '3', '4']
                  .map((level) => DropdownMenuItem<String>(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                _selectedLevel = value;
              },
            ),
            SizedBox(height: 20.0),
            Text('Gender'),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _onSignUpButtonPressed(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 240, 143, 69),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text('Sign Up',
              style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFCIEmail(String email) {
    RegExp fciEmailPattern = RegExp(r'^[a-zA-Z0-9]+@stud\.fci-cu\.edu\.eg$');
    return fciEmailPattern.hasMatch(email);
  }

  void _onSignUpButtonPressed(BuildContext context) {
    // Validate form
    if (_formKey.currentState!.validate()) {
      // If valid, proceed with signup
      final String name = nameController.text.trim();
      final String email = emailController.text.trim();
      final String id = idController.text.trim();
      final String password = passwordController.text.trim();
      final String confirm = confirmController.text.trim();
      final String gender = _selectedGender!;
      final String level = _selectedLevel!;

      context.read<SignUpCubit>().signUp(
            name: name,
            email: email,
            id: id,
            password: password,
            confirm: confirm,
            gender: gender,
            level: level,
          );
      nameController.clear();
      emailController.clear();  
      idController.clear();
      passwordController.clear(); 
      confirmController.clear();
      setState(() {
            _selectedGender = null;
            _selectedLevel = null;
          });

    }
  }
}
