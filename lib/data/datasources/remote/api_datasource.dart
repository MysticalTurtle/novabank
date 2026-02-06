import 'package:novabank/data/models/models.dart';
// import 'oauth_handler.dart';

abstract class ApiDataSource {
  ApiDataSource();

  Future<TokenResponseModel> login(String oAuthToken);

  Future<TokenResponseModel> refreshToken(String refreshToken);

  Future<void> logout();

  Future<List<AccountModel>> getAccounts();

  Future<List<TransactionModel>> getAccountTransactions(
    String accountId, {
    int? page,
  });

  Future<List<BeneficiaryModel>> getBeneficiaries();

  Future<TransferResponseModel> createTransfer(
    String beneficiaryId, double amount,
  );

  Future<TransferResponseModel> confirmTransfer(String transferId);

  Future<CardStatusResponseModel> updateCardStatus(
    String cardId,
    String status,
  );
}
