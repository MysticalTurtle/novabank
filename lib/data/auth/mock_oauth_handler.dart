import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'oauth_handler.dart';

/// Mock implementation of OAuth2 + PKCE flow for testing/development
class MockOAuthHandler implements OAuthHandler {
  String? _codeVerifier;
  String? _codeChallenge;

  @override
  Future<String> authenticate() async {
    _codeVerifier = _generateCodeVerifier();
    _codeChallenge = _generateCodeChallenge(_codeVerifier!);

    final code = await _getCode(_codeVerifier!);
    return code;
  }

  @override
  Future<void> revokeSession() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _codeVerifier = null;
    _codeChallenge = null;
  }

  String _generateCodeVerifier() {
    return _generateRandomString(64);
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  String _generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Simulates backend PKCE verification
  /// Verifies that the provided code_verifier matches the stored code_challenge
  Future<String> _getCode(String providedCodeVerifier) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final expectedChallenge = _generateCodeChallenge(providedCodeVerifier);
    if (expectedChallenge == _codeChallenge) {
      return 'mock_valid_code_${_generateRandomString(16)}';
    } else {
      throw Exception('PKCE verification failed: invalid code verifier');
    }
  }
}
