import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:novabank/data/models/models.dart';
import 'local_datasource.dart';

class LocalDataSourceImpl implements LocalDataSource {
  final Database database;

  LocalDataSourceImpl({required this.database});

  static const String _accountsTable = 'accounts';
  static const String _transactionsTable = 'transactions';

  /// Initialize database schema
  static Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'novabank.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Accounts table
        await db.execute('''
          CREATE TABLE $_accountsTable (
            id TEXT PRIMARY KEY,
            account_number TEXT NOT NULL,
            account_type TEXT NOT NULL,
            balance REAL NOT NULL,
            currency TEXT NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');

        // Transactions table
        await db.execute('''
          CREATE TABLE $_transactionsTable (
            id TEXT PRIMARY KEY,
            account_id TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            description TEXT,
            date INTEGER NOT NULL,
            page INTEGER DEFAULT 1,
            FOREIGN KEY (account_id) REFERENCES $_accountsTable (id)
          )
        ''');

        // Index for faster transaction queries
        await db.execute('''
          CREATE INDEX idx_transactions_account_page 
          ON $_transactionsTable (account_id, page)
        ''');
      },
    );
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        _accountsTable,
        orderBy: 'created_at DESC',
      );
      return AccountModel.fromJsonList(maps);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveAccounts(List<AccountModel> accounts) async {
    final batch = database.batch();
    
    // Clear existing accounts
    batch.delete(_accountsTable);
    
    // Insert new accounts
    for (final account in accounts) {
      batch.insert(
        _accountsTable,
        account.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<List<TransactionModel>> getAccountTransactions(
    String accountId, {
    int? page,
  }) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        _transactionsTable,
        where: 'account_id = ? AND page = ?',
        whereArgs: [accountId, page ?? 1],
        orderBy: 'date DESC',
      );
      return TransactionModel.fromJsonList(maps);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveAccountTransactions(
    String accountId,
    List<TransactionModel> transactions, {
    int? page,
  }) async {
    final batch = database.batch();
    final currentPage = page ?? 1;
    
    // Clear existing transactions for this account and page
    batch.delete(
      _transactionsTable,
      where: 'account_id = ? AND page = ?',
      whereArgs: [accountId, currentPage],
    );
    
    // Insert new transactions
    for (final transaction in transactions) {
      final jsonData = transaction.toJson();
      jsonData['account_id'] = accountId;
      jsonData['page'] = currentPage;
      
      batch.insert(
        _transactionsTable,
        jsonData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    
    await batch.commit(noResult: true);
  }

  @override
  Future<void> clearAll() async {
    final batch = database.batch();
    batch.delete(_accountsTable);
    batch.delete(_transactionsTable);
    await batch.commit(noResult: true);
  }
}