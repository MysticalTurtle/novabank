import 'package:novabank/data/models/models.dart';
import 'api_datasource.dart';

class MockApiDataSource implements ApiDataSource {
  MockApiDataSource();

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
    await Future.delayed(const Duration(milliseconds: 300));
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
  Future<PaginatedTransactionsResponse> getAccountTransactions(
    String accountId, {
    int? page,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));

    final currentPage = page ?? 1;
    
    // Only 2 pages available
    if (currentPage > 2) {
      return PaginatedTransactionsResponse(transactions: [], hasMore: false);
    }

    final now = DateTime.now();

    if (currentPage == 1) {
      // Page 1: 7 transactions
      return PaginatedTransactionsResponse(
        hasMore: true,
        transactions: [
        TransactionModel(
          id: 'txn_1',
          date: now.subtract(const Duration(days: 1)).toIso8601String(),
          amount: -45.99,
          description: 'Coffee Shop',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_2',
          date: now.subtract(const Duration(days: 2)).toIso8601String(),
          amount: 2500.00,
          description: 'Salary Deposit',
          type: 'credit',
        ),
        TransactionModel(
          id: 'txn_3',
          date: now.subtract(const Duration(days: 3)).toIso8601String(),
          amount: -120.50,
          description: 'Grocery Store',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_4',
          date: now.subtract(const Duration(days: 4)).toIso8601String(),
          amount: -89.99,
          description: 'Online Shopping',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_5',
          date: now.subtract(const Duration(days: 5)).toIso8601String(),
          amount: 150.00,
          description: 'Refund',
          type: 'credit',
        ),
        TransactionModel(
          id: 'txn_6',
          date: now.subtract(const Duration(days: 6)).toIso8601String(),
          amount: -35.00,
          description: 'Restaurant',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_7',
          date: now.subtract(const Duration(days: 7)).toIso8601String(),
          amount: -250.00,
          description: 'Electricity Bill',
          type: 'debit',
        ),
      ]);
    } else {
      // Page 2: 6 transactions (total 13)
      return PaginatedTransactionsResponse(
        hasMore: false,
        transactions: [
        TransactionModel(
          id: 'txn_8',
          date: now.subtract(const Duration(days: 8)).toIso8601String(),
          amount: -15.99,
          description: 'Streaming Service',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_9',
          date: now.subtract(const Duration(days: 9)).toIso8601String(),
          amount: 500.00,
          description: 'Transfer Received',
          type: 'credit',
        ),
        TransactionModel(
          id: 'txn_10',
          date: now.subtract(const Duration(days: 10)).toIso8601String(),
          amount: -78.50,
          description: 'Gas Station',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_11',
          date: now.subtract(const Duration(days: 11)).toIso8601String(),
          amount: -200.00,
          description: 'Insurance Payment',
          type: 'debit',
        ),
        TransactionModel(
          id: 'txn_12',
          date: now.subtract(const Duration(days: 12)).toIso8601String(),
          amount: 1000.00,
          description: 'Freelance Payment',
          type: 'credit',
        ),
        TransactionModel(
          id: 'txn_13',
          date: now.subtract(const Duration(days: 13)).toIso8601String(),
          amount: -45.00,
          description: 'Phone Bill',
          type: 'debit',
        ),
      ]);
    }
  }

  @override
  Future<List<BeneficiaryModel>> getBeneficiaries() async {
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
  Future<TransferResponseModel> createTransfer({
    required String beneficiaryId,
    required double amount,
  }) async {
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
