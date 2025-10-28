import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  // Load environment variables from .env file
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('❌ Error: .env file not found');
    exit(1);
  }

  final envContent = await envFile.readAsString();
  final envVars = <String, String>{};

  for (final line in envContent.split('\n')) {
    final trimmedLine = line.trim();
    if (trimmedLine.isNotEmpty && !trimmedLine.startsWith('#')) {
      final parts = trimmedLine.split('=');
      if (parts.length == 2) {
        envVars[parts[0].trim()] = parts[1].trim();
      }
    }
  }

  final projectId = envVars['FIREBASE_PROJECT_ID'];
  final apiKey = envVars['FIREBASE_WEB_API_KEY'];

  if (projectId == null || apiKey == null) {
    print(
      '❌ Error: FIREBASE_PROJECT_ID and FIREBASE_WEB_API_KEY must be set in .env file',
    );
    exit(1);
  }

  print('🚀 Adding sample products to Firestore...');
  print('Project ID: $projectId');

  try {
    // Add categories first
    // await _addCategories(projectId, apiKey);

    // Add products
    await _addProducts(projectId, apiKey);

    print('✅ Sample data added successfully!');
  } catch (e) {
    print('❌ Error adding sample data: $e');
    exit(1);
  }
}

Future<void> _addCategories(String projectId, String apiKey) async {
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
      final success = await _addDocument(
        projectId,
        apiKey,
        'categories',
        categoryId,
        category,
      );
      if (success) {
        print('✅ Added category: ${category['name']}');
      } else {
        print('❌ Failed to add category: ${category['name']}');
      }
    } catch (e) {
      print('❌ Error adding category ${category['name']}: $e');
    }
  }
}

Future<void> _addProducts(String projectId, String apiKey) async {
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
    final productId = 'product-${i + 33}';

    try {
      final success = await _addDocument(
        projectId,
        apiKey,
        'products',
        productId,
        product,
      );
      if (success) {
        print('✅ Added product: ${product['name']}');
      } else {
        print('❌ Failed to add product: ${product['name']}');
      }
    } catch (e) {
      print('❌ Error adding product ${product['name']}: $e');
    }
  }
}

Future<bool> _addDocument(
  String projectId,
  String apiKey,
  String collection,
  String documentId,
  Map<String, dynamic> data,
) async {
  final url =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/$collection/$documentId';

  final requestBody = {'fields': _mapToFirestoreFields(data)};

  final request = await HttpClient().openUrl(
    'PATCH',
    Uri.parse('$url?key=$apiKey'),
  );
  request.headers.set('Content-Type', 'application/json');
  request.write(jsonEncode(requestBody));

  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 404) {
    // Document doesn't exist, try POST instead
    final postRequest = await HttpClient().openUrl(
      'POST',
      Uri.parse('$url?key=$apiKey'),
    );
    postRequest.headers.set('Content-Type', 'application/json');
    postRequest.write(jsonEncode(requestBody));

    final postResponse = await postRequest.close();
    return postResponse.statusCode == 200;
  } else {
    print('HTTP Error ${response.statusCode}: $responseBody');
    return false;
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
