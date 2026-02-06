// import 'package:dio/dio.dart';
import 'package:novabank/data/models/models.dart';
// import 'oauth_handler.dart';

abstract class ApiDataSource {
  // final Dio client;

  ApiDataSource(
    // required this.client,
  );

  /// Exchanges OAuth token for app tokens
  /// POST /auth/oidc/token
  Future<TokenResponseModel> login(String oAuthToken);

  /// Refreshes the access token using refresh_token
  /// POST /auth/oidc/token (grant_type: refresh_token)
  Future<TokenResponseModel> refreshToken(String refreshToken);

  /// Logs out and revokes session
  /// POST /auth/logout
  Future<void> logout();

  /// GET /accounts
  Future<List<AccountModel>> getAccounts();

  /// GET /accounts/{id}/transactions?page={page}
  Future<List<TransactionModel>> getAccountTransactions(
    String accountId, {
    int? page,
  });

  /// GET /beneficiaries
  Future<List<BeneficiaryModel>> getBeneficiaries();

  /// POST /transfers
  Future<TransferResponseModel> createTransfer(Map<String, dynamic> transferData);

  /// POST /transfers/{id}/confirm
  Future<TransferResponseModel> confirmTransfer(String transferId);

  /// PATCH /cards/{id}
  Future<CardStatusResponseModel> updateCardStatus(
    String cardId,
    String status,
  );
}
