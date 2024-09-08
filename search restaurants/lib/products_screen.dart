import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Model/productsmodel.dart';

class ProductScreen extends StatelessWidget {
  final int restaurantId;

  ProductScreen({required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..fetchProducts(restaurantId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products',style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 240, 143, 69),
          toolbarHeight: 85,
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color here
          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.error != null) {
              return Center(
                child: Text(state.error!),
              );
            } else {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text(
                        'Description: ${product.description}\nPrice: \$${product.price.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
