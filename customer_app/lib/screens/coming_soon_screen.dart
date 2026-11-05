import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class ComingSoonScreen extends StatefulWidget {
  final ServiceCategory category;

  const ComingSoonScreen({super.key, required this.category});

  @override
  State<ComingSoonScreen> createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen> {
  final _contactController = TextEditingController();
  bool _isNotified = false;

  @override
  void initState() {
    super.initState();
    final user = ApiService().currentUser;
    if (user != null && user['phone'] != null) {
      _contactController.text = user['phone'].toString();
    }
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Widget _buildCategory3DIcon() {
    final cat = widget.category;
    final isPlumbing = cat.id == 'cat_plumbing' || cat.name.toLowerCase().contains('plumb');
    final isElectrician = cat.id == 'cat_electrical' || cat.name.toLowerCase().contains('electr');
    final isDelivery = cat.id == 'cat_delivery' || cat.name.toLowerCase().contains('deliver');
    final isMechanic = cat.id == 'cat_mechanic' || cat.name.toLowerCase().contains('mechanic');
    final isShop = cat.id == 'cat_shops' || cat.name.toLowerCase().contains('shop') || cat.name.toLowerCase().contains('kirana');
    final isCleaning = cat.id == 'cat_cleaning' || cat.name.toLowerCase().contains('clean');
    final isAppliance = cat.id == 'cat_appliances' || cat.name.toLowerCase().contains('appliance');
    final isCable = cat.id == 'cat_bd22116b' || cat.name.toLowerCase().contains('cable');
    final isLeaseRental = cat.id == 'cat_ab5c5cd1' || cat.name.toLowerCase().contains('lease') || cat.name.toLowerCase().contains('rent');

    Widget iconWidget;
    if (isPlumbing) {
      iconWidget = Image.asset('assets/images/plumbing_tap.png', fit: BoxFit.contain);
    } else if (isElectrician) {
      iconWidget = Image.asset('assets/images/electrician_bolt.png', fit: BoxFit.contain);
    } else if (isDelivery) {
      iconWidget = Image.asset('assets/images/instant_delivery.png', fit: BoxFit.contain);
    } else if (isMechanic) {
      iconWidget = Image.asset('assets/images/mechanic_tools.png', fit: BoxFit.contain);
    } else if (isShop) {
      iconWidget = Image.asset('assets/images/local_shop.png', fit: BoxFit.contain);
    } else if (isCleaning) {
      iconWidget = Image.asset('assets/images/deep_cleaning.png', fit: BoxFit.contain);
    } else if (isAppliance) {
      iconWidget = Image.asset('assets/images/appliance_repairs.png', fit: BoxFit.contain);
    } else if (isCable) {
      iconWidget = Image.asset('assets/images/cable_technicians.png', fit: BoxFit.contain);
    } else if (isLeaseRental) {
      iconWidget = Image.asset('assets/images/lease_rental.png', fit: BoxFit.contain);
    } else {
      iconWidget = Icon(cat.getIconData(), color: cat.color, size: 48);
    }

    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }

  void _handleNotify() {
    setState(() => _isNotified = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("🎉 You're on the launch priority list for ${widget.category.name}!"),
        backgroundColor: AppConstants.accentEmerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.secondary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // 3D Category Icon
            _buildCategory3DIcon(),

            const SizedBox(height: 20),

            // "Coming Soon" Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: AppConstants.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppConstants.primary.withOpacity(0.25)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.rocket_launch_rounded, color: AppConstants.primary, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'COMING SOON',
                    style: TextStyle(
                      color: AppConstants.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Main Heading
            Text(
              '${widget.category.name} is Coming Soon!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppConstants.secondary,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'We are onboarding top-rated, police-verified specialists in your area to deliver 100% quality and 30-minute doorstep service.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppConstants.textMuted,
                  height: 1.45,
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Benefits Preview Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What to expect when we go live:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.secondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _benefitRow(
                    Icons.flash_on_rounded,
                    '30-Minute Doorstep Arrival',
                    'Nearest certified professional reaches you in minutes',
                    AppConstants.primary,
                  ),
                  const SizedBox(height: 12),
                  _benefitRow(
                    Icons.verified_user_rounded,
                    'Police & Aadhaar Verified',
                    '100% background checked and skilled specialists',
                    AppConstants.accentEmerald,
                  ),
                  const SizedBox(height: 12),
                  _benefitRow(
                    Icons.sell_rounded,
                    'Fixed & Transparent Pricing',
                    'Upfront price estimate with no hidden service charges',
                    AppConstants.accentGold,
                  ),
                  const SizedBox(height: 12),
                  _benefitRow(
                    Icons.shield_rounded,
                    'Damage Protection Guarantee',
                    'Full warranty on repairs and genuine spare parts',
                    const Color(0xFF6366F1),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Notify Me Section
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF192338), Color(0xFF28354D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_rounded, color: AppConstants.accentGold, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Get Notified on Launch Day',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Be the first to enjoy an exclusive ₹150 launch discount code.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  if (_isNotified)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppConstants.accentEmerald.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppConstants.accentEmerald),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded, color: AppConstants.accentEmerald, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "You're registered! We'll notify you via SMS & push as soon as we launch.",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _contactController,
                              style: const TextStyle(fontSize: 13, color: AppConstants.secondary),
                              decoration: const InputDecoration(
                                hintText: 'Enter mobile number',
                                hintStyle: TextStyle(fontSize: 12, color: AppConstants.textDim),
                                prefixIcon: Icon(Icons.phone, size: 16, color: AppConstants.textDim),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _handleNotify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Notify Me', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Back to Home Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Explore Other Categories',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _benefitRow(IconData icon, String title, String subtitle, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.secondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppConstants.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

