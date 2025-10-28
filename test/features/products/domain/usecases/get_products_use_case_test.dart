import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';
import 'package:ecom/features/products/domain/usecases/get_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_products_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late GetProductsUseCase useCase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = GetProductsUseCase(repository: mockRepository);
  });

  group('GetProductsUseCase', () {
    final testProducts = [
      Product(
        id: '1',
        name: 'Product 1',
        description: 'Description 1',
        price: 99.99,
        imageUrl: 'url1',
        category: 'electronics',
        stock: 10,
        createdAt: DateTime(2024, 1, 1),
      ),
      Product(
        id: '2',
        name: 'Product 2',
        description: 'Description 2',
        price: 49.99,
        imageUrl: 'url2',
        category: 'clothing',
        stock: 5,
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    test('execute returns list of products from repository', () async {
      // Arrange
      when(
        mockRepository.getProducts(limit: anyNamed('limit')),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, testProducts);
      verify(mockRepository.getProducts(limit: 20)).called(1);
    });

    test('execute passes limit parameter to repository', () async {
      // Arrange
      when(
        mockRepository.getProducts(limit: anyNamed('limit')),
      ).thenAnswer((_) async => testProducts);

      // Act
      await useCase.execute(limit: 10);

      // Assert
      verify(mockRepository.getProducts(limit: 10)).called(1);
    });

    test('execute returns empty list when repository returns empty', () async {
      // Arrange
      when(
        mockRepository.getProducts(limit: anyNamed('limit')),
      ).thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
    });

    test('execute throws exception when repository fails', () async {
      // Arrange
      when(
        mockRepository.getProducts(limit: anyNamed('limit')),
      ).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => useCase.execute(), throwsException);
    });

    test('execute can be called with function call syntax', () async {
      // Arrange
      when(
        mockRepository.getProducts(limit: anyNamed('limit')),
      ).thenAnswer((_) async => testProducts);

      // Act
      final result = await useCase(limit: 5);

      // Assert
      expect(result, testProducts);
      verify(mockRepository.getProducts(limit: 5)).called(1);
    });
  });
}
