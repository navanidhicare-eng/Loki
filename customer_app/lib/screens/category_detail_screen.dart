import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';
import 'order_tracking_screen.dart';
import 'service_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final ServiceCategory category;

  const CategoryDetailScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final ApiService _api = ApiService();
  List<ServiceItem> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryServices();
  }

  void _loadCategoryServices() async {
    setState(() => _loading = true);
    final items = await _api.fetchServices(categoryId: widget.category.id);
    setState(() {
      _services = items;
      _loading = false;
    });
  }

  void _showBookingBottomSheet(ServiceItem service) {
    String selectedPayment = 'Cash on Delivery';
    final notesController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Confirm Instant Booking',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.secondary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Selected Service Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Duration: ${service.duration}',
                            style: const TextStyle(fontSize: 12, color: AppConstants.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${service.basePrice.toInt()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Address info
              const Text('Service Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.home, color: AppConstants.primary, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Flat 402, Green Meadows, Madhapur, Hyderabad',
                        style: TextStyle(fontSize: 13, color: AppConstants.secondary),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Payment options
              const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _paymentChip('UPI / Online', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                  const SizedBox(width: 10),
                  _paymentChip('Cash on Delivery', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                  const SizedBox(width: 10),
                  _paymentChip('Loki Wallet', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                ],
              ),

              const SizedBox(height: 20),

              // Confirm Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setModalState(() => isSubmitting = true);
                          final order = await _api.placeOrder(
                            serviceId: service.id,
                            customerAddress: 'Flat 402, Green Meadows, Madhapur, Hyderabad',
                            paymentMethod: selectedPayment,
                            notes: notesController.text,
                          );
                          setModalState(() => isSubmitting = false);

                          if (order != null) {
                            Navigator.pop(ctx);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderTrackingScreen(order: order),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to place booking. Please check connection.')),
                            );
                          }
                        },
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Confirm & Book Specialist (₹${service.basePrice.toInt()})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentChip(String title, String selected, Function(String) onSelect) {
    bool isSelected = title == selected;
    return InkWell(
      onTap: () => onSelect(title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppConstants.primary : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppConstants.primary : AppConstants.secondary,
          ),
        ),
      ),
    );
  }

  String _getServiceImageUrl(ServiceItem service) {
    final name = service.name.toLowerCase();
    final catId = widget.category.id;

    if (name.contains('fan')) {
      return 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('circuit') || name.contains('inspection') || name.contains('electric') || name.contains('wiring')) {
      return 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('tap') || name.contains('pipe') || name.contains('leak') || catId == 'cat_plumbing') {
      return 'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('tank') || name.contains('motor')) {
      return 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('ac') || name.contains('appliance') || name.contains('fridge') || name.contains('tv')) {
      return 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('bike') || name.contains('puncture') || name.contains('car') || catId == 'cat_mechanic') {
      return 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('clean') || name.contains('pest') || catId == 'cat_cleaning') {
      return 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500&auto=format&fit=crop&q=80';
    } else if (name.contains('delivery') || name.contains('parcel') || catId == 'cat_delivery') {
      return 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=500&auto=format&fit=crop&q=80';
    }
    return 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=500&auto=format&fit=crop&q=80';
  }

  Widget _buildImageFallback(ServiceItem service) {
    final isPlumbing = widget.category.id == 'cat_plumbing' || service.name.toLowerCase().contains('plumb');
    final isElectrician = widget.category.id == 'cat_electrical' || service.name.toLowerCase().contains('electr');
    final isDelivery = widget.category.id == 'cat_delivery' || service.name.toLowerCase().contains('deliver');
    final isMechanic = widget.category.id == 'cat_mechanic' || service.name.toLowerCase().contains('mechanic');
    final isShop = widget.category.id == 'cat_shops' || service.name.toLowerCase().contains('shop') || service.name.toLowerCase().contains('kirana');
    final isCleaning = widget.category.id == 'cat_cleaning' || service.name.toLowerCase().contains('clean');
    final isAppliance = widget.category.id == 'cat_appliances' || service.name.toLowerCase().contains('appliance');
    final isCable = widget.category.id == 'cat_bd22116b' || widget.category.name.toLowerCase().contains('cable') || service.name.toLowerCase().contains('cable') || service.name.toLowerCase().contains('net') || service.name.toLowerCase().contains('wifi');
    final isLeaseRental = widget.category.id == 'cat_ab5c5cd1' || widget.category.name.toLowerCase().contains('lease') || widget.category.name.toLowerCase().contains('rent') || service.name.toLowerCase().contains('lease') || service.name.toLowerCase().contains('rent');
    if (isPlumbing) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/plumbing_tap.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isElectrician) {
      return Container(
        color: const Color(0xFFFFFBEB),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/electrician_bolt.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isDelivery) {
      return Container(
        color: const Color(0xFFECFDF5),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/instant_delivery.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isMechanic) {
      return Container(
        color: const Color(0xFFFFF1F2),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/mechanic_tools.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isShop) {
      return Container(
        color: const Color(0xFFF5F3FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/local_shop.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isCleaning) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/deep_cleaning.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isAppliance) {
      return Container(
        color: const Color(0xFFFDF2F8),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/appliance_repairs.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isCable) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/cable_technicians.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    } else if (isLeaseRental) {
      return Container(
        color: const Color(0xFFFFF7ED),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/lease_rental.png',
          width: 56,
          height: 56,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 36),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.category.color.withOpacity(0.18), widget.category.color.withOpacity(0.06)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(widget.category.getIconData(), color: widget.category.color, size: 40),
      ),
    );
  }

  Widget _buildServiceCard(ServiceItem s) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ServiceDetailScreen(
                service: s,
                category: widget.category,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Top Image with Rating & Duration badges
            Stack(
              children: [
                SizedBox(
                  height: 92,
                  width: double.infinity,
                  child: Image.network(
                    _getServiceImageUrl(s),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImageFallback(s),
                    loadingBuilder: (ctx, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageFallback(s);
                    },
                  ),
                ),
                // Rating Chip
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.68),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: AppConstants.accentGold, size: 11),
                        const SizedBox(width: 2),
                        Text(
                          '${s.rating}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                // Duration Badge
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded, size: 10, color: Color(0xFF475569)),
                        const SizedBox(width: 2),
                        Text(
                          s.duration,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Content (Compact)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    s.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.secondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price & Action Button Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹${s.basePrice.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.primary,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _showBookingBottomSheet(s),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: Text(widget.category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.secondary,
        elevation: 0.5,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? const Center(child: Text('No active services listed yet under this vertical.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.98,
                  ),
                  itemCount: _services.length,
                  itemBuilder: (ctx, idx) => _buildServiceCard(_services[idx]),
                ),
    );
  }
}
