import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product Entity', () {
    late Product testProduct;

    setUp(() {
      testProduct = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test description',
        price: 99.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'electronics',
        stock: 10,
        rating: 4.5,
        reviewCount: 100,
        isFavorite: false,
        createdAt: DateTime(2024, 1, 1),
      );
    });

    group('Stock Management', () {
      test('isInStock returns true when stock > 0', () {
        expect(testProduct.isInStock, true);
      });

      test('isInStock returns false when stock = 0', () {
        final outOfStockProduct = testProduct.copyWith(stock: 0);
        expect(outOfStockProduct.isInStock, false);
      });

      test('isLowStock returns true when stock <= 5 and > 0', () {
        final lowStockProduct = testProduct.copyWith(stock: 5);
        expect(lowStockProduct.isLowStock, true);
      });

      test('isLowStock returns false when stock > 5', () {
        expect(testProduct.isLowStock, false);
      });

      test('isLowStock returns false when stock = 0', () {
        final outOfStockProduct = testProduct.copyWith(stock: 0);
        expect(outOfStockProduct.isLowStock, false);
      });

      test('isOutOfStock returns true when stock = 0', () {
        final outOfStockProduct = testProduct.copyWith(stock: 0);
        expect(outOfStockProduct.isOutOfStock, true);
      });

      test('isOutOfStock returns false when stock > 0', () {
        expect(testProduct.isOutOfStock, false);
      });
    });

    group('Price Formatting', () {
      test('formattedPrice returns correctly formatted price', () {
        expect(testProduct.formattedPrice, '\$99.99');
      });

      test('formattedPrice handles whole numbers', () {
        final wholePrice = testProduct.copyWith(price: 100.0);
        expect(wholePrice.formattedPrice, '\$100.00');
      });

      test('formattedPrice handles decimal prices', () {
        final decimalPrice = testProduct.copyWith(price: 49.95);
        expect(decimalPrice.formattedPrice, '\$49.95');
      });
    });

    group('Stock Status', () {
      test('stockStatus returns "Out of Stock" when stock = 0', () {
        final outOfStock = testProduct.copyWith(stock: 0);
        expect(outOfStock.stockStatus, 'Out of Stock');
      });

      test('stockStatus returns low stock message when stock <= 5', () {
        final lowStock = testProduct.copyWith(stock: 3);
        expect(lowStock.stockStatus, 'Only 3 left');
      });

      test('stockStatus returns "In Stock" when stock > 5', () {
        expect(testProduct.stockStatus, 'In Stock');
      });
    });

    group('Ratings', () {
      test('hasRatings returns true when reviewCount > 0', () {
        expect(testProduct.hasRatings, true);
      });

      test('hasRatings returns false when reviewCount = 0', () {
        final noReviews = testProduct.copyWith(reviewCount: 0);
        expect(noReviews.hasRatings, false);
      });

      test('ratingText returns rating with count when reviews exist', () {
        expect(testProduct.ratingText, '4.5 (100)');
      });

      test('ratingText returns "No ratings" when no reviews', () {
        final noReviews = testProduct.copyWith(reviewCount: 0);
        expect(noReviews.ratingText, 'No ratings');
      });
    });

    group('JSON Serialization', () {
      test('toJson returns correct map', () {
        final json = testProduct.toJson();

        expect(json['id'], '1');
        expect(json['name'], 'Test Product');
        expect(json['description'], 'Test description');
        expect(json['price'], 99.99);
        expect(json['stock'], 10);
        expect(json['rating'], 4.5);
        expect(json['reviewCount'], 100);
      });

      test('fromJson creates correct Product', () {
        final json = {
          'id': '2',
          'name': 'Product 2',
          'description': 'Description 2',
          'price': 49.99,
          'imageUrl': 'https://example.com/image2.jpg',
          'category': 'clothing',
          'stock': 5,
          'rating': 4.0,
          'reviewCount': 50,
          'isFavorite': true,
          'createdAt': '2024-01-01T00:00:00.000',
        };

        final product = Product.fromJson(json);

        expect(product.id, '2');
        expect(product.name, 'Product 2');
        expect(product.price, 49.99);
        expect(product.stock, 5);
        expect(product.isFavorite, true);
      });
    });

    group('Equality', () {
      test('two products with same data are equal', () {
        final product1 = Product(
          id: '1',
          name: 'Product',
          description: 'Desc',
          price: 10.0,
          imageUrl: 'url',
          category: 'cat',
          stock: 5,
          createdAt: DateTime(2024, 1, 1),
        );

        final product2 = Product(
          id: '1',
          name: 'Product',
          description: 'Desc',
          price: 10.0,
          imageUrl: 'url',
          category: 'cat',
          stock: 5,
          createdAt: DateTime(2024, 1, 1),
        );

        expect(product1, product2);
      });

      test('two products with different data are not equal', () {
        final product1 = testProduct;
        final product2 = testProduct.copyWith(id: '2');

        expect(product1, isNot(product2));
      });
    });

    group('CopyWith', () {
      test('copyWith updates specified fields', () {
        final updated = testProduct.copyWith(
          name: 'Updated Product',
          price: 199.99,
        );

        expect(updated.name, 'Updated Product');
        expect(updated.price, 199.99);
        expect(updated.id, testProduct.id); // Unchanged
        expect(updated.stock, testProduct.stock); // Unchanged
      });

      test('copyWith can update isFavorite', () {
        expect(testProduct.isFavorite, false);

        final favorited = testProduct.copyWith(isFavorite: true);
        expect(favorited.isFavorite, true);
      });
    });
  });
}

