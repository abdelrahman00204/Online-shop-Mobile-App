import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_project/data/cart_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/managers/manage_orders.dart';
import 'package:the_project/screens/login_screen.dart';
import 'package:the_project/widgets/branch_filter.dart';
import 'package:the_project/widgets/confirmation_dialog.dart';

Future<void> showCheckoutDialog(
  BuildContext context, {
  int? offerId,
  required double amountToPay,
}) {
  if (AuthManage.instance.isLoggedIn) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) =>
          CheckoutDialog(offerId: offerId, amountToPay: amountToPay),
    );
  }

  return showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (dialogContext) => AlertDialog(
      title: const Text('Login Required'),
      content: const Text('Please log in to proceed with checkout.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final navigator = Navigator.of(context);
            Navigator.of(dialogContext).pop(); // Close dialog first
            navigator.push(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
          child: const Text('Login'),
        ),
      ],
    ),
  );
}

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key, this.offerId, required double amountToPay})
    : _amountToPay = amountToPay;
  final int? offerId;
  final double _amountToPay;

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  bool _isloading = false;

  int? branchId = AuthManage.instance.userFavBranch;

  @override
  void initState() {
    super.initState();
    _fullNameController.text =
        AuthManage.instance.userFirstName! +
        (AuthManage.instance.userLastName ?? '');
    _mobileController.text = AuthManage.instance.userPhone ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  void _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isloading = true);
      final response = await ManageOrders().makeOrder(
        branchId!,
        widget.offerId,
      );

      cartdata.clear();
      await CartService.clearCart();

      if (!mounted) return;
      Navigator.of(context).pop();

      ConfirmationDialog.show(context, order: response);
    } catch (e) {
      debugPrint('makeOrder exception: $e  , $branchId');
      if (!mounted) return;

      final rawMessage = e.toString().replaceFirst('Exception: ', '');

      // Strip invisible bidi/zero-width chars before matching
      final cleaned = rawMessage.replaceAll(
        RegExp(r'[\u200B\u200C\u200D\u200E\u200F]'),
        '',
      );
      debugPrint(rawMessage.codeUnits.toString());
      final message = cleaned.contains('مش متاح')
          ? 'Out of stock in this branch'
          : rawMessage;

      // Capture messenger BEFORE popping, so it isn't tied to a dying context
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  // void _showErrorSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message), backgroundColor: Colors.red),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final amountToPay = widget._amountToPay;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Checkout',
                    style: GoogleFonts.lalezar(
                      fontSize: 26,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                readOnly: true,

                controller: _fullNameController,
                validator: (v) => _required(v, 'Name'),
                decoration: InputDecoration(label: Text('Name')),
              ),
              const SizedBox(height: 18),
              TextFormField(
                readOnly: true,

                decoration: InputDecoration(label: Text('Mobile Number')),
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                validator: (v) => _required(v, 'Mobile Number'),
              ),
              const SizedBox(height: 18),
              BranchFilter(onChanged: (id) => setState(() => branchId = id)),
              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Amount to pay',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '$amountToPay EGP',
                    style: GoogleFonts.lalezar(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _isloading
                  ? Center(child: CircularProgressIndicator())
                  : OutlinedButton(
                      onPressed: _confirmOrder,
                      child: Text('Confirm Order'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
