import 'package:dio/dio.dart';
import 'package:novabank/data/models/models.dart';
import 'api_datasource.dart';

class MockApiDataSource implements ApiDataSource {
  final Dio client;

  MockApiDataSource({required this.client});

  @override
  Future<TokenResponseModel> login(String oAuthToken) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return TokenResponseModel(
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<TokenResponseModel> refreshToken(String refreshToken) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return TokenResponseModel(
      accessToken:
          'mock_refreshed_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken:
          'mock_refreshed_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    // No return value for logout
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      AccountModel(
        id: 'acc_001',
        alias: 'Cuenta corriente',
        currency: 'PEN',
        availableBalance: 15420.50,
        ledgerBalance: 15420.50,
      ),
      AccountModel(
        id: 'acc_002',
        alias: 'Cuenta de ahorros',
        currency: 'PEN',
        availableBalance: 48950.75,
        ledgerBalance: 48950.75,
      ),
      AccountModel(
        id: 'acc_003',
        alias: 'Inversiones',
        currency: 'USD',
        availableBalance: 125000.00,
        ledgerBalance: 125000.00,
      ),
    ];
  }

  @override
  Future<List<TransactionModel>> getAccountTransactions(
    String accountId, {
    int? page,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    final now = DateTime.now();
    final pageOffset = (page ?? 1) - 1;

    return [
      TransactionModel(
        id: 'txn_${pageOffset * 10 + 1}',
        date: now
            .subtract(Duration(days: pageOffset * 10 + 1))
            .toIso8601String(),
        amount: -45.99,
        description: 'Coffee Shop',
        type: 'debit',
      ),
      TransactionModel(
        id: 'txn_${pageOffset * 10 + 2}',
        date: now
            .subtract(Duration(days: pageOffset * 10 + 2))
            .toIso8601String(),
        amount: 2500.00,
        description: 'Salary Deposit',
        type: 'credit',
      ),
      TransactionModel(
        id: 'txn_${pageOffset * 10 + 3}',
        date: now
            .subtract(Duration(days: pageOffset * 10 + 3))
            .toIso8601String(),
        amount: -120.50,
        description: 'Grocery Store',
        type: 'debit',
      ),
      TransactionModel(
        id: 'txn_${pageOffset * 10 + 4}',
        date: now
            .subtract(Duration(days: pageOffset * 10 + 5))
            .toIso8601String(),
        amount: -89.99,
        description: 'Online Shopping',
        type: 'debit',
      ),
      TransactionModel(
        id: 'txn_${pageOffset * 10 + 5}',
        date: now
            .subtract(Duration(days: pageOffset * 10 + 7))
            .toIso8601String(),
        amount: 150.00,
        description: 'Refund',
        type: 'credit',
      ),
    ];
  }

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      BeneficiaryModel(
        id: 'ben_001',
        name: 'John Doe',
        accountNumber: '****1234',
      ),
      BeneficiaryModel(
        id: 'ben_002',
        name: 'Jane Smith',
        accountNumber: '****5678',
      ),
      BeneficiaryModel(
        id: 'ben_003',
        name: 'Mike Johnson',
        accountNumber: '****9012',
      ),
    ];
  }

  @override
  Future<TransferResponseModel> createTransfer(
    String beneficiaryId,
    double amount,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return TransferResponseModel(
      id: 'transfer_${DateTime.now().millisecondsSinceEpoch}',
      status: 'pending',
    );
  }

  @override
  Future<TransferResponseModel> confirmTransfer(String transferId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return TransferResponseModel(id: transferId, status: 'completed');
  }

  @override
  Future<CardStatusResponseModel> updateCardStatus(
    String cardId,
    String status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return CardStatusResponseModel(status: status);
  }
}
