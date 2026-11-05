class OrderModel {
  final String id;
  final String serviceName;
  final String providerName;
  final String customerAddress;
  final double amount;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMethod;
  final String otp;
  final String notes;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.customerAddress,
    required this.amount,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.otp,
    required this.notes,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? 'General Service',
      providerName: json['providerName'] ?? 'Assigned Partner',
      customerAddress: json['customerAddress'] ?? 'Your Location',
      amount: (json['amount'] ?? 0).toDouble(),
      orderStatus: json['orderStatus'] ?? 'PENDING',
      paymentStatus: json['paymentStatus'] ?? 'PENDING',
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      otp: json['otp'] ?? '0000',
      notes: json['notes'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
