import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocialAuthService {
  static final _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: dotenv.get('serverClientId'),
  );

  static Future<String> getGoogleToken() async {
    await _googleSignIn.signOut();

    final account = await _googleSignIn.signIn();

    if (account == null) {
      throw 'cancelled';
    }

    final auth = await account.authentication;

    final idToken = auth.idToken;

    if (idToken == null) {
      throw 'google_token_null';
    }

    return idToken; // return the raw JWT string
  }

  static Future<String> getFacebookToken() async {
    await FacebookAuth.instance.logOut();

    final result = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final token = result.accessToken?.tokenString;

      if (token == null) throw 'facebook_token_null';

      return token;
    } else if (result.status == LoginStatus.cancelled) {
      throw 'cancelled';
    } else {
      throw 'facebook_login_failed';
    }
  }
}
