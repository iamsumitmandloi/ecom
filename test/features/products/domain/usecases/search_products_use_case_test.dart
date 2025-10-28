import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';
import 'package:ecom/features/products/domain/usecases/search_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late SearchProductsUseCase useCase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = SearchProductsUseCase(repository: mockRepository);
  });

  group('SearchProductsUseCase', () {
    final testProducts = [
      Product(
        id: '1',
        name: 'Laptop',
        description: 'Gaming laptop',
        price: 1299.99,
        imageUrl: 'url1',
        category: 'electronics',
        stock: 5,
        createdAt: DateTime(2024, 1, 1),
      ),
      Product(
        id: '2',
        name: 'Laptop Stand',
        description: 'Ergonomic stand',
        price: 49.99,
        imageUrl: 'url2',
        category: 'accessories',
        stock: 20,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('execute returns matching products from repository', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase.execute(query: 'laptop');

      // Assert
      expect(result, testProducts);
      verify(
        mockRepository.searchProducts(query: 'laptop', limit: 20),
      ).called(1);
    });

    test('execute passes custom limit to repository', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      await useCase.execute(query: 'laptop', limit: 10);

      // Assert
      verify(
        mockRepository.searchProducts(query: 'laptop', limit: 10),
      ).called(1);
    });

    test('execute trims whitespace from query', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      await useCase.execute(query: '  laptop  ');

      // Assert
      verify(
        mockRepository.searchProducts(query: 'laptop', limit: 20),
      ).called(1);
    });

    test(
      'execute throws InvalidSearchQueryException when query is too short',
      () async {
        // Act & Assert
        expect(
          () => useCase.execute(query: 'ab'),
          throwsA(isA<InvalidSearchQueryException>()),
        );

        verifyNever(
          mockRepository.searchProducts(
            query: anyNamed('query'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    test(
      'execute throws InvalidSearchQueryException when query is empty',
      () async {
        // Act & Assert
        expect(
          () => useCase.execute(query: ''),
          throwsA(isA<InvalidSearchQueryException>()),
        );

        verifyNever(
          mockRepository.searchProducts(
            query: anyNamed('query'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    test(
      'execute throws InvalidSearchQueryException when query is only whitespace',
      () async {
        // Act & Assert
        expect(
          () => useCase.execute(query: '   '),
          throwsA(isA<InvalidSearchQueryException>()),
        );

        verifyNever(
          mockRepository.searchProducts(
            query: anyNamed('query'),
            limit: anyNamed('limit'),
          ),
        );
      },
    );

    test('execute accepts query with minimum 3 characters', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      await useCase.execute(query: 'lap');

      // Assert
      verify(mockRepository.searchProducts(query: 'lap', limit: 20)).called(1);
    });

    test('execute returns empty list when no products match', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(query: 'nonexistent');

      // Assert
      expect(result, isEmpty);
    });

    test('execute throws exception when repository fails', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.execute(query: 'laptop'), throwsException);
    });

    test('execute handles special characters in query', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      await useCase.execute(query: 'laptop-2024');

      // Assert
      verify(
        mockRepository.searchProducts(query: 'laptop-2024', limit: 20),
      ).called(1);
    });

    test('execute can be called with function call syntax', () async {
      // Arrange
      when(
        mockRepository.searchProducts(
          query: anyNamed('query'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase(query: 'laptop');

      // Assert
      expect(result, testProducts);
      verify(
        mockRepository.searchProducts(query: 'laptop', limit: 20),
      ).called(1);
    });
  });
}
