import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // Load environment variables
  await dotenv.load(fileName: '.env');

  final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
  final apiKey = dotenv.env['FIREBASE_WEB_API_KEY'];

  if (projectId == null || apiKey == null) {
    print(
      '❌ Error: FIREBASE_PROJECT_ID and FIREBASE_WEB_API_KEY must be set in .env file',
    );
    exit(1);
  }

  final dio = Dio();
  final baseUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  print('🚀 Adding sample products to Firestore...');
  print('Project ID: $projectId');

  try {
    // Add categories first
    await _addCategories(dio, baseUrl, apiKey);

    // Add products
    await _addProducts(dio, baseUrl, apiKey);

    print('✅ Sample data added successfully!');
  } catch (e) {
    print('❌ Error adding sample data: $e');
    exit(1);
  }
}

Future<void> _addCategories(Dio dio, String baseUrl, String apiKey) async {
  print('\n📁 Adding categories...');

  final categories = [
    {
      'name': 'Electronics',
      'description': 'Electronic devices and gadgets',
      'productCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Clothing',
      'description': 'Fashion and apparel',
      'productCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Books',
      'description': 'Various genres of books',
      'productCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Home & Garden',
      'description': 'Items for home improvement and gardening',
      'productCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  for (int i = 0; i < categories.length; i++) {
    final category = categories[i];
    final categoryId = category['name']!
        .toString()
        .toLowerCase()
        .replaceAll(' ', '-')
        .replaceAll('&', 'and');

    try {
      final response = await dio.patch(
        '$baseUrl/categories/$categoryId',
        queryParameters: {'key': apiKey},
        data: {'fields': _mapToFirestoreFields(category)},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('✅ Added category: ${category['name']}');
      } else {
        print(
          '⚠️  Category ${category['name']} response: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Document doesn't exist, try POST instead
        try {
          final response = await dio.post(
            '$baseUrl/categories/$categoryId',
            queryParameters: {'key': apiKey},
            data: {'fields': _mapToFirestoreFields(category)},
            options: Options(headers: {'Content-Type': 'application/json'}),
          );
          print('✅ Added category: ${category['name']}');
        } catch (postError) {
          print('❌ Failed to add category ${category['name']}: ${postError}');
        }
      } else {
        print(
          '❌ Failed to add category ${category['name']}: ${e.response?.data ?? e.message}',
        );
      }
    }
  }
}

Future<void> _addProducts(Dio dio, String baseUrl, String apiKey) async {
  print('\n📦 Adding products...');

  final products = [
    {
      'name': 'iPhone 15 Pro',
      'description':
          'Latest iPhone with titanium design and A17 Pro chip. Features advanced camera system and USB-C connectivity.',
      'price': 999.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1592899677977-9c6c0b8b9b8b?w=500',
      'category': 'electronics',
      'stock': 50,
      'rating': 4.8,
      'reviewCount': 1250,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'MacBook Pro 16"',
      'description':
          'Powerful laptop with M3 Pro chip, perfect for professionals and creators.',
      'price': 2499.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=500',
      'category': 'electronics',
      'stock': 25,
      'rating': 4.9,
      'reviewCount': 800,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'AirPods Pro',
      'description':
          'Wireless earbuds with active noise cancellation and spatial audio.',
      'price': 249.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=500',
      'category': 'electronics',
      'stock': 100,
      'rating': 4.7,
      'reviewCount': 2500,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Nike Air Max 270',
      'description':
          'Comfortable running shoes with Max Air cushioning and breathable upper.',
      'price': 150.00,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      'category': 'clothing',
      'stock': 75,
      'rating': 4.5,
      'reviewCount': 900,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Levi\'s 501 Jeans',
      'description': 'Classic straight-fit jeans made from 100% cotton denim.',
      'price': 89.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500',
      'category': 'clothing',
      'stock': 120,
      'rating': 4.6,
      'reviewCount': 1500,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Clean Code',
      'description':
          'A Handbook of Agile Software Craftsmanship by Robert C. Martin.',
      'price': 45.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500',
      'category': 'books',
      'stock': 200,
      'rating': 4.9,
      'reviewCount': 3000,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Philips Hue Starter Kit',
      'description':
          'Smart lighting system with color-changing bulbs and bridge.',
      'price': 199.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      'category': 'home-garden',
      'stock': 30,
      'rating': 4.4,
      'reviewCount': 600,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
    {
      'name': 'Dyson V15 Detect',
      'description':
          'Cordless vacuum with laser dust detection and powerful suction.',
      'price': 749.99,
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
      'category': 'home-garden',
      'stock': 15,
      'rating': 4.7,
      'reviewCount': 400,
      'isFavorite': false,
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  for (int i = 0; i < products.length; i++) {
    final product = products[i];
    final productId = 'product-${i + 1}';

    try {
      final response = await dio.patch(
        '$baseUrl/products/$productId',
        queryParameters: {'key': apiKey},
        data: {'fields': _mapToFirestoreFields(product)},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        print('✅ Added product: ${product['name']}');
      } else {
        print(
          '⚠️  Product ${product['name']} response: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Document doesn't exist, try POST instead
        try {
          final response = await dio.post(
            '$baseUrl/products/$productId',
            queryParameters: {'key': apiKey},
            data: {'fields': _mapToFirestoreFields(product)},
            options: Options(headers: {'Content-Type': 'application/json'}),
          );
          print('✅ Added product: ${product['name']}');
        } catch (postError) {
          print('❌ Failed to add product ${product['name']}: ${postError}');
        }
      } else {
        print(
          '❌ Failed to add product ${product['name']}: ${e.response?.data ?? e.message}',
        );
      }
    }
  }
}

Map<String, dynamic> _mapToFirestoreFields(Map<String, dynamic> data) {
  final fields = <String, dynamic>{};

  for (final entry in data.entries) {
    final key = entry.key;
    final value = entry.value;

    if (value is String) {
      fields[key] = {'stringValue': value};
    } else if (value is num) {
      if (value is int) {
        fields[key] = {'integerValue': value.toString()};
      } else {
        fields[key] = {'doubleValue': value};
      }
    } else if (value is bool) {
      fields[key] = {'booleanValue': value};
    }
  }

  return fields;
}
