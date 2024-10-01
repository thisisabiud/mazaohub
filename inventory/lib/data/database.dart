import 'package:inventory/models/customer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('my_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        TIN TEXT NOT NULL,
        address TEXT NOT NULL,
        phone_number TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES customers (id)
      )
    ''');
  }

  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert('customers', customer.toJson());
  }



  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final result = await db.query('customers');
    return result.map((json) => Customer.fromJson(json)).toList();
  }
  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    final result = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Customer.fromJson(result.first);
    }
    return null;
  }


  // Future<List<Sale>> getAllSales() async {
  //   final db = await database;
  //   final result = await db.query('sales');
  //   return result.map((json) => Sale.fromJson(json)).toList();
  // }


  // Future<List<Sale>> getSalesByCustomerId(int customerId) async {
  //   final db = await database;
  //   final result = await db.query('sales', where: 'customer_id = ?', whereArgs: [customerId]);
  //   return result.map((json) => Sale.fromJson(json)).toList();
  // }

    // Future<int> insertSale(Sale sale) async {
  //   final db = await database;
  //   return await db.insert('sales', sale.toJson());
  // }
}
