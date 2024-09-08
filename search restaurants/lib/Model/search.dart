import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project/Model/resturantmodel.dart';

class SearchBloc {
  final _searchResultsController = StreamController<List<Restaurant>>();
  Stream<List<Restaurant>> get searchResultsStream =>
      _searchResultsController.stream;

  void searchProducts(String productName) async {
    String url =
        "http://192.168.56.1/projectapi/search.php?productName=$productName";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Restaurant> restaurants = data
            .map((item) => Restaurant(
                id: int.parse(item['id']),
                name: item['name'],
                latitude: double.parse(item['latitude']),
                longitude: double.parse(item['longitude']),
                distance: double.parse(item['distance'])))
            .toList();
        _searchResultsController.sink.add(restaurants);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      _searchResultsController.addError('Not Found');
    }
  }

  void dispose() {
    _searchResultsController.close();
  }
}
