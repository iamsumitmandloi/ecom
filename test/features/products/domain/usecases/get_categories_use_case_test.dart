import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';
import 'package:ecom/features/products/domain/usecases/get_categories_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_categories_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late GetCategoriesUseCase useCase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = GetCategoriesUseCase(repository: mockRepository);
  });

  group('GetCategoriesUseCase', () {
    final testCategories = [
      const Category(
        id: 'electronics',
        name: 'Electronics',
        description: 'Electronic devices',
        productCount: 150,
      ),
      const Category(
        id: 'clothing',
        name: 'Clothing',
        description: 'Fashion apparel',
        productCount: 200,
      ),
      const Category(
        id: 'books',
        name: 'Books',
        description: 'Books and magazines',
        productCount: 500,
      ),
    ];

    test('execute returns list of categories from repository', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenAnswer((_) async => testCategories);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, testCategories);
      verify(mockRepository.getCategories()).called(1);
    });

    test('execute returns empty list when no categories exist', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
    });

    test('execute throws exception when repository fails', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsException,
      );
    });

    test('execute can be called multiple times', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenAnswer((_) async => testCategories);

      // Act
      await useCase.execute();
      await useCase.execute();

      // Assert
      verify(mockRepository.getCategories()).called(2);
    });

    test('execute can be called with function call syntax', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenAnswer((_) async => testCategories);

      // Act
      final result = await useCase();

      // Assert
      expect(result, testCategories);
      verify(mockRepository.getCategories()).called(1);
    });

    test('execute returns categories in order from repository', () async {
      // Arrange
      when(mockRepository.getCategories())
          .thenAnswer((_) async => testCategories);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result[0].id, 'electronics');
      expect(result[1].id, 'clothing');
      expect(result[2].id, 'books');
    });

    test('execute handles categories with minimal data', () async {
      // Arrange
      final minimalCategories = [
        const Category(id: 'test1', name: 'Test 1'),
        const Category(id: 'test2', name: 'Test 2'),
      ];

      when(mockRepository.getCategories())
          .thenAnswer((_) async => minimalCategories);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.length, 2);
      expect(result[0].id, 'test1');
      expect(result[1].id, 'test2');
    });
  });
}

