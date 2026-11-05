class PartnerOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String serviceName;
  final double amount;
  final String orderStatus;
  final String otp;
  final String notes;
  final String paymentMethod;
  final String createdAt;

  PartnerOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.serviceName,
    required this.amount,
    required this.orderStatus,
    required this.otp,
    required this.notes,
    required this.paymentMethod,
    required this.createdAt,
  });

  PartnerOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? serviceName,
    double? amount,
    String? orderStatus,
    String? otp,
    String? notes,
    String? paymentMethod,
    String? createdAt,
  }) {
    return PartnerOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
      orderStatus: orderStatus ?? this.orderStatus,
      otp: otp ?? this.otp,
      notes: notes ?? this.notes,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory PartnerOrder.fromJson(Map<String, dynamic> json) {
    return PartnerOrder(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? 'Customer',
      customerPhone: json['customerPhone'] ?? '',
      customerAddress: json['customerAddress'] ?? 'Nearby Location',
      serviceName: json['serviceName'] ?? 'Service Job',
      amount: (json['amount'] ?? 0).toDouble(),
      orderStatus: json['orderStatus'] ?? 'PENDING',
      otp: json['otp'] ?? '',
      notes: json['notes'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
