import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory LoginState.initial() {
    return LoginState(isLoading: false, isSuccess: false);
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState.initial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      String uri = "http://192.168.56.1/projectapi/login.php";
      var res = await http.post(Uri.parse(uri), body: {
        "email": email,
        "password": password,
      });

      var response = jsonDecode(res.body);

      if (response["success"] == true) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, error: "Invalid credentials"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Login failed"));
    }
  }
}
