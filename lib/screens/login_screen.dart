import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_project/managers/api_serv.dart';
import 'package:the_project/managers/auth_manage.dart';
import 'package:the_project/screens/forgotpassword_screen.dart';
import 'package:the_project/screens/signup_screen.dart';
import 'package:the_project/screens/home_screen.dart';
import 'package:the_project/screens/user_data_screen.dart';
import 'package:the_project/managers/social_auth_service.dart';
import 'package:the_project/widgets/languageToggleButton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(
        'login.missing_fields_title'.tr(),
        'login.missing_fields_message'.tr(),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = await ApiService.loginWithEmail(
        email: email,
        password: password,
      );

      await AuthManage.instance.login(
        data['email'],
        data['token'],
        data['firstName'],
        data['lastName'],
        data['preferredBranchId'],
        data['phoneNumber'],
      );

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on String catch (errorCode) {
      if (errorCode == 'user_not_found') {
        _showSignupPromptDialog();
      } else if (errorCode == 'wrong_password') {
        _showDialog(
          'login.wrong_password_title'.tr(),
          'login.wrong_password_message'.tr(),
        );
      } else {
        _showDialog(
          'common.error_title'.tr(),
          'login.generic_error_message'.tr(),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
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
        return;
      } else {
        await AuthManage.instance.login(
          data['email'],
          data['token'],
          data['firstName'],
          data['lastName'],
          data['preferredBranchId'],
          data['phoneNumber'],
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } on String catch (errorCode) {
      if (errorCode != 'cancelled') {
        _showDialog(
          'login.google_failed_title'.tr(),
          'login.google_failed_message'.tr(),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /*  Future<void> _handleFacebookLogin() async {
    setState(() => _isLoading = true);
    try {
      final facebookToken = await SocialAuthService.getFacebookToken();

      final data = await ApiService.loginWithFacebookProvider(facebookToken);

      if (data['RequiresAdditionalInfo'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserDataScreen(token: facebookToken, num: 2),
          ),
        );
        return;
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
        _showDialog(
          'Facebook Login Failed',
          'Could not sign in with Facebook. Please try again.',
        );
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

  void _showSignupPromptDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('login.no_account_title'.tr()),
        content: Text('login.no_account_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog first
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: Text('common.sign_up'.tr()),
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
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LanguageToggleButton(
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
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Text(
                'login.title'.tr(),
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text('login.subtitle'.tr()),
              const SizedBox(height: 40),
              Text(
                'common.email_label'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'login.email_hint'.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'common.password'.tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'login.password_hint'.tr(),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: Text('login.forgot_password'.tr()),
                ),
              ),
              const SizedBox(height: 8),

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleLogin,
                      child: Text('common.login'.tr()),
                    ),
              const SizedBox(height: 20),
              Text(
                'common.or'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _isLoading ? null : _handleGoogleLogin,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Google__G__logo.svg.png', height: 24),
                    const SizedBox(width: 8),
                    Text('login.google_button'.tr()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              /* OutlinedButton(
                onPressed: _isLoading ? null : _handleFacebookLogin,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/Facebook_logo.png', height: 24),
                    const SizedBox(width: 8),
                    const Text('Login with Facebook'),
                  ],
                ),
              ),*/
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'login.no_account_prompt'.tr(),
                    style: const TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: 'common.sign_up'.tr(),
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
