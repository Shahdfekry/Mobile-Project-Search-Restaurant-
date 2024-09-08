import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  SignUpState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory SignUpState.initial() {
    return SignUpState(isLoading: false, isSuccess: false);
  }

  SignUpState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return SignUpState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
    );
  }
}

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpState.initial());

  Future<void> signUp({
    required String name,
    required String email,
    required String id,
    required String password,
    required String confirm,
    required String gender,
    required String level,
  }) async {
    emit(state.copyWith(isLoading: true));

    try {
      String uri = "http://192.168.56.1/projectapi/insertdata.php";
      var res = await http.post(Uri.parse(uri), body: {
        "name": name,
        "email": email,
        "id": id,
        "password": password,
        "confirm": confirm,
        "level": level,
        "gender": gender,
      });

      var response = jsonDecode(res.body);
      if (response["success"] == true) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        emit(state.copyWith(isLoading: false, error: response["message"]));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to sign up"));
    }
  }
}
