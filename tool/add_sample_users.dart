import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// IMPORTANT: Before running, make sure to set the following environment variables:
// - FIREBASE_PROJECT_ID: Your Firebase project ID.
// - FIREBASE_WEB_API_KEY: Your Firebase Web API Key.
// - FIREBASE_USER_EMAIL: The email for the test user.
// - FIREBASE_USER_PASSWORD: The password for the test user.

Future<void> main() async {
  // FIREBASE_WEB_API_KEY=AIzaSyBiii0QJoqAHM_c3nX9z3x5hX_c4jRaXTw
  // FIREBASE_PROJECT_ID=ecom-36e16
  final projectId = "ecom-36e16";
  final apiKey = "AIzaSyBiii0QJoqAHM_c3nX9z3x5hX_c4jRaXTw";
  final email = "kumar${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}@gmail.com";
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

  print('--- Seeding User and Address Data ---');

  // 1. Authenticate as the user to get a User ID and Auth Token
  final authResponse = await http.post(
    Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey',
    ),
    body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }),
  );

  if (authResponse.statusCode >= 400) {
    print(
        'User sign-up failed. The user may already exist. Trying to sign in...');
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
    await _seedUserData(projectId, userId, email, authToken);
  } else {
    final authData = json.decode(authResponse.body);
    final userId = authData['localId'];
    final authToken = authData['idToken'];
    await _seedUserData(projectId, userId, email, authToken);
  }

  print('--- User and Address Data Seeding Complete ---');
}

Future<void> _seedUserData(
  String projectId,
  String userId,
  String email,
  String authToken,
) async {
  final firestoreUrl =
      'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  // 2. Create the main user document with expanded fields
  print('Creating user document for $userId...');
  await http.patch(
    Uri.parse('$firestoreUrl/users/$userId?updateMask.fieldPaths=email&updateMask.fieldPaths=displayName&updateMask.fieldPaths=createdAt&updateMask.fieldPaths=age&updateMask.fieldPaths=gender&updateMask.fieldPaths=contact'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    },
    body: json.encode({
      'fields': {
        'email': {'stringValue': email},
        'displayName': {'stringValue': 'Sumit Mandloi'},
        'age': {'integerValue': '30'},
        'gender': {'stringValue': 'Male'},
        'contact': {'stringValue': '+91 98765 43210'},
        'createdAt': {'timestampValue': DateTime.now().toUtc().toIso8601String()},
      },
    }),
  );

  // 3. Add two sample Indian addresses to the 'addresses' subcollection
  print('Adding sample addresses...');
  final addresses = [
    {
      'fullName': {'stringValue': 'Home Address'},
      'addressLine1': {'stringValue': '101, Marine Drive'},
      'city': {'stringValue': 'Mumbai'},
      'state': {'stringValue': 'Maharashtra'},
      'zipCode': {'stringValue': '400001'},
      'isDefault': {'booleanValue': true},
    },
    {
      'fullName': {'stringValue': 'Work Office'},
      'addressLine1': {'stringValue': '202, Koramangala 4th Block'},
      'city': {'stringValue': 'Bengaluru'},
      'state': {'stringValue': 'Karnataka'},
      'zipCode': {'stringValue': '560034'},
      'isDefault': {'booleanValue': false},
    },
  ];

  for (final address in addresses) {
    await http.post(
      Uri.parse('$firestoreUrl/users/$userId/addresses'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({'fields': address}),
    );
  }
  print('Successfully added ${addresses.length} addresses.');
}
