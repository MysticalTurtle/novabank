import 'oauth_handler.dart';

class MockOAuthHandler implements OAuthHandler {
  @override
  Future<String> authenticate() async {
    // Simulate OAuth PKCE flow delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return a mock authorization token
    return 'mock_oauth_authorization_code_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<void> revokeSession() async {
    // Simulate session revocation delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real implementation, this would call the OAuth provider's revoke endpoint
    // For mock, we just simulate the action
  }
}
