import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:the_project/data/orders_data.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderResponse order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isLoading = false;
  bool get _isBundleOrder {
    final sumOfSubtotals = widget.order.items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );
    // Small tolerance for floating-point rounding
    return (sumOfSubtotals - widget.order.totalPrice).abs() > 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${'orders.order_number'.tr()} #${widget.order.orderNumber}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${'orders.status'.tr()}: ${widget.order.status}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              widget.order.status.toLowerCase() == 'delivered'
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd – kk:mm',
                        ).format(widget.order.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text('${'orders.branch'.tr()}: ${widget.order.branchName}'),
                  const SizedBox(height: 8),
                  Text(
                    '${'orders.customer'.tr()}: ${widget.order.customerName}',
                  ),
                  if (widget.order.notes != null &&
                      widget.order.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text('${'orders.notes'.tr()}: ${widget.order.notes}'),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'orders.items_title'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Items List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.order.items.length,
            itemBuilder: (context, index) {
              final item = widget.order.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: item.productImage.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.productImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.shopping_bag),
                  title: Text(item.productName),
                  subtitle: Text(
                    '${'orders.quantity'.tr()}: ${item.quantity} ',
                  ),
                  trailing: _isBundleOrder
                      ? null
                      : Text('${item.subtotal.toStringAsFixed(2)} EGP'),
                ),
              );
            },
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'orders.total'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${widget.order.totalPrice.toStringAsFixed(2)} EGP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.order.status.toLowerCase() != 'delivered' &&
              widget.order.status.toLowerCase() != 'cancelled') ...{
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await cancelOrder(widget.order.id);
                        if (!mounted) return;
                        Navigator.popUntil(context, (route) => route.isFirst);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Order #${widget.order.orderNumber} has been cancelled.',
                            ),
                          ),
                        );
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Text(
                      'orders.cancel_order'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
          },
        ],
      ),
    );
  }
}
