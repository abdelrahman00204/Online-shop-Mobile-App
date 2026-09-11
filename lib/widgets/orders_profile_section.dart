import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/orders_data.dart';
import 'package:the_project/screens/order_detail_screen.dart';

class BuildOrdersSection extends StatefulWidget {
  final Future<List<OrderResponse>> ordersFuture;

  const BuildOrdersSection({required this.ordersFuture, super.key});

  @override
  State<BuildOrdersSection> createState() => _BuildOrdersSectionState();
}

class _BuildOrdersSectionState extends State<BuildOrdersSection> {
  int _visibleOrderCount = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'profile.recent_orders'.tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<OrderResponse>>(
          future: widget.ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('profile.orders_error'.tr());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('profile.no_orders'.tr());
            }

            final orders = snapshot.data!;
            final displayedCount = orders.length > _visibleOrderCount
                ? _visibleOrderCount
                : orders.length;

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedCount,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          '${'orders.order_number'.tr()} #${order.orderNumber}',
                        ),
                        subtitle: Text(
                          '${order.branchName} • ${DateFormat('yyyy-MM-dd').format(order.createdAt)}',
                        ),
                        trailing: Text(
                          'EGP ${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                if (orders.length > _visibleOrderCount)
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _visibleOrderCount += 3;
                        });
                      },
                      child: Text('item.view_more_orders'.tr()),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
