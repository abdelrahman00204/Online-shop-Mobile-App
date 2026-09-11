import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/data/branch_data.dart';
import 'package:the_project/managers/api_serv.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/login_screen.dart';
import 'package:the_project/screens/user_data_screen.dart';
import 'package:the_project/managers/social_auth_service.dart';
import 'package:the_project/widgets/language_toggle_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  static String? selectedBranchId = branches.isNotEmpty
      ? branches.first.id.toString()
      : null;

  bool _obscurepass = true;
  bool _obscureConfirm = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'common.validators.email_required'.tr();
    final emailRegex = RegExp(r'^[\w.\-]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'common.validators.invalid_email'.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'common.validators.password_required'.tr();
    }
    if (value.length < 8) {
      return 'common.validators.password_min_length'.tr();
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'common.validators.password_uppercase'.tr();
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'common.validators.password_lowercase'.tr();
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=~`\[\]/;]').hasMatch(value)) {
      return 'common.validators.password_special_char'.tr();
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final favBranch = selectedBranchId ?? '';

    if (email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        favBranch.isEmpty) {
      _showDialog(
        'signup.missing_fields_title'.tr(),
        'signup.missing_fields_message'.tr(),
      );
      return;
    }

    if (password != confirm) {
      _showDialog(
        'signup.password_mismatch_title'.tr(),
        'signup.password_mismatch_message'.tr(),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Send to backend — backend creates the account
      await ApiService.registerWithEmail(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        favBranch: favBranch,
      );

      if (!mounted) return;
      // Backend said OK → go to UserDataScreen to collect remaining info
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on String catch (errorMessage) {
      _showDialog('signup.failed_title'.tr(), errorMessage);
    } catch (_) {
      _showDialog('signup.failed_title'.tr(), 'signup.failed_message'.tr());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignup() async {
    setState(() => _isLoading = true);
    try {
      final googleToken = await SocialAuthService.getGoogleToken();

      final data = await ApiService.loginWithGoogleProvider(googleToken);

      if (!mounted) return;

      if (data['requiresAdditionalInfo'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserDataScreen(token: googleToken, num: 1),
          ),
        );
      } else {
        await AuthManage.instance.login(
          data['email'],
          data['token'],
          data['firstName'],
          data['lastName'],
          data['preferredBranchId'],
          data['phoneNumber'],
          data['customerId'],
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } on String catch (errorMessage) {
      _showDialog('signup.failed_title'.tr(), errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /* Future<void> _handleFacebookSignup() async {
    setState(() => _isLoading = true);
    try {
      // Get real Facebook token
      final facebookToken = await SocialAuthService.getFacebookToken();

      final data = await ApiService.loginWithFacebookProvider(facebookToken);

      if (!mounted) return;

      if (data['requiresAdditionalInfo'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserDataScreen(token: facebookToken, num: 2),
          ),
        );
      } else {
        await AuthManage.instance.login(
          data['email'],
          data['token'],
          data['firstName'],
          data['lastName'],
          data['preferredBranchId'],
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } on String catch (errorCode) {
      if (errorCode != 'cancelled') {
        _showDialog('Error', 'Facebook signup failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
*/
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Al_ghoul_2.jpg', height: 80, width: 200),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'signup.title'.tr(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('signup.subtitle'.tr()),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'common.first_name_label'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'common.validators.first_name_required'
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'common.last_name_label'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'common.validators.last_name_required'
                                    .tr();
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: InputDecoration(
                        labelText: 'common.email_label'.tr(),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurepass,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'common.password_label'.tr(),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurepass
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _obscurepass = !_obscurepass),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'change_password.password_requirements_hint'.tr(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'common.confirm_password_label'.tr(),
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    TextFormField(
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
                      menuMaxHeight: 400,
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
                            color: const Color(
                              0xFF2E7D32,
                            ).withValues(alpha: 0.4),
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
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleSignup, // CHANGE 7: calls _handleSignup
                      child: Text('common.sign_up'.tr()),
                    ),
              const SizedBox(height: 20),
              Text(
                'common.or'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _isLoading ? null : _handleGoogleSignup,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Google__G__logo.svg.png', height: 24),
                    const SizedBox(width: 8),
                    Text('signup.google_button'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              /* OutlinedButton(
                onPressed: _isLoading ? null : _handleFacebookSignup,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Facebook_logo.png', height: 24),
                    const SizedBox(width: 8),
                    const Text('Sign Up with Facebook'),
                  ],
                ),
              ),*/
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'signup.have_account_prompt'.tr(),
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'common.login'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
