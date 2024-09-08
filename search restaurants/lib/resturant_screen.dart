import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Model/resturantmodel.dart';
import 'package:project/Model/search.dart';
import 'package:project/products_screen.dart';

import 'search_screen.dart';

class resturantscreen extends StatefulWidget {
  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<resturantscreen> {
  late RestaurantCubit restaurantCubit;

  @override
  void initState() {
    super.initState();
    restaurantCubit = RestaurantCubit();
    restaurantCubit.fetchRestaurants();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => restaurantCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resturant Page',style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              icon: Icon(Icons.search,color: Colors.white,),
              onPressed: () {
                SearchBloc searchbloc = SearchBloc();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(searchBloc: searchbloc,),
                  ),
                );
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 240, 143, 69),
          toolbarHeight: 85,
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<RestaurantCubit, RestaurantState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text(state.error!));
            } else {
              return ListView(
                children: state.restaurants.map((restaurant) {
                  return GestureDetector(
                    onTap: () {
                      _handleRestaurantTap(context, restaurant); // Corrected method call
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          restaurant.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${restaurant.id}'),
                            Text('Longitude: ${restaurant.longitude}'),
                            Text('Latitude: ${restaurant.latitude}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  void _handleRestaurantTap(BuildContext context, Restaurant restaurant) { // Corrected method definition
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(restaurantId: restaurant.id),
      ),
    );
  }

  @override
  void dispose() {
    restaurantCubit.close();
    super.dispose();
  }
}
