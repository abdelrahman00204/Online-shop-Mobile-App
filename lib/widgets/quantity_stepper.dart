import 'package:flutter/material.dart';

class QuantityStepper extends StatefulWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });
  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  late int _quantity = widget.quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(
            icon: Icons.remove,
            onTap: _quantity > 1
                ? () => setState(() {
                    _quantity--;
                    widget.onChanged(_quantity);
                  })
                : null,
          ),
          Container(
            width: 48,
            alignment: Alignment.center,
            child: Text(
              '$_quantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),

          _buildButton(
            icon: Icons.add,
            onTap: () => setState(() {
              _quantity++;
              widget.onChanged(_quantity);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required IconData icon, required VoidCallback? onTap}) {
    final isDisabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 20,
          color: isDisabled ? const Color(0xFFCCCCCC) : const Color(0xFF333333),
        ),
      ),
    );
  }
}
