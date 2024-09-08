import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class Restaurant {
  final int id;
  final String name;
  final double longitude;
  final double latitude;
  final double distance;

  Restaurant({
    required this.id,
    required this.name,
    required this.longitude,
    required this.latitude,
    required this.distance,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: int.parse(json['ID']),
      name: json['Name'],
      longitude: double.parse(json['Longitude']),
      latitude: double.parse(json['Latitude']),
      distance: double.parse(json['Distance']),
    );
  }
}

class RestaurantState {
  final bool isLoading;
  final String? error;
  final List<Restaurant> restaurants;

  RestaurantState({
    required this.isLoading,
    this.error,
    this.restaurants = const [],
  });

  factory RestaurantState.initial() {
    return RestaurantState(isLoading: false);
  }

  RestaurantState copyWith({
    bool? isLoading,
    String? error,
    List<Restaurant>? restaurants,
  }) {
    return RestaurantState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      restaurants: restaurants ?? this.restaurants,
    );
  }
}

class RestaurantCubit extends Cubit<RestaurantState> {
  RestaurantCubit() : super(RestaurantState.initial());

  Future<void> fetchRestaurants() async {
    emit(state.copyWith(isLoading: true));

    try {
      String uri = "http://192.168.56.1/projectapi/resturant.php";
      var res = await http.get(Uri.parse(uri));

      if (res.statusCode == 200) {
        List<dynamic> restaurantList = jsonDecode(res.body);

        List<Restaurant> restaurants = restaurantList.map((item) {
          return Restaurant.fromJson(item);
        }).toList();

        emit(state.copyWith(isLoading: false, restaurants: restaurants));
      } else {
        emit(state.copyWith(
            isLoading: false, error: "Failed to connect to server"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to fetch data: $e"));
    }
  }
}
