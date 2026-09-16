import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/ngo_model.dart';

class NGOContactDonationScreen extends StatelessWidget {
  final NGOModel ngo;

  const NGOContactDonationScreen({
    super.key,
    required this.ngo,
  });

  void copyText(BuildContext context, String text) {
    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Copied successfully',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF134685),

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ngo.imageUrl != null &&
                      ngo.imageUrl!.isNotEmpty
                      ? ngo.imageUrl!.startsWith('http')
                      ? Image.network(
                    ngo.imageUrl!,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    ngo.imageUrl!,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    color: Colors.grey.shade300,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.2),
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    left: 22,
                    right: 22,
                    bottom: 35,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 14),
                        Text(
                          ngo.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 18,
                            ),

                            const SizedBox(width: 6),

                            Expanded(
                              child: Text(
                                ngo.location,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF134685),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "About NGO",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF134685),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Text(
                          ngo.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    "Donation Methods",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Copy the details below and send donation manually.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 22),
                  _paymentCard(
                    context,
                    title: "Easypaisa",
                    number: ngo.easypaisa,
                    color: const Color(0xFF10B981),
                    icon: Icons.account_balance_wallet,
                  ),

                  _paymentCard(
                    context,
                    title: "JazzCash",
                    number: ngo.jazzcash,
                    color: const Color(0xFFF59E0B),
                    icon: Icons.wallet,
                  ),

                  _paymentCard(
                    context,
                    title: "Bank Transfer",
                    number: ngo.bankTransfer,
                    color: const Color(0xFF2563EB),
                    icon: Icons.account_balance,
                  ),

                  const SizedBox(height: 26),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Color(0xFF2563EB),
                          ),
                        ),

                        const SizedBox(width: 14),

                        const Expanded(
                          child: Text(
                            "After sending donation, contact the NGO and share your payment screenshot for confirmation.",
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentCard(
      BuildContext context, {
        required String title,
        required String number,
        required Color color,
        required IconData icon,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 6),
                Text(
                  number.isEmpty
                      ? 'Not Available'
                      : number,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              if (number.isNotEmpty) {
                copyText(context, number);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.copy_rounded,
                color: color,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}