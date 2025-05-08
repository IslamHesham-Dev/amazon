import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import 'order_confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _giftRecipientController = TextEditingController();
  final _giftMessageController = TextEditingController();

  String _selectedPaymentMethod = 'Credit Card';
  bool _isProcessing = false;
  bool _isGift = false;
  bool _giftWrapped = false;

  final List<String> _paymentMethods = [
    'Credit Card',
    'PayPal',
    'Amazon Pay',
    'Cash on Delivery'
  ];

  @override
  void dispose() {
    _addressController.dispose();
    _giftRecipientController.dispose();
    _giftMessageController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // Get cart items and total price
      final cartItems = cartProvider.items;
      final totalAmount = cartProvider.totalPrice + (_giftWrapped ? 4.99 : 0);

      // Place order
      final order = await orderProvider.placeOrder(
        cartItems,
        totalAmount,
        _addressController.text.trim(),
        _selectedPaymentMethod,
        isGift: _isGift,
        giftRecipientName:
            _isGift ? _giftRecipientController.text.trim() : null,
        giftMessage: _isGift ? _giftMessageController.text.trim() : null,
        giftWrapped: _giftWrapped,
      );

      if (order != null && mounted) {
        // Clear cart after successful order
        cartProvider.clearCart();

        // Navigate to order confirmation page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationPage(order: order),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;
    final double subtotal = cartProvider.totalPrice;
    final double giftWrapPrice = _giftWrapped ? 4.99 : 0;
    final double totalAmount = subtotal + giftWrapPrice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFF232F3E),
        foregroundColor: Colors.white,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty'),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Order summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Items list
                          ...cartItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        item.product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text('${item.quantity}x'),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '\$${item.total.toStringAsFixed(2)}',
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              )),

                          const Divider(),

                          // Subtotal
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Subtotal:',
                                ),
                              ),
                              Text(
                                '\$${subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Gift wrap fee if applied
                          if (_giftWrapped) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Gift Wrap:',
                                  ),
                                ),
                                Text(
                                  '\$${giftWrapPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 8),
                          const Divider(),

                          // Total
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFB12704),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Shipping address
                  const Text(
                    'Shipping Address',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your full address',
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your shipping address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Gift Options
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Buy as a Gift',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: _isGift,
                                onChanged: (value) {
                                  setState(() {
                                    _isGift = value;
                                  });
                                },
                                activeColor: const Color(0xFFF7CA00),
                              ),
                            ],
                          ),
                          if (_isGift) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _giftRecipientController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Recipient Name',
                                hintText: 'Enter recipient\'s name',
                              ),
                              validator: (value) {
                                if (_isGift &&
                                    (value == null || value.isEmpty)) {
                                  return 'Please enter recipient\'s name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _giftMessageController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Gift Message',
                                hintText: 'Enter optional gift message',
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Gift Wrapping',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Add gift wrap for \$4.99',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _giftWrapped,
                                  onChanged: (value) {
                                    setState(() {
                                      _giftWrapped = value;
                                    });
                                  },
                                  activeColor: const Color(0xFFF7CA00),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Payment method
                  const Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPaymentMethod = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Place order button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7CA00),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator()
                          : Text(
                              _isGift ? 'Buy as Gift' : 'Place Order',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
