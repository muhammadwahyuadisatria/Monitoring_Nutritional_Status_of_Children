import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String metode;

  const ResultScreen({super.key, required this.data, this.metode = 'manual'});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _sudahDisimpan = false;
  final TextEditingController _namaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _simpanRiwayat() async {
    if (_namaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Isi nama anak dulu!')));
      return;
    }

    final data = widget.data;
    final berat = data['berat'] != null
        ? double.parse(data['berat'].toString())
        : 0.0;
    final tinggi = data['tinggi'] != null
        ? double.parse(data['tinggi'].toString())
        : 0.0;

    await DatabaseHelper.instance.insertRiwayat({
      'nama': _namaController.text.trim(),
      'jenis_kelamin': data['jenis_kelamin'] ?? '-',
      'tanggal_lahir': data['tanggal_lahir'] ?? '-',
      'umur_bulan': data['umur_bulan'] ?? 0,
      'tinggi': tinggi,
      'berat': double.parse(berat.toStringAsFixed(2)),
      'status_bbtb': data['status_bbtb'] ?? '-',
      'status_tbu': data['status_tbu'] ?? '-',
      'kesimpulan': data['kesimpulan'] ?? '-',
      'metode': widget.metode,
      'tanggal_periksa': DateTime.now().toIso8601String(),
    });

    setState(() => _sudahDisimpan = true);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Riwayat berhasil disimpan!')));
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC79B6D);
    const lineColor = Color(0xFFE8D7C2);
    const bgColor = Color(0xFFF9F6F2);
    const softBg = Color(0xFFF6EFE4);

    final data = widget.data;
    final String statusBbtb = (data['status_bbtb'] ?? '-').toString();
    final String statusTbu = (data['status_tbu'] ?? '-').toString();
    final String tanggalLahir = (data['tanggal_lahir'] ?? '-').toString();
    final String umurBulanText = '${data['umur_bulan'] ?? '-'} bulan';
    final String tinggiText = '${data['tinggi'] ?? '-'} cm';
    final String beratText = data['berat'] != null
        ? '${double.parse(data['berat'].toString()).toStringAsFixed(2)} kg'
        : '- kg';

    final String headlineStatus = _headlineStatus(statusBbtb);
    final Color headlineColor = _headlineColor(statusBbtb);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hasil Pemeriksaan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 4),
              const Text(
                'HASIL',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                ),
              ),
              const Text(
                'KONDISI ANAK',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),

              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: headlineColor.withOpacity(0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.child_care_rounded,
                  size: 86,
                  color: headlineColor,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                headlineStatus.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: headlineColor,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'DIAMBIL DARI HASIL PEMERIKSAAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFBFA180),
                ),
              ),

              const SizedBox(height: 28),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Icon(
                      Icons.accessibility_new_rounded,
                      size: 125,
                      color: primaryColor.withOpacity(0.30),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 120,
                    color: lineColor,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  Expanded(
                    flex: 5,
                    child: Row(
                      children: [
                        Expanded(
                          child: _metricMini(
                            icon: Icons.height_rounded,
                            title: 'TINGGI',
                            value: tinggiText,
                          ),
                        ),
                        Container(width: 1, height: 84, color: lineColor),
                        Expanded(
                          child: _metricMini(
                            icon: Icons.monitor_weight_rounded,
                            title: 'BERAT',
                            value: beratText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _infoLine(
                icon: Icons.cake_outlined,
                label: 'LAHIR',
                value: tanggalLahir,
              ),
              _divider(),
              _infoLine(
                icon: Icons.access_time_rounded,
                label: 'USIA',
                value: umurBulanText,
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'KONDISI ANAK PADA USIA INI',
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryColor.withOpacity(0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _divider(),
              _resultLine(
                label: 'BERAT BADAN',
                value: _statusGiziBerat(statusBbtb),
                valueColor: _statusColorBbtb(statusBbtb),
              ),
              _divider(),
              _resultLine(
                label: 'TINGGI BADAN',
                value: statusTbu,
                valueColor: _statusColorTbu(statusTbu),
              ),
              _divider(),
              _resultLine(
                label: 'STATUS GIZI',
                value: _statusGizi(statusBbtb),
                valueColor: _headlineColor(statusBbtb),
                allowWrap: true,
              ),
              _divider(),

              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SARAN',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _buildSuggestion(statusBbtb, statusTbu),
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Color(0xFF8E6F4D),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              if (!_sudahDisimpan) ...[
                TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    hintText: 'Nama anak (untuk riwayat)',
                    prefixIcon: const Icon(
                      Icons.person_rounded,
                      color: primaryColor,
                    ),
                    filled: true,
                    fillColor: softBg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _simpanRiwayat,
                    icon: const Icon(Icons.save_rounded, size: 24),
                    label: const Text(
                      'SIMPAN RIWAYAT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF36C690),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              if (_sudahDisimpan)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF36C690).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF36C690),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Riwayat sudah disimpan!',
                        style: TextStyle(
                          color: Color(0xFF36C690),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  icon: const Icon(Icons.home_rounded, size: 28),
                  label: const Text(
                    'BERANDA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricMini({
    required IconData icon,
    required String title,
    required String value,
  }) {
    const primaryColor = Color(0xFFC79B6D);
    return Column(
      children: [
        Icon(icon, size: 28, color: primaryColor.withOpacity(0.75)),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _infoLine({
    required IconData icon,
    required String label,
    required String value,
  }) {
    const primaryColor = Color(0xFFC79B6D);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 28, color: primaryColor.withOpacity(0.32)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultLine({
    required String label,
    required String value,
    required Color valueColor,
    bool allowWrap = false,
  }) {
    const primaryColor = Color(0xFFC79B6D);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: allowWrap
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: allowWrap,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: valueColor,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 1.2, color: const Color(0xFFE8D7C2));

  // HEADLINE
  String _headlineStatus(String statusBbtb) {
    final bb = statusBbtb.toLowerCase();
    if (bb.contains('sangat kurus')) return 'Sangat Kurus';
    if (bb.contains('kurus')) return 'Kurus';
    if (bb.contains('normal')) return 'Normal';
    if (bb.contains('gemuk')) return 'Gemuk';
    return 'Perlu Perhatian';
  }

  // BERAT BADAN
  String _statusGiziBerat(String statusBbtb) {
    final bb = statusBbtb.toLowerCase();
    if (bb.contains('sangat kurus')) return 'Gizi Buruk';
    if (bb.contains('kurus')) return 'Gizi Kurang';
    if (bb.contains('normal')) return 'Gizi Baik';
    if (bb.contains('gemuk')) return 'Gizi Lebih';
    return 'Perlu Perhatian';
  }

  // STATUS GIZI
  String _statusGizi(String statusBbtb) {
    final bb = statusBbtb.toLowerCase();
    if (bb.contains('sangat kurus')) return 'Sangat Kurus';
    if (bb.contains('kurus')) return 'Kurus';
    if (bb.contains('normal')) return 'Normal';
    if (bb.contains('gemuk')) return 'Gemuk';
    return 'Perlu Perhatian';
  }

  Color _headlineColor(String statusBbtb) {
    final bb = statusBbtb.toLowerCase();
    if (bb.contains('normal')) return const Color(0xFF36C690);
    if (bb.contains('gemuk') || bb.contains('kurus'))
      return const Color(0xFFFF6B6B);
    return const Color(0xFFFFC857);
  }

  Color _statusColorBbtb(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('normal')) return const Color(0xFF36C690);
    if (lower.contains('gemuk')) return const Color(0xFFFF6B6B);
    if (lower.contains('kurus')) return const Color(0xFFFF6B6B);
    return const Color(0xFFC79B6D);
  }

  Color _statusColorTbu(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('normal') || lower.contains('tinggi'))
      return const Color(0xFF36C690);
    if (lower.contains('pendek')) return const Color(0xFFFF6B6B);
    return const Color(0xFFC79B6D);
  }

  String _buildSuggestion(String statusBbtb, String statusTbu) {
    if (statusBbtb == 'Normal' && statusTbu == 'Normal')
      return 'Anak Anda berkembang dengan baik dalam rentang normal. Pertahankan pola makan bergizi, tidur cukup, dan pantau pertumbuhan secara teratur.';
    if (statusBbtb.contains('Kurus') && statusTbu.contains('Pendek'))
      return 'Anak memerlukan perhatian pada gizi dan pertumbuhan. Tingkatkan kualitas makanan, pantau perkembangan secara rutin, dan konsultasikan ke tenaga kesehatan.';
    if (statusBbtb.contains('Kurus'))
      return 'Anak memerlukan perhatian pada asupan gizi. Tingkatkan kualitas makanan, frekuensi makan, dan pertimbangkan konsultasi dengan tenaga kesehatan.';
    if (statusBbtb == 'Gemuk')
      return 'Perhatikan pola makan dan aktivitas fisik anak. Kurangi makanan tinggi gula dan lemak, serta lakukan pemantauan berat badan secara berkala.';
    if (statusTbu.contains('Pendek'))
      return 'Pertumbuhan tinggi badan anak perlu dipantau lebih lanjut. Pastikan asupan protein cukup, tidur teratur, dan konsultasikan ke tenaga kesehatan bila perlu.';
    if (statusTbu == 'Tinggi')
      return 'Pertumbuhan tinggi anak baik. Tetap pantau pola makan, berat badan, dan perkembangan anak secara berkala.';
    return 'Lakukan pemantauan lanjutan agar pertumbuhan dan status gizi anak tetap terjaga dengan baik.';
  }
}
