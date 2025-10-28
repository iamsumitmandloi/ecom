import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';
import 'package:ecom/features/products/domain/usecases/get_product_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_by_id_use_case_test.mocks.dart';

@GenerateMocks([ProductsRepository])
void main() {
  late GetProductByIdUseCase useCase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    useCase = GetProductByIdUseCase(repository: mockRepository);
  });

  group('GetProductByIdUseCase', () {
    final testProduct = Product(
      id: '1',
      name: 'Test Product',
      description: 'Test description',
      price: 99.99,
      imageUrl: 'url',
      category: 'electronics',
      stock: 10,
      createdAt: DateTime(2024, 1, 1),
    );

    test('execute returns product from repository when found', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenAnswer((_) async => testProduct);

      // Act
      final result = await useCase.execute('1');

      // Assert
      expect(result, testProduct);
      verify(mockRepository.getProductById('1')).called(1);
    });

    test('execute passes correct product ID to repository', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenAnswer((_) async => testProduct);

      // Act
      await useCase.execute('product-123');

      // Assert
      verify(mockRepository.getProductById('product-123')).called(1);
    });

    test('execute throws ProductNotFoundException when product not found', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenThrow(const ProductNotFoundException('Product not found'));

      // Act & Assert
      expect(
        () => useCase.execute('999'),
        throwsA(isA<ProductNotFoundException>()),
      );
    });

    test('execute throws exception when repository fails', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute('1'),
        throwsException,
      );
    });

    test('execute validates product ID is not empty', () async {
      // Act & Assert
      expect(
        () => useCase.execute(''),
        throwsA(isA<InvalidProductIdException>()),
      );

      verifyNever(mockRepository.getProductById(any));
    });

    test('execute validates product ID is not just whitespace', () async {
      // Act & Assert
      expect(
        () => useCase.execute('   '),
        throwsA(isA<InvalidProductIdException>()),
      );

      verifyNever(mockRepository.getProductById(any));
    });

    test('execute trims product ID before passing to repository', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenAnswer((_) async => testProduct);

      // Act
      await useCase.execute('  product-123  ');

      // Assert
      verify(mockRepository.getProductById('product-123')).called(1);
    });

    test('execute can be called with function call syntax', () async {
      // Arrange
      when(mockRepository.getProductById(any))
          .thenAnswer((_) async => testProduct);

      // Act
      final result = await useCase('1');

      // Assert
      expect(result, testProduct);
      verify(mockRepository.getProductById('1')).called(1);
    });
  });
}

