import 'dart:convert';
import 'package:inventory/models/customer.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/models/sale.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('datazetu.db');
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
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        sale_id INTEGER,
        subtotal REAL NOT NULL,
        FOREIGN KEY (sale_id) REFERENCES sales (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        description TEXT NOT NULL
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


  // Product methods
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products');
    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final result = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Product.fromJson(result.first);
    }
    return null;
  }

  // Sale methods
  Future<int> insertSale(Sale sale) async {
    final db = await database;
    return await db.insert('sales', sale.toJson());
  }

  Future<List<Sale>> getAllSales() async {
    final db = await database;
    final result = await db.query('sales');
    return result.map((json) => Sale.fromJson(json)).toList();
  }

  Future<int> updateSale(Sale sale) async {
    final db = await database;
    return await db.update(
      'sales',
      sale.toJson(),
      where: 'id = ?',
      whereArgs: [sale.id],
    );
  }

  Future<int> deleteSale(int id) async {
    final db = await database;
    return await db.delete(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Sale?> getSaleById(int id) async {
    final db = await database;
    final result = await db.query('sales', where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return Sale.fromJson(result.first);
    }
    return null;
  }
}