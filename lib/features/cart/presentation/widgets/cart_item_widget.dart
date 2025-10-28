import 'package:flutter/material.dart';
import 'package:ecom/features/cart/domain/entities/cart_item.dart';

/// Widget for displaying a single cart item with quantity controls.
///
/// Features:
/// - Product image, name, and price
/// - Quantity increment/decrement buttons
/// - Remove item button
/// - Stock status indicators
/// - Total price calculation
class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    item.product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Product price
                  Text(
                    item.product.formattedPrice,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Stock status
                  if (!item.isInStock)
                    Text(
                      'Out of Stock',
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  else if (item.product.isLowStock)
                    Text(
                      'Only ${item.product.stock} left',
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Quantity controls and total
                  Row(
                    children: [
                      // Quantity controls
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Decrement button
                            IconButton(
                              onPressed: item.canDecreaseQuantity
                                  ? () => onQuantityChanged(item.quantity - 1)
                                  : null,
                              icon: const Icon(Icons.remove),
                              iconSize: 18,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),

                            // Quantity display
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            // Increment button
                            IconButton(
                              onPressed: item.canIncreaseQuantity
                                  ? () => onQuantityChanged(item.quantity + 1)
                                  : null,
                              icon: const Icon(Icons.add),
                              iconSize: 18,
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Total price
                      Text(
                        item.formattedTotalPrice,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Remove button
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              color: Colors.red[400],
              tooltip: 'Remove item',
            ),
          ],
        ),
      ),
    );
  }
}
