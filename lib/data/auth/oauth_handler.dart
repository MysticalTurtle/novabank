abstract class OAuthHandler {
  Future<String> authenticate();

  Future<void> revokeSession();
}
