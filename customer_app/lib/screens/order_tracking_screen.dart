import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isCompleted = order.orderStatus == 'COMPLETED';
    bool isInProgress = order.orderStatus == 'IN_PROGRESS';
    bool isAccepted = order.orderStatus == 'ACCEPTED' || isInProgress || isCompleted;

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Live Booking Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.secondary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order ID Card
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
                      Text(
                        order.id,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppConstants.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isCompleted ? AppConstants.accentEmerald : AppConstants.accentGold).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.orderStatus,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isCompleted ? AppConstants.accentEmerald : AppConstants.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    order.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppConstants.secondary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppConstants.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          order.customerAddress,
                          style: const TextStyle(fontSize: 13, color: AppConstants.textMuted),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // OTP PIN Card (Crucial for customer security)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppConstants.primary.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 6))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppConstants.accentGold.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.security, color: AppConstants.accentGold, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'START-WORK SECURE OTP',
                          style: TextStyle(color: AppConstants.textDim, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order.otp,
                          style: const TextStyle(
                            color: AppConstants.accentGold,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Share only when specialist arrives at your door',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tracking Progress Timeline
            const Text(
              'Booking Timeline',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.secondary),
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _timelineStep('Order Placed & Confirmed', 'Nearby specialists alerted', true, true),
                  _timelineStep('Specialist Assigned', order.providerName, isAccepted, true),
                  _timelineStep('Service In Progress', 'Work verified via customer OTP', isInProgress || isCompleted, !isCompleted),
                  _timelineStep('Completed & Safe Sign-off', 'Payment verified', isCompleted, false),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Assigned Provider Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppConstants.primary.withOpacity(0.15),
                    child: const Icon(Icons.person, color: AppConstants.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.providerName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppConstants.secondary),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.verified, color: AppConstants.accentEmerald, size: 14),
                            SizedBox(width: 4),
                            Text('Aadhaar Verified Specialist', style: TextStyle(fontSize: 12, color: AppConstants.accentEmerald, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling assigned specialist...')),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppConstants.accentEmerald,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.phone, color: Colors.white, size: 18),
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

  Widget _timelineStep(String title, String subtitle, bool isDone, bool hasNext) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDone ? AppConstants.primary : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            if (hasNext)
              Container(
                width: 2,
                height: 36,
                color: isDone ? AppConstants.primary : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isDone ? AppConstants.secondary : AppConstants.textDim,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppConstants.textMuted),
              ),
              if (hasNext) const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }
}
