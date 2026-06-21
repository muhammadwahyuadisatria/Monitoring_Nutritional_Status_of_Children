import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/pdf_export.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _riwayat = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    final data = await DatabaseHelper.instance.getAllRiwayat();
    setState(() {
      _riwayat = data;
      _isLoading = false;
    });
  }

  Future<void> _hapusRiwayat(int id) async {
    await DatabaseHelper.instance.deleteRiwayat(id);
    _loadRiwayat();
  }

  void _konfirmasiHapus(int id, String nama) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: Text('Hapus riwayat pemeriksaan $nama?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _hapusRiwayat(id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('normal')) return const Color(0xFF36C690);
    if (s.contains('kurus') || s.contains('pendek') || s.contains('gemuk')) {
      return const Color(0xFFFF6B6B);
    }
    return const Color(0xFFFFC857);
  }

  String _formatTanggal(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    } catch (_) {
      return iso;
    }
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
          'Riwayat Pemeriksaan',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_riwayat.isNotEmpty)
            IconButton(
              onPressed: () async {
                await exportRiwayatToPdf(_riwayat);
              },
              icon: const Icon(Icons.picture_as_pdf_rounded),
              color: const Color(0xFFC79B6D),
              tooltip: 'Export PDF',
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _riwayat.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 80,
                      color: Color(0xFFD9C5B0),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Belum ada riwayat',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFBFA180),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Simpan hasil pemeriksaan\nuntuk melihat riwayat',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFFBFA180)),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadRiwayat,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _riwayat.length,
                  itemBuilder: (context, index) {
                    final item = _riwayat[index];
                    final statusBbtb = item['status_bbtb'] ?? '-';
                    final statusTbu = item['status_tbu'] ?? '-';
                    final metode = item['metode'] ?? 'manual';
                    final tinggi = item['tinggi']?.toStringAsFixed(1) ?? '-';
                    final berat = item['berat']?.toStringAsFixed(1) ?? '-';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: softBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['nama'] ?? '-',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: metode == 'foto'
                                      ? const Color(
                                          0xFF69BEEB,
                                        ).withOpacity(0.15)
                                      : const Color(
                                          0xFF36C690,
                                        ).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  metode == 'foto' ? '📷 Foto' : '✏️ Manual',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: metode == 'foto'
                                        ? const Color(0xFF69BEEB)
                                        : const Color(0xFF36C690),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _konfirmasiHapus(
                                  item['id'],
                                  item['nama'] ?? '',
                                ),
                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Color(0xFFFF6B6B),
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Diperiksa: ${_formatTanggal(item['tanggal_periksa'] ?? '')}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black45,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _infoChip(Icons.height_rounded, '$tinggi cm'),
                              const SizedBox(width: 8),
                              _infoChip(
                                Icons.monitor_weight_rounded,
                                '$berat kg',
                              ),
                              const SizedBox(width: 8),
                              _infoChip(
                                Icons.access_time_rounded,
                                '${item['umur_bulan']} bln',
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _statusChip(
                                'BB: $statusBbtb',
                                _statusColor(statusBbtb),
                              ),
                              const SizedBox(width: 8),
                              _statusChip(
                                'TB: $statusTbu',
                                _statusColor(statusTbu),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFFC79B6D)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC79B6D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
