import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// IMPORTANT: Before running, make sure to set the following environment variables:
// - FIREBASE_PROJECT_ID: Your Firebase project ID.
// - FIREBASE_WEB_API_KEY: Your Firebase Web API Key.
// - FIREBASE_USER_EMAIL: The email for the test user.
// - FIREBASE_USER_PASSWORD: The password for the test user.

Future<void> main() async {
  final projectId = "ecom-36e16";
  final apiKey = "AIzaSyBiii0QJoqAHM_c3nX9z3x5hX_c4jRaXTw";
  final email = "kumar1547@gmail.com";
  final password = "12345678";

  if (projectId == null ||
      apiKey == null ||
      email == null ||
      password == null) {
    print(
      'Error: Missing required environment variables. Please set FIREBASE_PROJECT_ID, '
      'FIREBASE_WEB_API_KEY, FIREBASE_USER_EMAIL, and FIREBASE_USER_PASSWORD.',
    );
    exit(1);
  }

  print('--- Seeding Order Data ---');

  // 1. Authenticate to get User ID and Auth Token
  print('Authenticating user...');
  final signInResponse = await http.post(
    Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey',
    ),
    body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  if (signInResponse.statusCode >= 400) {
    print('Error: Sign-in failed: ${signInResponse.body}');
    exit(1);
  }
  final signInData = json.decode(signInResponse.body);
  final userId = signInData['localId'];
  final authToken = signInData['idToken'];
  print('User authenticated successfully.');

  final firestoreUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  // 2. Fetch the user's default address
  print('Fetching user\'s default address...');
  final addressQuery = {
    'structuredQuery': {
      'from': [
        {'collectionId': 'addresses'}
      ],
      'where': {
        'fieldFilter': {
          'field': {'fieldPath': 'isDefault'},
          'op': 'EQUAL',
          'value': {'booleanValue': true}
        }
      },
      'limit': 1
    }
  };
  final addressResponse = await http.post(
    Uri.parse('$firestoreUrl/users/$userId:runQuery'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
    body: json.encode(addressQuery),
  );
  final addressDocs = json.decode(addressResponse.body);
  if (addressDocs.isEmpty || addressDocs[0]['document'] == null) {
    print('Error: No default address found for the user.');
    exit(1);
  }
  final shippingAddress = addressDocs[0]['document']['fields'];
  print('Default address found.');

  // 3. Fetch two products to add to the order
  print('Fetching products to add to order...');
  final productQuery = {
    'structuredQuery': {
      'from': [
        {'collectionId': 'products'}
      ],
      'limit': 2
    }
  };
  final productsResponse = await http.post(
    Uri.parse('$firestoreUrl:runQuery'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
    body: json.encode(productQuery),
  );
  final productDocs = json.decode(productsResponse.body);
  if (productDocs.isEmpty || productDocs[0]['document'] == null) {
    print('Error: No products found in the database.');
    exit(1);
  }
  print('Products fetched.');

  // 4. Construct the order payload
  print('Constructing order...');
  final items = [];
  double subtotal = 0.0;

  for (var doc in productDocs) {
    final productFields = doc['document']['fields'];
    final price = (productFields['price']['doubleValue'] ??
            productFields['price']['integerValue'])
        .toDouble();
    final quantity = items.length + 1;
    subtotal += price * quantity;

    items.add({
      'mapValue': {
        'fields': {
          'productId': {'stringValue': doc['document']['name'].split('/').last},
          'productName': productFields['name'],
          'price': {'doubleValue': price},
          'quantity': {'integerValue': quantity.toString()},
          'imageUrl': productFields['imageUrl'],
        }
      }
    });
  }

  final tax = subtotal * 0.085;
  final shipping = 5.99;
  final total = subtotal + tax + shipping;

  final orderPayload = {
    'fields': {
      'userId': {'stringValue': userId},
      'createdAt': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
      'status': {'stringValue': 'pending'},
      'shippingAddress': {'mapValue': {'fields': shippingAddress}},
      'items': {'arrayValue': {'values': items}},
      'payment': {
        'mapValue': {
          'fields': {
            'subtotal': {'doubleValue': subtotal},
            'shipping': {'doubleValue': shipping},
            'tax': {'doubleValue': tax},
            'total': {'doubleValue': total},
          }
        }
      }
    }
  };

  // 5. Create the order document
  print('Creating order document in Firestore...');
  final createOrderResponse = await http.post(
    Uri.parse('$firestoreUrl/orders'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
    body: json.encode(orderPayload),
  );

  if (createOrderResponse.statusCode >= 400) {
    print('Error: Failed to create order: ${createOrderResponse.body}');
    exit(1);
  }

  print('Order created successfully!');
  print('--- Order Data Seeding Complete ---');
}
