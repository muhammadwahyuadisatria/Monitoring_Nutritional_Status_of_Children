import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _konfirmasiHapusSemua(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Semua Riwayat'),
        content: const Text(
          'Semua riwayat pemeriksaan akan dihapus. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await DatabaseHelper.instance.deleteAllRiwayat();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua riwayat berhasil dihapus!'),
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC79B6D);
    const pageBg = Color(0xFFF9F6F2);
    const softBg = Color(0xFFF6EFE4);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO & NAMA APP
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.child_care_rounded,
                        size: 60,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'MONAS',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Monitoring Nutritional Status of Children',
                      style: TextStyle(fontSize: 13, color: Colors.black45),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Versi 1.0.0',
                      style: TextStyle(fontSize: 13, color: Colors.black38),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // TENTANG APLIKASI
              const Text(
                'Tentang Aplikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: softBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'MoNas (Monitoring Nutritional Status of Children) '
                  'adalah solusi inovatif yang dirancang untuk membantu keluarga '
                  'dengan mudah memantau pertumbuhan dan nutrisi anak-anak di bawah '
                  'usia lima tahun. Secara tradisional, pemeriksaan gizi bergantung '
                  'pada kunjungan langsung ke pos kesehatan setempat, yang sering '
                  'dibatasi oleh jarak, waktu, atau ketersediaan tenaga kesehatan '
                  'terutama di daerah terpencil. MoNas membuat proses ini lebih '
                  'sederhana dan mudah diakses dengan memungkinkan orang tua untuk '
                  'memasukkan data dasar anak mereka secara manual atau menggunakan '
                  'kamera smartphone untuk estimasi otomatis parameter pertumbuhan '
                  'utama. Aplikasi kemudian membandingkan hasil dengan standar WHO '
                  'dan pertumbuhan anak untuk memberikan status gizi yang jelas.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // HAPUS RIWAYAT
              const Text(
                'Data',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _konfirmasiHapusSemua(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFFF6B6B).withOpacity(0.3),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFFF6B6B),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hapus Semua Riwayat',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF6B6B),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hapus seluruh data riwayat pemeriksaan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFFFF6B6B),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Center(
                child: Text(
                  '© 2025 MONAS. All rights reserved.',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
