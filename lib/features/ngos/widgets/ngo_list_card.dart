
import 'package:diaster_ngo_app/features/ngos/model/ngo_model.dart';
import 'package:diaster_ngo_app/features/ngos/view/donation_contact_screen.dart';
import 'package:diaster_ngo_app/features/ngos/widgets/app_card.dart';
import 'package:flutter/material.dart';

class NGOListCard extends StatelessWidget {
  final NGOModel ngo;
  final VoidCallback? onTap;

  const NGOListCard({
    super.key,
    required this.ngo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        height: MediaQuery.of(context).size.height / 1.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ngo.imageUrl != null &&
                  ngo.imageUrl!.isNotEmpty
                  ? ngo.imageUrl!.startsWith('http')
                  ? Image.network(
                ngo.imageUrl!,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: _imageFallback,
              )
                  : Image.asset(
                ngo.imageUrl!,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : _imagePlaceholder(),
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ngo.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 8),

                _StatusBadge(
                  status: ngo.status,
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text(
              ngo.category.label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),
            _IconRow(
              icon: Icons.location_on,
              iconColor: Colors.white38,
              text: ngo.location,
            ),

            const SizedBox(height: 6),
            _IconRow(
              icon: Icons.phone,
              iconColor: Colors.green,
              text: ngo.phone,
            ),

            const SizedBox(height: 6),
            _IconRow(
              icon: Icons.email,
              iconColor: Color(0xFF2196F3),
              text: ngo.email,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF42A5F5),
                    Color(0xFF1976D2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2196F3)
                        .withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NGOContactDonationScreen(
                        ngo: ngo,
                      ),
                    ),
                  );
                },
                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.transparent,
                  shadowColor:
                  Colors.transparent,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons
                          .volunteer_activism_rounded,
                      color: Colors.white,
                      size: 22,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "Donate Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.business,
          size: 48,
          color: Colors.white24,
        ),
      ),
    );
  }

  Widget _imageFallback(
      BuildContext context,
      Object error,
      StackTrace? stackTrace,
      ) {
    return _imagePlaceholder();
  }
}

class _StatusBadge extends StatelessWidget {
  final NGOStatus status;

  const _StatusBadge({
    required this.status,
  });

  Color get _color {
    switch (status) {
      case NGOStatus.active:
        return Colors.green;

      case NGOStatus.inactive:
        return Colors.red;

      case NGOStatus.pending:
        return Colors.orange;
    }
  }

  String get _label {
    switch (status) {
      case NGOStatus.active:
        return 'Active';

      case NGOStatus.inactive:
        return 'Inactive';

      case NGOStatus.pending:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius:
        BorderRadius.circular(8),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final TextOverflow? overflow;

  const _IconRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: iconColor,
        ),

        const SizedBox(width: 6),

        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
            overflow: overflow,
          ),
        ),
      ],
    );
  }
}