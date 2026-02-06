import 'package:novabank/core/utils/result.dart';
import 'package:novabank/data/models/models.dart';

/// Repository contract for Novabank features.
///
/// Implementations are expected to orchestrate remote calls via
/// `ApiDataSource` and caching via `LocalDataSource`.
abstract class NovabankRepository {
  /// Initiates OAuth PKCE flow via handler
  /// Returns authorization token/code
  Future<Result<String>> authenticateWithOAuth();

  /// Exchanges OAuth token for app tokens
  /// POST /auth/oidc/token
  Future<Result<TokenResponseModel>> login(String oAuthToken);

  /// Refreshes the access token using refresh_token
  /// POST /auth/oidc/token (grant_type: refresh_token)
  Future<Result<TokenResponseModel>> refreshToken(String refreshToken);

  /// Logs out and revokes session
  /// POST /auth/logout
  Future<Result<void>> logout();

  /// GET /accounts
  Future<Result<List<AccountModel>>> getAccounts();

  /// GET /accounts/{id}/transactions?page={page}
  Future<Result<List<TransactionModel>>> getAccountTransactions(
    String accountId, {
    int? page,
  });

  /// GET /beneficiaries
  Future<Result<List<BeneficiaryModel>>> getBeneficiaries();

  /// POST /transfers
  Future<Result<TransferResponseModel>> createTransfer(Map<String, dynamic> transferData);

  /// POST /transfers/{id}/confirm
  Future<Result<TransferResponseModel>> confirmTransfer(String transferId);

  /// PATCH /cards/{id}
  Future<Result<CardStatusResponseModel>> updateCardStatus(
    String cardId,
    String status,
  );

  /// Retrieves cached accounts from local storage
  Future<Result<List<AccountModel>>> getCachedAccounts();

  /// Saves accounts to local storage
  Future<Result<void>> saveAccounts(List<AccountModel> accounts);

  /// Retrieves cached transactions for a specific account
  Future<Result<List<TransactionModel>>> getCachedAccountTransactions(
    String accountId, {
    int? page,
  });

  /// Saves transactions for a specific account to local storage
  Future<Result<void>> saveAccountTransactions(
    String accountId,
    List<TransactionModel> transactions, {
    int? page,
  });

  /// Clears all cached data
  Future<Result<void>> clearCache();
}