import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_project/dummy_data.dart';
import 'package:the_project/screens/item_screen.dart';
import 'package:the_project/widgets/quantity_stepper.dart';

class Helpers {
  final int index1;
  int quantity;

  Helpers({required this.index1, required this.quantity});
}

List<Helpers> cartdata = [];

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.index, required this.onRemove});
  final int index;
  final VoidCallback onRemove;
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  void _removeItem() {
    cartdata.removeAt(widget.index);
    widget.onRemove();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index >= cartdata.length) {
      return const SizedBox.shrink();
    }
    final product = dummyProducts[cartdata[widget.index].index1];
    final double subtotal = product.price * cartdata[widget.index].quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ItemScreen(product: dummyProducts[widget.index]),
                  ),
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        height: 90,
                        width: 90,
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(
                          Icons.image,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 16),

            // Price
            Row(
              children: [
                _label('Price:'),
                const SizedBox(width: 4),
                _value(
                  '${product.price}  EGP ',
                  color: const Color(0xFF1A73E8),
                  size: 22,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 16),

            // Quantity
            Row(
              children: [
                _label('Quantity:'),
                const SizedBox(width: 10),
                QuantityStepper(
                  quantity: cartdata[widget.index].quantity,
                  onChanged: (newQuantity) {
                    setState(() {
                      cartdata[widget.index].quantity = newQuantity;
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                  onPressed: _removeItem,
                  icon: const Icon(Icons.delete, size: 22, color: Colors.black),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE0E0E0)),
            const SizedBox(height: 16),

            // Subtotal
            Row(
              children: [
                _label('Subtotal:'),
                const SizedBox(width: 4),
                _value(
                  '${subtotal.toString()} EGP',
                  color: const Color(0xFF1A73E8),
                  size: 22,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF888888),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _value(String text, {required Color color, double size = 16}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
