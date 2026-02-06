import 'package:novabank/core/utils/result.dart';
import 'package:novabank/data/models/models.dart';

abstract class NovabankRepository {
  /// On success it sets the token and refresh token in the ApiClient, on failure it returns the error
  Future<Result<void>> login();

  Future<Result<void>> logout();

  Future<bool> checkIsLoggedIn();

  Future<Result<List<AccountModel>>> getAccounts();

  Future<Result<PaginatedTransactionsResponse>> getAccountTransactions(
    String accountId, {
    int? page,
  });

  Future<Result<List<BeneficiaryModel>>> getBeneficiaries();

  Future<Result<TransferResponseModel>> createTransfer({
    required String id,
    required double amount,
  });

  Future<Result<TransferResponseModel>> confirmTransfer(String transferId);

  Future<Result<CardStatusResponseModel>> updateCardStatus({
    required String cardId,
    required String status,
  });

  Future<Result<void>> saveAccounts(List<AccountModel> accounts);

  Future<Result<void>> clearCache();
}
