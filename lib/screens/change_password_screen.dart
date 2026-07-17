import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/managers/api_serv.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title:  Text('common.error_title'.tr()),
          content: Text('change_password.mismatch_message'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  Text('common.ok'.tr()),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.changePassword(
        AuthManage.instance.userToken!,
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('change_password.success_message'.tr())),
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      if (error == 'google') {
        showDialog(
          context: context,
          builder: (error) => AlertDialog(
            title: Text('change_password.google_account_title'.tr()),
            content: Text('change_password.google_account_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('common.ok'.tr()),
              ),
            ],
          ),
        );
        return;
      } else if (error == 'somthing went wrong , please try again ') {
        showDialog(
          context: context,
          builder: (error) => AlertDialog(
            title: const Text('Error'),
            content: Text('change_password.wrong_current_message'.tr()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text('common.ok'.tr()),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_password.title'.tr())),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'change_password.current_password_required'.tr();
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'common.current_password_label'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                ),
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'common.new_password_label'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                ),
                controller: _newPasswordController,
                obscureText: _obscureNew,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'common.validators.password_required'.tr();
                  }
                  if (value.length < 8) {
                    return 'common.validators.password_min_length'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'common.confirm_your_password_label'.tr(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'common.validators.password_required'.tr();
                  }
                  if (value.length < 8) {
                    return 'common.validators.password_min_length'.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleChangePassword,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        :  Text('change_password.submit_button'.tr()),
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
