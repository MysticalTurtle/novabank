import 'package:novabank/data/models/models.dart';

/// Interface for local data persistence operations
abstract class LocalDataSource {
  /// Retrieves cached accounts from local storage
  Future<List<AccountModel>> getAccounts();

  /// Saves accounts to local storage
  Future<void> saveAccounts(List<AccountModel> accounts);

  /// Retrieves cached transactions for a specific account
  Future<List<TransactionModel>> getAccountTransactions(
    String accountId, {
    int? page,
  });

  /// Saves transactions for a specific account to local storage
  Future<void> saveAccountTransactions(
    String accountId,
    List<TransactionModel> transactions, {
    int? page,
  });

  /// Clears all cached data
  Future<void> clearAll();
}
