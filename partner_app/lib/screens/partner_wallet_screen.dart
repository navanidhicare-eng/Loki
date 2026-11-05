import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/partner_api_service.dart';

class PartnerWalletScreen extends StatelessWidget {
  const PartnerWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = PartnerApiService().profile ?? {
      'name': 'Ramesh Kumar',
      'walletBalance': 4250,
      'kycStatus': 'approved',
      'aadhaarNumber': 'XXXX-XXXX-9821'
    };

    return Scaffold(
      backgroundColor: PartnerConstants.backgroundLight,
      appBar: AppBar(
        title: const Text('Partner Earnings & Wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: PartnerConstants.secondary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Net Earnings Card
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF047857), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: PartnerConstants.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'AVAILABLE BALANCE FOR PAYOUT',
                        style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('100% Net • 0% Commission', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${profile['walletBalance'] ?? 4250}.00',
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Instant Payout Request Transferred to Bank Account via IMPS')),
                      );
                    },
                    icon: const Icon(Icons.account_balance, size: 18),
                    label: const Text('Withdraw Funds to Bank Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PartnerConstants.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // KYC Status verification box
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: PartnerConstants.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified_user, color: PartnerConstants.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Aadhaar & Police KYC Verified', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text('Doc: ${profile['aadhaarNumber'] ?? 'Verified'}', style: const TextStyle(fontSize: 12, color: PartnerConstants.textMuted)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: PartnerConstants.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('ACTIVE', style: TextStyle(fontWeight: FontWeight.bold, color: PartnerConstants.primary, fontSize: 11)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Annual Subscription Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFBEB), Color(0xFFFEF3C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFDE68A)),
                boxShadow: [
                  BoxShadow(color: Colors.amber.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 22),
                          SizedBox(width: 8),
                          Text('Yearly Subscription Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF92400E))),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD97706),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('ACTIVE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Plan: Loki Annual Specialist Membership (₹2,999/yr)', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF78350F))),
                  const SizedBox(height: 4),
                  const Text('Validity: 365 Days Remaining (Renews Nov 2027)', style: TextStyle(fontSize: 12, color: Color(0xFF92400E))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 16),
                        SizedBox(width: 6),
                        Text('0% Commission: 100% of customer pay goes to you', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Yearly Subscription & Zero Commission Policy
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zero Commission Model & Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 10),
                  Text('• 0% Platform Commission: Loki NEVER deducts any percentage cut on your jobs.', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted, height: 1.4)),
                  SizedBox(height: 6),
                  Text('• Yearly Flat Membership: You only pay a fixed annual subscription for unlimited customer leads.', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted, height: 1.4)),
                  SizedBox(height: 6),
                  Text('• 100% Direct Customer Pay: Customer pays you directly via UPI or Cash with instant settlement.', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted, height: 1.4)),
                  SizedBox(height: 6),
                  Text('• Unlimited Free Job Leads during your active annual subscription period.', style: TextStyle(fontSize: 12, color: PartnerConstants.textMuted, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
