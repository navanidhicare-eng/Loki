import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/category_model.dart';
import '../models/service_model.dart';
import '../services/api_service.dart';
import 'order_tracking_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final ServiceItem service;
  final ServiceCategory category;

  const ServiceDetailScreen({
    Key? key,
    required this.service,
    required this.category,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final ApiService _api = ApiService();
  bool _isBookmarked = false;

  String _getServiceImageUrl() {
    final name = widget.service.name.toLowerCase();
    final catId = widget.category.id;

    if (name.contains('fan')) {
      return 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('circuit') || name.contains('inspection') || name.contains('electric') || name.contains('wiring')) {
      return 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('tap') || name.contains('pipe') || name.contains('leak') || catId == 'cat_plumbing') {
      return 'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('tank') || name.contains('motor')) {
      return 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('ac') || name.contains('appliance') || name.contains('fridge') || name.contains('tv')) {
      return 'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('bike') || name.contains('puncture') || name.contains('car') || catId == 'cat_mechanic') {
      return 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('clean') || name.contains('pest') || catId == 'cat_cleaning') {
      return 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800&auto=format&fit=crop&q=80';
    } else if (name.contains('delivery') || name.contains('parcel') || catId == 'cat_delivery') {
      return 'https://images.unsplash.com/photo-1616401784845-180882ba9ba8?w=800&auto=format&fit=crop&q=80';
    }
    return 'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800&auto=format&fit=crop&q=80';
  }

  Widget _buildImageFallback() {
    final isPlumbing = widget.category.id == 'cat_plumbing' || widget.service.name.toLowerCase().contains('plumb');
    final isElectrician = widget.category.id == 'cat_electrical' || widget.service.name.toLowerCase().contains('electr');
    final isDelivery = widget.category.id == 'cat_delivery' || widget.service.name.toLowerCase().contains('deliver');
    final isMechanic = widget.category.id == 'cat_mechanic' || widget.service.name.toLowerCase().contains('mechanic');
    final isShop = widget.category.id == 'cat_shops' || widget.service.name.toLowerCase().contains('shop') || widget.service.name.toLowerCase().contains('kirana');
    final isCleaning = widget.category.id == 'cat_cleaning' || widget.service.name.toLowerCase().contains('clean');
    final isAppliance = widget.category.id == 'cat_appliances' || widget.service.name.toLowerCase().contains('appliance');
    final isCable = widget.category.id == 'cat_bd22116b' || widget.category.name.toLowerCase().contains('cable') || widget.service.name.toLowerCase().contains('cable') || widget.service.name.toLowerCase().contains('net') || widget.service.name.toLowerCase().contains('wifi');
    final isLeaseRental = widget.category.id == 'cat_ab5c5cd1' || widget.category.name.toLowerCase().contains('lease') || widget.category.name.toLowerCase().contains('rent') || widget.service.name.toLowerCase().contains('lease') || widget.service.name.toLowerCase().contains('rent');
    if (isPlumbing) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/plumbing_tap.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isElectrician) {
      return Container(
        color: const Color(0xFFFFFBEB),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/electrician_bolt.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isDelivery) {
      return Container(
        color: const Color(0xFFECFDF5),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/instant_delivery.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isMechanic) {
      return Container(
        color: const Color(0xFFFFF1F2),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/mechanic_tools.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isShop) {
      return Container(
        color: const Color(0xFFF5F3FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/local_shop.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isCleaning) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/deep_cleaning.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isAppliance) {
      return Container(
        color: const Color(0xFFFDF2F8),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/appliance_repairs.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isCable) {
      return Container(
        color: const Color(0xFFEFF6FF),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/cable_technicians.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    } else if (isLeaseRental) {
      return Container(
        color: const Color(0xFFFFF7ED),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/lease_rental.png',
          width: 90,
          height: 90,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 60),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.category.color.withOpacity(0.2), widget.category.color.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(widget.category.getIconData(), color: widget.category.color, size: 64),
      ),
    );
  }

  void _showBookingBottomSheet() {
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
                  const Text(
                    'Confirm Instant Booking',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.secondary),
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
                  children: [
                    if (widget.category.id == 'cat_plumbing' || widget.service.name.toLowerCase().contains('plumb'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/plumbing_tap.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_electrical' || widget.service.name.toLowerCase().contains('electr'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/electrician_bolt.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_delivery' || widget.service.name.toLowerCase().contains('deliver'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/instant_delivery.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_mechanic' || widget.service.name.toLowerCase().contains('mechanic'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/mechanic_tools.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_shops' || widget.service.name.toLowerCase().contains('shop') || widget.service.name.toLowerCase().contains('kirana'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/local_shop.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_cleaning' || widget.service.name.toLowerCase().contains('clean'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/deep_cleaning.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_appliances' || widget.service.name.toLowerCase().contains('appliance'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/appliance_repairs.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_bd22116b' || widget.category.name.toLowerCase().contains('cable') || widget.service.name.toLowerCase().contains('cable'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/cable_technicians.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else if (widget.category.id == 'cat_ab5c5cd1' || widget.category.name.toLowerCase().contains('lease') || widget.category.name.toLowerCase().contains('rent') || widget.service.name.toLowerCase().contains('lease') || widget.service.name.toLowerCase().contains('rent'))
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Image.asset(
                          'assets/images/lease_rental.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                        ),
                      )
                    else
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: widget.category.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(widget.category.getIconData(), color: widget.category.color, size: 24),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 3),
                          Text('${widget.service.duration} • ★ ${widget.service.rating}', style: const TextStyle(fontSize: 12, color: AppConstants.textMuted)),
                        ],
                      ),
                    ),
                    Text(
                      '₹${widget.service.basePrice.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppConstants.primary, fontSize: 18),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text('Address / Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.secondary)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: AppConstants.primary, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Flat 402, Green Meadows, Madhapur, Hyderabad', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text('Service Instructions (Optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.secondary)),
              const SizedBox(height: 6),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: 'e.g. Please bring regulator, call before coming',
                  hintStyle: const TextStyle(fontSize: 13, color: AppConstants.textDim),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppConstants.primary)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Payment Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppConstants.secondary)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _paymentChip('Cash on Delivery', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                  const SizedBox(width: 8),
                  _paymentChip('Loki Wallet (₹750)', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                  const SizedBox(width: 8),
                  _paymentChip('UPI / Card', selectedPayment, (val) => setModalState(() => selectedPayment = val)),
                ],
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setModalState(() => isSubmitting = true);
                          final order = await _api.placeOrder(
                            serviceId: widget.service.id,
                            customerAddress: 'Flat 402, Green Meadows, Madhapur, Hyderabad',
                            paymentMethod: selectedPayment,
                            notes: notesController.text,
                          );

                          setModalState(() => isSubmitting = false);

                          if (order != null) {
                            if (!mounted) return;
                            Navigator.pop(ctx);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: order)),
                            );
                          } else {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to book service. Please check connection.'), backgroundColor: Colors.red),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
                          'PAY ₹${widget.service.basePrice.toInt()} & BOOK NOW',
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

  @override
  Widget build(BuildContext context) {
    final originalPrice = (widget.service.basePrice * 1.45).toInt();
    final savings = originalPrice - widget.service.basePrice.toInt();

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // Hero Header Image & Navigation
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.secondary,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.9),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppConstants.secondary, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: IconButton(
                    icon: Icon(
                      _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: _isBookmarked ? AppConstants.primary : AppConstants.secondary,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isBookmarked = !_isBookmarked);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isBookmarked ? 'Service saved to favorites!' : 'Removed from favorites'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _getServiceImageUrl(),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildImageFallback(),
                    loadingBuilder: (ctx, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageFallback();
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.5), Colors.transparent, Colors.black.withOpacity(0.7)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.accentGold,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.category.name.toUpperCase(),
                            style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.service.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Service Overview Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Badges: Rating, Time, Bookings
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${widget.service.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF92400E))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFF2563EB)),
                            const SizedBox(width: 4),
                            Text(widget.service.duration, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF))),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: Text(
                          '${widget.service.totalBookings}+ Done',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Pricing & Discount Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '₹${widget.service.basePrice.toInt()}',
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppConstants.primary),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '₹$originalPrice',
                                  style: const TextStyle(fontSize: 15, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Save ₹$savings today',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        Row(
                          children: const [
                            Icon(Icons.bolt, color: AppConstants.accentGold, size: 18),
                            SizedBox(width: 6),
                            Text(
                              '30-Mins Hyperlocal Partner Arrival Guarantee',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF192338)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About Service Description Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Service Description', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppConstants.secondary)),
                        const SizedBox(height: 8),
                        Text(
                          widget.service.description,
                          style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // What is Included Checklist Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('What is Included', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppConstants.secondary)),
                        const SizedBox(height: 12),
                        _buildFeatureItem(Icons.check_circle, Colors.green, 'On-site technical inspection & issue diagnosis'),
                        _buildFeatureItem(Icons.check_circle, Colors.green, 'Complete installation, tightening & fitting with professional tools'),
                        _buildFeatureItem(Icons.check_circle, Colors.green, 'Safety electrical & performance test run in front of customer'),
                        _buildFeatureItem(Icons.check_circle, Colors.green, '30-Day Loki Hyperlocal warranty on workmanship'),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        const Text('What is Excluded', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppConstants.secondary)),
                        const SizedBox(height: 8),
                        _buildFeatureItem(Icons.cancel, Colors.red.shade400, 'Cost of new spare parts, wires, or hardware (charged extra at MRP)'),
                        _buildFeatureItem(Icons.cancel, Colors.red.shade400, 'Heavy masonry or concealed wall drilling work'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Safe & Trust Badges
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppConstants.primary.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: AppConstants.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Loki Safety & Trust Assurance',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF192338)),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'All technicians undergo Aadhaar KYC, police background verification, and live OTP verification at arrival.',
                                style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 90), // Bottom padding for sticky bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky Bottom Book Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3)),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Price', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  Text(
                    '₹${widget.service.basePrice.toInt()}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppConstants.primary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _showBookingBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('BOOK THIS SERVICE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.3)),
          ),
        ],
      ),
    );
  }
}
