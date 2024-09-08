import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

class Product {
  final String name;
  final String description;
  final double price;

  Product({
    required this.name,
    required this.description,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }
}

class ProductState {
  final bool isLoading;
  final String? error;
  final List<Product> products;

  ProductState({
    required this.isLoading,
    this.error,
    this.products = const [],
  });

  factory ProductState.initial() {
    return ProductState(isLoading: false);
  }

  ProductState copyWith({
    bool? isLoading,
    String? error,
    List<Product>? products,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      products: products ?? this.products,
    );
  }
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductState.initial());

  Future<void> fetchProducts(int restaurantId) async {
    emit(state.copyWith(isLoading: true));

    try {
      String uri =
          "http://192.168.56.1/projectapi/products.php?restaurantId=$restaurantId";
      var res = await http.get(Uri.parse(uri));

      if (res.statusCode == 200) {
        List<dynamic> productList = jsonDecode(res.body);

        List<Product> products = productList.map((item) {
          return Product.fromJson(item);
        }).toList();

        emit(state.copyWith(isLoading: false, products: products));
      } else {
        emit(state.copyWith(
            isLoading: false, error: "Failed to connect to server"));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: "Failed to fetch data: $e"));
    }
  }
}
