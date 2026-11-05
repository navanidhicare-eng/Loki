import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../models/order_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;
  Map<String, dynamic>? currentUser;

  bool get isLoggedIn => _authToken != null;

  // Custom customer login
  Future<Map<String, dynamic>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier.trim(),
          'password': password.trim(),
          'role': 'customer',
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['success'] == true) {
        _authToken = data['token'];
        currentUser = data['user'];
        return {'success': true, 'message': data['message'], 'user': currentUser};
      }
      return {'success': false, 'message': data['message'] ?? 'Login failed. Please verify credentials.'};
    } catch (e) {
      return {'success': false, 'message': 'Connection error: Could not reach server.'};
    }
  }

  // Customer registration
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    String address = 'Hyderabad',
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name.trim(),
          'phone': phone.trim(),
          'email': email.trim().isEmpty ? '${phone.trim()}@customer.loki' : email.trim(),
          'password': password.trim(),
          'role': 'customer',
          'address': address.trim().isEmpty ? 'Hyderabad' : address.trim(),
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201 && data['success'] == true) {
        _authToken = data['token'];
        currentUser = data['user'];
        return {'success': true, 'message': data['message'], 'user': currentUser};
      }
      return {'success': false, 'message': data['message'] ?? 'Registration failed.'};
    } catch (e) {
      return {'success': false, 'message': 'Connection error: Could not reach server.'};
    }
  }

  void logout() {
    _authToken = null;
    currentUser = null;
  }

  // Authenticate demo customer if not logged in
  Future<bool> ensureCustomerAuth() async {
    if (_authToken != null) return true;
    final res = await login(identifier: 'customer@loki.com', password: 'customer123');
    return res['success'] == true;
  }

  // Fetch active promotions & ads from Super Admin backend
  Future<Map<String, dynamic>> fetchPromotions() async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.baseUrl}/promotions?active=true'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['success'] == true && data['grouped'] != null) {
          return Map<String, dynamic>.from(data['grouped']);
        }
      }
    } catch (e) {
      print('Fetch promotions error: $e');
    }
    return {};
  }

  // Fetch all service categories
  Future<List<ServiceCategory>> fetchCategories() async {
    try {
      final res = await http.get(Uri.parse('${AppConstants.baseUrl}/categories'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['categories'] as List;
        return list.map((c) => ServiceCategory.fromJson(c)).toList();
      }
    } catch (e) {
      print('Fetch categories error: $e');
    }
    return [];
  }

  // Fetch services for category
  Future<List<ServiceItem>> fetchServices({String? categoryId}) async {
    try {
      String url = '${AppConstants.baseUrl}/services';
      if (categoryId != null) {
        url += '?categoryId=$categoryId';
      }
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['services'] as List;
        return list.map((s) => ServiceItem.fromJson(s)).toList();
      }
    } catch (e) {
      print('Fetch services error: $e');
    }
    return [];
  }

  // Place a new booking
  Future<OrderModel?> placeOrder({
    required String serviceId,
    required String customerAddress,
    required String paymentMethod,
    String notes = '',
  }) async {
    await ensureCustomerAuth();
    try {
      final res = await http.post(
        Uri.parse('${AppConstants.baseUrl}/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: jsonEncode({
          'serviceId': serviceId,
          'customerAddress': customerAddress,
          'paymentMethod': paymentMethod,
          'notes': notes,
        }),
      );
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return OrderModel.fromJson(data['order']);
      }
    } catch (e) {
      print('Place order error: $e');
    }
    return null;
  }

  // Fetch customer orders
  Future<List<OrderModel>> fetchMyOrders() async {
    await ensureCustomerAuth();
    try {
      final res = await http.get(
        Uri.parse('${AppConstants.baseUrl}/orders/my'),
        headers: {
          'Authorization': 'Bearer $_authToken',
        },
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data['orders'] as List;
        return list.map((o) => OrderModel.fromJson(o)).toList();
      }
    } catch (e) {
      print('Fetch my orders error: $e');
    }
    return [];
  }
}
