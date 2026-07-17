import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/branch_data.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/managers/api_serv.dart';
import 'package:the_project/screens/change_password_screen.dart';
import 'package:the_project/widgets/languageToggleButton.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  static String? selectedBranchId = AuthManage.instance.userFavBranch
      ?.toString();

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.text = AuthManage.instance.userFirstName ?? '';
    _lastNameController.text = AuthManage.instance.userLastName ?? '';
    _phoneController.text = AuthManage.instance.userPhone ?? '';
    _emailController.text = AuthManage.instance.userEmail ?? '';
    selectedBranchId = AuthManage.instance.userFavBranch?.toString() ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleEditPressed() async {
    if (_isEditing) {
      if (!_formKey.currentState!.validate()) return;

      setState(() => _isSaving = true);
      try {
        await ApiService.updateUserProfile(
          token: AuthManage.instance.userToken ?? '',
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phone: _phoneController.text.trim(),
          preferredBranchId: int.tryParse(selectedBranchId ?? ''),
        );

        if (!mounted) return;
        setState(() => _isEditing = false);
      } catch (_) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('common.error_title'.tr()),
            content: Text('profile.update_error_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('common.ok'.tr()),
              ),
            ],
          ),
        );
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    } else {
      // Switch into edit mode
      setState(() => _isEditing = true);
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    if (_isEditing) {
      return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'common.validators.field_required'.tr(args: [label]);
          }
          return null;
        },
      );
    } else {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                controller.text.isEmpty ? '-' : controller.text,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.title'.tr()),
        actions: [
          LanguageToggleButton(
            onLanguageChanged: (isArabic) {
              if (isArabic) {
                context.setLocale(const Locale('ar'));
                setState(() {});
              } else {
                context.setLocale(const Locale('en'));
                setState(() {});
              }
            },
          ),
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: Icon(_isEditing ? Icons.check : Icons.edit),
                  onPressed: _handleEditPressed,
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'common.email_label'.tr(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        AuthManage.instance.userEmail ?? '-',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              _buildField(
                label: 'common.first_name_label'.tr(),
                controller: _firstNameController,
              ),
              const SizedBox(height: 12),
              _buildField(
                label: 'common.last_name_label'.tr(),
                controller: _lastNameController,
              ),
              const SizedBox(height: 12),
              _buildField(
                label: 'common.phone_label'.tr(),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _isEditing
                  ? DropdownButtonFormField<String>(
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
                            color: const Color(0xFF2E7D32).withOpacity(0.4),
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
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                      ),
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
                    )
                  : Text(
                      'profile.favorite_branch_label'.tr(
                        args: [
                          branches
                              .firstWhere(
                                (branch) =>
                                    branch.id.toString() == selectedBranchId,
                              )
                              .name,
                        ],
                      ),
                      style: const TextStyle(fontSize: 18),
                    ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isEditing
                      ? const SizedBox.shrink()
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ChangePasswordScreen(),
                              ),
                            );
                          },
                          child: Text('profile.change_password_button'.tr()),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
