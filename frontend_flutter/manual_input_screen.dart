import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/data_loader.dart';
import '../services/antropometri_service.dart';
import '../services/manual_gizi_helper.dart';
import 'loading_screen.dart';
import 'result_screen.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();
  final TextEditingController beratController = TextEditingController();

  String? selectedGender;

  @override
  void dispose() {
    tanggalLahirController.dispose();
    tinggiController.dispose();
    beratController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime initialDate = DateTime(now.year - 2, now.month, now.day);

    final currentText = tanggalLahirController.text.trim();
    if (currentText.isNotEmpty) {
      final parts = currentText.split('-');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);

        if (day != null && month != null && year != null) {
          try {
            initialDate = DateTime(year, month, day);
          } catch (_) {}
        }
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2010),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFC79B6D)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      tanggalLahirController.text = '$day-$month-$year';
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC79B6D);
    const softBg = Color(0xFFF6EFE4);
    const pageBg = Color(0xFFF9F6F2);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        title: const Text('Input Manual'),
        centerTitle: true,
        backgroundColor: pageBg,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Mengenai Anak',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Metode Manual (Offline)',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _genderCard(
                    label: 'Pria',
                    value: 'L',
                    icon: Icons.male_rounded,
                    activeBg: const Color(0xFFD8F0FF),
                    activeIcon: const Color(0xFF69BEEB),
                  ),
                  const SizedBox(width: 12),
                  _genderCard(
                    label: 'Wanita',
                    value: 'P',
                    icon: Icons.female_rounded,
                    activeBg: const Color(0xFFFFE2DE),
                    activeIcon: const Color(0xFFF28D87),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const Text(
                'Tanggal Lahir',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tanggalLahirController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                  LengthLimitingTextInputFormatter(10),
                  _DateInputFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'DD-MM-YYYY',
                  prefixIcon: const Icon(
                    Icons.calendar_month_rounded,
                    color: Color(0xFFC79B6D),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _pickDate,
                    icon: const Icon(
                      Icons.date_range_rounded,
                      color: Color(0xFFC79B6D),
                    ),
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
              const SizedBox(height: 22),
              const Text(
                'Tinggi Badan (cm)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _inputField(
                controller: tinggiController,
                hintText: 'Masukkan tinggi badan',
                icon: Icons.height_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Berat Badan (kg)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _inputField(
                controller: beratController,
                hintText: 'Masukkan berat badan',
                icon: Icons.monitor_weight_rounded,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processOffline,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Cek Sekarang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: softBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Mode manual ini berjalan offline. Pastikan data diisi dengan benar agar hasil klasifikasi sesuai.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderCard({
    required String label,
    required String value,
    required IconData icon,
    required Color activeBg,
    required Color activeIcon,
  }) {
    final isSelected = selectedGender == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedGender = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 130,
          decoration: BoxDecoration(
            color: isSelected ? activeBg : const Color(0xFFF6EFE4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? activeIcon.withOpacity(0.35)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 60,
                color: isSelected ? activeIcon : const Color(0xFFBFA180),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected ? activeIcon : const Color(0xFFBFA180),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFFC79B6D)),
        filled: true,
        fillColor: const Color(0xFFF6EFE4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _processOffline() async {
    if (selectedGender == null) {
      _showError('Pilih jenis kelamin dulu');
      return;
    }

    if (tanggalLahirController.text.trim().isEmpty ||
        tinggiController.text.trim().isEmpty ||
        beratController.text.trim().isEmpty) {
      _showError('Semua field harus diisi');
      return;
    }

    final double? tinggi = double.tryParse(
      tinggiController.text.trim().replaceAll(',', '.'),
    );
    final double? berat = double.tryParse(
      beratController.text.trim().replaceAll(',', '.'),
    );

    if (tinggi == null || berat == null) {
      _showError('Tinggi dan berat harus berupa angka');
      return;
    }

    final int? umurBulan = ManualGiziHelper.hitungUmurBulan(
      tanggalLahirController.text.trim(),
    );

    if (umurBulan == null) {
      _showError('Format tanggal lahir harus DD-MM-YYYY');
      return;
    }

    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoadingScreen()),
      );

      final Future<List<dynamic>> tbuFuture = selectedGender == 'L'
          ? DataLoader.loadTbuL()
          : DataLoader.loadTbuP();

      final Future<List<dynamic>> bbtbFuture = umurBulan <= 24
          ? (selectedGender == 'L'
                ? DataLoader.loadBbpbL()
                : DataLoader.loadBbpbP())
          : (selectedGender == 'L'
                ? DataLoader.loadBbtbL()
                : DataLoader.loadBbtbP());

      final results = await Future.wait([
        tbuFuture,
        bbtbFuture,
        Future.delayed(const Duration(milliseconds: 1200)),
      ]);

      final List<dynamic> tbuData = results[0] as List<dynamic>;
      final List<dynamic> bbtbData = results[1] as List<dynamic>;

      final String statusTbu = AntropometriService.classifyTbu(
        umurBulan: umurBulan.toDouble(),
        tinggi: tinggi,
        data: tbuData,
      );

      final String statusBbtb = AntropometriService.classifyBbtb(
        tinggi: tinggi,
        berat: berat,
        data: bbtbData,
      );

      final String kesimpulan = ManualGiziHelper.gabungStatus(
        statusBbtb,
        statusTbu,
      );

      final Map<String, dynamic> resultData = {
        'jenis_kelamin': selectedGender,
        'tanggal_lahir': tanggalLahirController.text.trim(),
        'umur_bulan': umurBulan,
        'tinggi': tinggi,
        'berat': berat,
        'status_bbtb': statusBbtb,
        'status_tbu': statusTbu,
        'kesimpulan': kesimpulan,
      };

      if (!mounted) return;
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(data: resultData, metode: 'manual'),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showError('Gagal memproses data offline: $e');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll('-', '');

    if (digits.length > 8) {
      digits = digits.substring(0, 8);
    }

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if ((i == 1 || i == 3) && i != digits.length - 1) {
        formatted += '-';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
