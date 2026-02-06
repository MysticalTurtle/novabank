/// Abstract OAuth handler for PKCE authentication flow
abstract class OAuthHandler {
  /// Initiates the OAuth PKCE flow and returns an authorization token/code
  Future<String> authenticate();

  /// Revokes the current session
  Future<void> revokeSession();
}
