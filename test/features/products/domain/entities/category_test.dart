import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Category Entity', () {
    late Category testCategory;

    setUp(() {
      testCategory = const Category(
        id: 'electronics',
        name: 'Electronics',
        description: 'Electronic devices and gadgets',
        imageUrl: 'https://example.com/electronics.jpg',
        productCount: 150,
      );
    });

    group('Properties', () {
      test('category has correct properties', () {
        expect(testCategory.id, 'electronics');
        expect(testCategory.name, 'Electronics');
        expect(testCategory.description, 'Electronic devices and gadgets');
        expect(testCategory.imageUrl, 'https://example.com/electronics.jpg');
        expect(testCategory.productCount, 150);
      });

      test('category can be created with minimal data', () {
        const minimalCategory = Category(
          id: 'test',
          name: 'Test Category',
        );

        expect(minimalCategory.id, 'test');
        expect(minimalCategory.name, 'Test Category');
        expect(minimalCategory.description, isNull);
        expect(minimalCategory.imageUrl, isNull);
        expect(minimalCategory.productCount, 0);
      });
    });

    group('Helper Methods', () {
      test('hasProducts returns true when productCount > 0', () {
        expect(testCategory.hasProducts, true);
      });

      test('hasProducts returns false when productCount = 0', () {
        final emptyCategory = testCategory.copyWith(productCount: 0);
        expect(emptyCategory.hasProducts, false);
      });

      test('displayName returns name in proper case', () {
        expect(testCategory.displayName, 'Electronics');
      });

      test('displayName handles lowercase names', () {
        final lowercase = testCategory.copyWith(name: 'electronics');
        expect(lowercase.displayName, 'Electronics');
      });

      test('displayName handles uppercase names', () {
        final uppercase = testCategory.copyWith(name: 'ELECTRONICS');
        expect(uppercase.displayName, 'Electronics');
      });

      test('displayName handles multi-word names', () {
        final multiWord = testCategory.copyWith(name: 'home and garden');
        expect(multiWord.displayName, 'Home And Garden');
      });
    });

    group('JSON Serialization', () {
      test('toJson returns correct map', () {
        final json = testCategory.toJson();

        expect(json['id'], 'electronics');
        expect(json['name'], 'Electronics');
        expect(json['description'], 'Electronic devices and gadgets');
        expect(json['imageUrl'], 'https://example.com/electronics.jpg');
        expect(json['productCount'], 150);
      });

      test('fromJson creates correct Category', () {
        final json = {
          'id': 'clothing',
          'name': 'Clothing',
          'description': 'Fashion and apparel',
          'imageUrl': 'https://example.com/clothing.jpg',
          'productCount': 200,
        };

        final category = Category.fromJson(json);

        expect(category.id, 'clothing');
        expect(category.name, 'Clothing');
        expect(category.description, 'Fashion and apparel');
        expect(category.productCount, 200);
      });

      test('fromJson handles missing optional fields', () {
        final json = {
          'id': 'test',
          'name': 'Test',
        };

        final category = Category.fromJson(json);

        expect(category.id, 'test');
        expect(category.name, 'Test');
        expect(category.description, isNull);
        expect(category.imageUrl, isNull);
        expect(category.productCount, 0);
      });
    });

    group('Equality', () {
      test('two categories with same data are equal', () {
        const category1 = Category(
          id: 'test',
          name: 'Test',
          description: 'Desc',
          productCount: 10,
        );

        const category2 = Category(
          id: 'test',
          name: 'Test',
          description: 'Desc',
          productCount: 10,
        );

        expect(category1, category2);
      });

      test('two categories with different data are not equal', () {
        const category1 = Category(id: '1', name: 'Category 1');
        const category2 = Category(id: '2', name: 'Category 2');

        expect(category1, isNot(category2));
      });
    });

    group('CopyWith', () {
      test('copyWith updates specified fields', () {
        final updated = testCategory.copyWith(
          name: 'Updated Electronics',
          productCount: 200,
        );

        expect(updated.name, 'Updated Electronics');
        expect(updated.productCount, 200);
        expect(updated.id, testCategory.id); // Unchanged
        expect(updated.description, testCategory.description); // Unchanged
      });

      test('copyWith can clear optional fields', () {
        final cleared = testCategory.copyWith(
          description: null,
          imageUrl: null,
        );

        expect(cleared.description, isNull);
        expect(cleared.imageUrl, isNull);
        expect(cleared.id, testCategory.id);
        expect(cleared.name, testCategory.name);
      });
    });
  });
}

