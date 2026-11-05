import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/partner_order_model.dart';
import '../services/partner_api_service.dart';

class PartnerJobDetailScreen extends StatefulWidget {
  final PartnerOrder order;
  final VoidCallback onUpdated;

  const PartnerJobDetailScreen({Key? key, required this.order, required this.onUpdated}) : super(key: key);

  @override
  State<PartnerJobDetailScreen> createState() => _PartnerJobDetailScreenState();
}

class _PartnerJobDetailScreenState extends State<PartnerJobDetailScreen> {
  final PartnerApiService _api = PartnerApiService();
  final _otpController = TextEditingController();
  bool _submitting = false;

  void _handleStartJob() async {
    if (_otpController.text.trim().length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 4-digit OTP provided by customer')),
      );
      return;
    }

    setState(() => _submitting = true);
    final ok = await _api.updateOrderStatus(widget.order.id, 'IN_PROGRESS', otp: _otpController.text.trim());
    setState(() => _submitting = false);

    if (ok) {
      widget.onUpdated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified! Job is now In Progress')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP entered. Please check with customer.')),
      );
    }
  }

  void _handleCompleteJob() async {
    setState(() => _submitting = true);
    final ok = await _api.updateOrderStatus(widget.order.id, 'COMPLETED');
    setState(() => _submitting = false);

    if (ok) {
      widget.onUpdated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job Completed! ₹${widget.order.amount.toInt()} received directly from customer (0% Commission)'),
          backgroundColor: const Color(0xFF059669),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPending = widget.order.orderStatus == 'PENDING';
    bool isAccepted = widget.order.orderStatus == 'ACCEPTED';
    bool isInProgress = widget.order.orderStatus == 'IN_PROGRESS';
    bool isCompleted = widget.order.orderStatus == 'COMPLETED';

    return Scaffold(
      backgroundColor: PartnerConstants.backgroundLight,
      appBar: AppBar(
        title: Text('Job #${widget.order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: PartnerConstants.secondary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.order.serviceName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: PartnerConstants.secondary),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFA7F3D0)),
                        ),
                        child: const Text(
                          'Direct Lead',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF059669)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Direct Customer Deal • 0% Commission Lead', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Customer Contact & Navigation Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer Destination', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: PartnerConstants.accentRose, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.order.customerAddress,
                          style: const TextStyle(fontSize: 14, color: PartnerConstants.secondary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.person, color: PartnerConstants.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.order.customerName} (${widget.order.customerPhone})',
                        style: const TextStyle(fontSize: 13, color: PartnerConstants.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Launching Google Maps Navigation...')),
                            );
                          },
                          icon: const Icon(Icons.navigation, size: 16),
                          label: const Text('Open Maps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PartnerConstants.accentBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling customer directly...')),
                            );
                          },
                          icon: const Icon(Icons.phone, size: 16),
                          label: const Text('Call Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PartnerConstants.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // OTP Verification Box (When specialist arrives at customer's home)
            if (isAccepted)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.shield, color: PartnerConstants.accentGold, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'ENTER CUSTOMER OTP TO START',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '----',
                        hintStyle: const TextStyle(color: Colors.white30),
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.08),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _handleStartJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PartnerConstants.accentGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _submitting
                            ? const CircularProgressIndicator()
                            : const Text('Verify OTP & Start Work', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),

            // In-Progress completion action
            if (isInProgress)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Work Currently in Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text('Make sure all service checklists are completed safely.', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _handleCompleteJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PartnerConstants.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _submitting
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Complete Work & Collect Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),

            if (isCompleted)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: PartnerConstants.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PartnerConstants.primary),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: PartnerConstants.primary, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This job is completed and payment has been credited to your wallet!',
                        style: TextStyle(fontWeight: FontWeight.bold, color: PartnerConstants.primary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
