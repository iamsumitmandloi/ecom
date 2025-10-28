import 'package:flutter/material.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';

/// Widget displaying cart summary with pricing breakdown and checkout button.
///
/// Features:
/// - Subtotal, tax, shipping calculations
/// - Free shipping threshold indicator
/// - Total price display
/// - Checkout button
/// - Promotional messages
class CartSummaryWidget extends StatelessWidget {
  final Cart cart;

  const CartSummaryWidget({required this.cart, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Free shipping indicator
            if (!cart.qualifiesForFreeShipping)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cart.formattedAmountNeededForFreeShipping,
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Price breakdown
            _buildPriceRow(context, 'Subtotal', cart.formattedSubtotal),

            _buildPriceRow(context, 'Tax (8.5%)', cart.formattedTaxAmount),

            _buildPriceRow(
              context,
              'Shipping',
              cart.formattedShippingCost,
              isShipping: true,
            ),

            const Divider(),

            _buildPriceRow(
              context,
              'Total',
              cart.formattedFinalTotal,
              isTotal: true,
            ),

            const SizedBox(height: 16),

            // Checkout button
            ElevatedButton(
              onPressed: cart.hasValidationErrors
                  ? null
                  : () {
                      _showCheckoutDialog(context);
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                cart.hasValidationErrors
                    ? 'Fix Cart Issues'
                    : 'Proceed to Checkout',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Validation errors
            if (cart.hasValidationErrors) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[600], size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Please fix the following issues:',
                          style: TextStyle(
                            color: Colors.red[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...cart.validationErrors.map(
                      (error) => Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 4),
                        child: Text(
                          '• $error',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String value, {
    bool isShipping = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isShipping && cart.qualifiesForFreeShipping
                  ? Colors.green[600]
                  : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? Theme.of(context).primaryColor
                  : isShipping && cart.qualifiesForFreeShipping
                  ? Colors.green[600]
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout'),
        content: const Text(
          'Checkout functionality will be implemented in Phase 4 (Orders). '
          'For now, this is a demo of the cart calculation system.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
