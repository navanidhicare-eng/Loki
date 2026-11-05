class ServiceItem {
  final String id;
  final String categoryId;
  final String name;
  final double basePrice;
  final String duration;
  final String description;
  final double rating;
  final int totalBookings;

  ServiceItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.basePrice,
    required this.duration,
    required this.description,
    required this.rating,
    required this.totalBookings,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      name: json['name'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      duration: json['duration'] ?? '30 mins',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalBookings: json['totalBookings'] ?? 0,
    );
  }
}
