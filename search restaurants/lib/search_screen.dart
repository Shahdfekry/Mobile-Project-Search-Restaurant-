import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'Model/resturantmodel.dart';
import 'Model/search.dart';
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SearchScreen extends StatefulWidget {
  final SearchBloc searchBloc;

  const SearchScreen({Key? key, required this.searchBloc}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _productNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 240, 143, 69),
        toolbarHeight: 85,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color here
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _productNameController,
              decoration: InputDecoration(
                hintText: 'Enter Product Name',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _searchProducts,
            child: const Text(
              'Search',
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Restaurant>>(
              stream: widget.searchBloc.searchResultsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final restaurant = snapshot.data![index];
                      return ListTile(
                          title: Text(restaurant.name),
                          onTap: () async {
                            bool permissionGranted =
                                await requestLocationPermission();
                            if (permissionGranted) {
                              await _launchUrl(restaurant);
                            } else {
                              print('Location permission denied');
                            }
                          });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Restaurant restaurant) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}';
    if (await canLaunchUrlString(url)) {
      await _showDistanceDialog(context, restaurant);
    } else {
      throw 'Could not open the map.';
    }
    await launchUrlString(url);
  }

  Future<bool> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _showDistanceDialog(
      BuildContext context, Restaurant restaurant) async {
    Position? userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // ignore: unnecessary_null_comparison
    if (userLocation != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        restaurant.latitude,
        restaurant.longitude,
      );

      double distanceInKm = distanceInMeters / 1000;
      String distanceText = distanceInKm.toStringAsFixed(2) + ' km';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Distance to ${restaurant.name}'),
            content: Text('The distance from your location is $distanceText.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Error'),
            content: Text('Could not fetch your current location.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _searchProducts() {
    String productName = _productNameController.text.trim();
    widget.searchBloc.searchProducts(productName);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    super.dispose();
  }
}





// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'Model/resturantmodel.dart';
// import 'Model/search.dart';
// // ignore: unused_import
// import 'package:url_launcher/url_launcher.dart';

// class SearchScreen extends StatefulWidget {
//   final SearchBloc searchBloc;

//   const SearchScreen({Key? key, required this.searchBloc}) : super(key: key);

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _productNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Products',
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color.fromARGB(255, 240, 143, 69),
//         toolbarHeight: 85,
//         iconTheme: const IconThemeData(
//           color: Colors.white, // Change the color here
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: TextField(
//               controller: _productNameController,
//               decoration: InputDecoration(
//                 hintText: 'Enter Product Name',
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: _searchProducts,
//             child: const Text(
//               'Search',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),
//           Expanded(
//             child: StreamBuilder<List<Restaurant>>(
//               stream: widget.searchBloc.searchResultsStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       final restaurant = snapshot.data![index];
//                       return ListTile(
//                         title: Text(restaurant.name),
//                         onTap: () => _launchUrl(restaurant),
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 } else {
//                   return SizedBox.shrink();
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _launchUrl(Restaurant restaurant) async {
//     final url =
//         'https://www.google.com/maps/search/?api=1&query=${restaurant.latitude},${restaurant.longitude}';
//     if (await canLaunchUrlString(url)) {
//       await launchUrlString(url);
//     } else {
//       throw 'Could not open the map.';
//     }
//   }

//   void _searchProducts() {
//     String productName = _productNameController.text.trim();
//     widget.searchBloc.searchProducts(productName);
//   }

//   @override
//   void dispose() {
//     _productNameController.dispose();
//     super.dispose();
//   }
// }