import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            const Text(
              'Welcome !',
              style: TextStyle(
                fontSize: 36,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: Color(0xFFE5C8A8),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => _showMethodPopup(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6EFE4),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 54,
                      color: Color(0xFFC79B6D),
                    ),
                    SizedBox(width: 18),
                    Text(
                      'MULAI CEK !',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC79B6D),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  void _showMethodPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
            decoration: BoxDecoration(
              color: const Color(0xFFF7EFE8),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.close_rounded,
                        size: 34,
                        color: Color(0xFFC79B6D),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _methodCard(
                  icon: Icons.edit_note_rounded,
                  title: 'MANUAL',
                  subtitle: 'LEBIH AKURAT',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/manual-input');
                  },
                ),
                const SizedBox(height: 18),
                _methodCard(
                  icon: Icons.camera_alt_rounded,
                  title: 'FOTO',
                  subtitle: 'HASIL LEBIH CEPAT',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/photo-input');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _methodCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F4EA),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFF2E5D5),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 36, color: const Color(0xFFC79B6D)),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFC79B6D),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFC79B6D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
