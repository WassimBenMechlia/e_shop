import 'package:dio/dio.dart';

import '../model/models.dart';
import 'constants.dart';

Dio _dio = new Dio();

Future<List<Product>> fetchProducts() async {
  try {
    final response = await _dio.get(AppConstants.baseUrl);

    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      List<Product> products = data
          .map((item) => Product(
                id: item['id'],
                title: item['title'],
                price: item['price'].toDouble(),
                description: item['description'],
                category: item['category'],
                image: item['image'],
              ))
          .toList();

      return products;
    } else {
      throw Exception('Failed to load products');
    }
  } catch (error) {
    throw Exception('Error: $error');
  }
}
