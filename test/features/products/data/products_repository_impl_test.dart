import 'package:dio/dio.dart';
import 'package:ecom/features/products/data/products_api.dart';
import 'package:ecom/features/products/data/products_repository_impl.dart';
import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'products_repository_impl_test.mocks.dart';

@GenerateMocks([ProductsApi])
void main() {
  late ProductsRepositoryImpl repository;
  late MockProductsApi mockApi;

  setUp(() {
    mockApi = MockProductsApi();
    repository = ProductsRepositoryImpl(api: mockApi);
  });

  group('ProductsRepositoryImpl', () {
    group('getProducts', () {
      test('should return list of products when API call succeeds', () async {
        // Arrange
        final mockFirestoreResponse = [
          {
            'document': {
              'name':
                  'projects/test-project/databases/(default)/documents/products/1',
              'fields': {
                'name': {'stringValue': 'Test Product 1'},
                'description': {'stringValue': 'Description 1'},
                'price': {'doubleValue': 10.0},
                'imageUrl': {'stringValue': 'https://example.com/image1.jpg'},
                'category': {'stringValue': 'electronics'},
                'stock': {'integerValue': '5'},
                'rating': {'doubleValue': 4.5},
                'reviewCount': {'integerValue': '10'},
                'isFavorite': {'booleanValue': false},
                'createdAt': {'timestampValue': '2024-01-01T00:00:00Z'},
                'updatedAt': {'timestampValue': '2024-01-01T00:00:00Z'},
              },
            },
          },
          {
            'document': {
              'name':
                  'projects/test-project/databases/(default)/documents/products/2',
              'fields': {
                'name': {'stringValue': 'Test Product 2'},
                'description': {'stringValue': 'Description 2'},
                'price': {'doubleValue': 20.0},
                'imageUrl': {'stringValue': 'https://example.com/image2.jpg'},
                'category': {'stringValue': 'clothing'},
                'stock': {'integerValue': '3'},
                'rating': {'doubleValue': 3.8},
                'reviewCount': {'integerValue': '5'},
                'isFavorite': {'booleanValue': true},
                'createdAt': {'timestampValue': '2024-01-02T00:00:00Z'},
                'updatedAt': {'timestampValue': '2024-01-02T00:00:00Z'},
              },
            },
          },
        ];

        when(
          mockApi.getProducts(
            category: anyNamed('category'),
            limit: anyNamed('limit'),
            startAfter: anyNamed('startAfter'),
          ),
        ).thenAnswer((_) async => {'documents': mockFirestoreResponse});

        // Act
        final result = await repository.getProducts(
          limit: 10,
          startAfter: null,
          category: null,
        );

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('1'));
        expect(result[0].name, equals('Test Product 1'));
        expect(result[1].id, equals('2'));
        expect(result[1].name, equals('Test Product 2'));
        verify(
          mockApi.getProducts(category: null, limit: 10, startAfter: null),
        ).called(1);
      });

      test('should throw ProductFetchException when API call fails', () async {
        // Arrange
        when(
          mockApi.getProducts(
            category: anyNamed('category'),
            limit: anyNamed('limit'),
            startAfter: anyNamed('startAfter'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            response: Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: 500,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getProducts(
            limit: 10,
            startAfter: null,
            category: null,
          ),
          throwsA(isA<ProductFetchException>()),
        );
        verify(
          mockApi.getProducts(category: null, limit: 10, startAfter: null),
        ).called(1);
      });

      test('should pass correct parameters to API', () async {
        // Arrange
        when(
          mockApi.getProducts(
            category: anyNamed('category'),
            limit: anyNamed('limit'),
            startAfter: anyNamed('startAfter'),
          ),
        ).thenAnswer((_) async => {'documents': <Map<String, dynamic>>[]});

        // Act
        await repository.getProducts(
          limit: 5,
          startAfter: 'lastProductId',
          category: 'electronics',
        );

        // Assert
        verify(
          mockApi.getProducts(
            category: 'electronics',
            limit: 5,
            startAfter: 'lastProductId',
          ),
        ).called(1);
      });
    });

    group('getProductById', () {
      test('should return product when API call succeeds', () async {
        // Arrange
        const productId = 'test-product-id';
        final mockFirestoreResponse = {
          'name':
              'projects/test-project/databases/(default)/documents/products/$productId',
          'fields': {
            'name': {'stringValue': 'Test Product'},
            'description': {'stringValue': 'Test Description'},
            'price': {'doubleValue': 15.0},
            'imageUrl': {'stringValue': 'https://example.com/image.jpg'},
            'category': {'stringValue': 'electronics'},
            'stock': {'integerValue': '10'},
            'rating': {'doubleValue': 4.2},
            'reviewCount': {'integerValue': '8'},
            'isFavorite': {'booleanValue': false},
            'createdAt': {'timestampValue': '2024-01-01T00:00:00Z'},
            'updatedAt': {'timestampValue': '2024-01-01T00:00:00Z'},
          },
        };

        when(
          mockApi.getProductById(productId),
        ).thenAnswer((_) async => mockFirestoreResponse);

        // Act
        final result = await repository.getProductById(productId);

        // Assert
        expect(result, isA<Product>());
        expect(result.id, equals(productId));
        expect(result.name, equals('Test Product'));
        verify(mockApi.getProductById(productId)).called(1);
      });

      test(
        'should throw ProductNotFoundException when product not found',
        () async {
          // Arrange
          const productId = 'non-existent-id';
          when(mockApi.getProductById(productId)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/'),
              response: Response(
                requestOptions: RequestOptions(path: '/'),
                statusCode: 404,
              ),
            ),
          );

          // Act & Assert
          expect(
            () => repository.getProductById(productId),
            throwsA(isA<ProductNotFoundException>()),
          );
          verify(mockApi.getProductById(productId)).called(1);
        },
      );

      test('should throw ProductFetchException for other API errors', () async {
        // Arrange
        const productId = 'test-id';
        when(mockApi.getProductById(productId)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            response: Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: 500,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getProductById(productId),
          throwsA(isA<ProductFetchException>()),
        );
        verify(mockApi.getProductById(productId)).called(1);
      });
    });

    group('searchProducts', () {
      test('should return search results when API call succeeds', () async {
        // Arrange
        const query = 'laptop';
        final mockFirestoreResponse = [
          {
            'document': {
              'name':
                  'projects/test-project/databases/(default)/documents/products/1',
              'fields': {
                'name': {'stringValue': 'Gaming Laptop'},
                'description': {
                  'stringValue': 'High-performance gaming laptop',
                },
                'price': {'doubleValue': 1200.0},
                'imageUrl': {'stringValue': 'https://example.com/laptop.jpg'},
                'category': {'stringValue': 'electronics'},
                'stock': {'integerValue': '5'},
                'rating': {'doubleValue': 4.8},
                'reviewCount': {'integerValue': '25'},
                'isFavorite': {'booleanValue': false},
                'createdAt': {'timestampValue': '2024-01-01T00:00:00Z'},
                'updatedAt': {'timestampValue': '2024-01-01T00:00:00Z'},
              },
            },
          },
        ];

        when(
          mockApi.searchProducts(
            query: anyNamed('query'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => {'documents': mockFirestoreResponse});

        // Act
        final result = await repository.searchProducts(query: query, limit: 10);

        // Assert
        expect(result, isA<List<Product>>());
        expect(result.length, equals(1));
        expect(result[0].name, equals('Gaming Laptop'));
        verify(mockApi.searchProducts(query: query, limit: 10)).called(1);
      });

      test(
        'should throw InvalidSearchQueryException for empty query',
        () async {
          // Act & Assert
          expect(
            () => repository.searchProducts(query: '', limit: 10),
            throwsA(isA<InvalidSearchQueryException>()),
          );
          verifyNever(
            mockApi.searchProducts(
              query: anyNamed('query'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );

      test(
        'should throw InvalidSearchQueryException for whitespace-only query',
        () async {
          // Act & Assert
          expect(
            () => repository.searchProducts(query: '   ', limit: 10),
            throwsA(isA<InvalidSearchQueryException>()),
          );
          verifyNever(
            mockApi.searchProducts(
              query: anyNamed('query'),
              limit: anyNamed('limit'),
            ),
          );
        },
      );

      test('should throw ProductFetchException when API call fails', () async {
        // Arrange
        const query = 'test query';
        when(
          mockApi.searchProducts(
            query: anyNamed('query'),
            limit: anyNamed('limit'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            response: Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: 500,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.searchProducts(query: query, limit: 10),
          throwsA(isA<ProductFetchException>()),
        );
        verify(mockApi.searchProducts(query: query, limit: 10)).called(1);
      });
    });

    group('getCategories', () {
      test('should return list of categories when API call succeeds', () async {
        // Arrange
        final mockFirestoreResponse = [
          {
            'document': {
              'name':
                  'projects/test-project/databases/(default)/documents/categories/electronics',
              'fields': {
                'name': {'stringValue': 'Electronics'},
                'description': {
                  'stringValue': 'Electronic devices and gadgets',
                },
                'imageUrl': {
                  'stringValue': 'https://example.com/electronics.jpg',
                },
                'productCount': {'integerValue': '15'},
              },
            },
          },
          {
            'document': {
              'name':
                  'projects/test-project/databases/(default)/documents/categories/clothing',
              'fields': {
                'name': {'stringValue': 'Clothing'},
                'description': {'stringValue': 'Fashion and apparel'},
                'imageUrl': {'stringValue': 'https://example.com/clothing.jpg'},
                'productCount': {'integerValue': '8'},
              },
            },
          },
        ];

        when(
          mockApi.getCategories(),
        ).thenAnswer((_) async => {'documents': mockFirestoreResponse});

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, isA<List<Category>>());
        expect(result.length, equals(2));
        expect(result[0].id, equals('electronics'));
        expect(result[0].name, equals('Electronics'));
        expect(result[1].id, equals('clothing'));
        expect(result[1].name, equals('Clothing'));
        verify(mockApi.getCategories()).called(1);
      });

      test('should throw ProductFetchException when API call fails', () async {
        // Arrange
        when(mockApi.getCategories()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/'),
            response: Response(
              requestOptions: RequestOptions(path: '/'),
              statusCode: 500,
            ),
          ),
        );

        // Act & Assert
        expect(
          () => repository.getCategories(),
          throwsA(isA<ProductFetchException>()),
        );
        verify(mockApi.getCategories()).called(1);
      });
    });

    group('toggleFavorite', () {
      test('should throw UnimplementedError', () async {
        // Act & Assert
        expect(
          () => repository.toggleFavorite(
            productId: 'product-id',
            isFavorite: true,
          ),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });

    group('getFavoriteProducts', () {
      test('should throw UnimplementedError', () async {
        // Act & Assert
        expect(
          () => repository.getFavoriteProducts(),
          throwsA(isA<UnimplementedError>()),
        );
      });
    });
  });
}
