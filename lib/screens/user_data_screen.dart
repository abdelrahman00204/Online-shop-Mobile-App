import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/branch_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/managers/api_serv.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key, required this.token, required this.num});

  final String token;
  final int num;
  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  static String? selectedBranchId = branches.isNotEmpty
      ? branches.first.id.toString()
      : null;
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text.trim();
      final favBranch = int.tryParse(selectedBranchId ?? '');

      setState(() => _isLoading = true);

      try {
        if (widget.num == 1) {
          final data = await ApiService.saveGoogleProfile(
            token: widget.token,
            preferredBranchId: favBranch!,
            phone: phone,
          );

          if (data['requiresAdditionalInfo'] == false) {
            await AuthManage.instance.login(
              data['email'],
              data['token'],
              data['firstName'],
              data['lastName'],
              data['preferredBranchId'],
              data['phoneNumber'],
              data['customerId'],
            );

            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('common.error_title'.tr()),
                content: Text('user_data.incomplete_message'.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('common.ok'.tr()),
                  ),
                ],
              ),
            );
          }
        } else if (widget.num == 2) {
          final data = await ApiService.saveFacebookProfile(
            token: widget.token,
            preferredBranchId: favBranch!,
            phone: phone,
          );

          if (data['requiresAdditionalInfo'] == false) {
            await AuthManage.instance.login(
              data['email'],
              data['token'],
              data['firstName'],
              data['lastName'],
              data['preferredBranchId'],
              data['phoneNumber'],
              data['customerId'],
            );

            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else {
            if (!mounted) return;
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('common.error_title'.tr()),
                content: Text('user_data.incomplete_message'.tr()),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('common.ok'.tr()),
                  ),
                ],
              ),
            );
          }
        }
      } catch (_) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('common.error_title'.tr()),
            content: Text('user_data.save_error_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('common.ok'.tr()),
              ),
            ],
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                const SizedBox(height: 16),

                const SizedBox(height: 16),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'common.phone_label'.tr(),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'common.validators.phone_required'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedBranchId,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF2E7D32),
                        width: 2,
                      ),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  iconEnabledColor: const Color(0xFF2E7D32),
                  style: const TextStyle(color: Colors.black87, fontSize: 15),
                  items: [
                    for (final branch in branches)
                      DropdownMenuItem(
                        value: branch.id.toString(),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.store_outlined,
                              color: Color(0xFF2E7D32),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(branch.name),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedBranchId = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue,
                            ),
                          ),
                        )
                      : Text('common.submit'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
