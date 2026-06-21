import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'loading_screen.dart';
import 'result_screen.dart';

class PhotoInputScreen extends StatefulWidget {
  const PhotoInputScreen({super.key});

  @override
  State<PhotoInputScreen> createState() => _PhotoInputScreenState();
}

class _PhotoInputScreenState extends State<PhotoInputScreen> {
  final TextEditingController tanggalLahirController = TextEditingController();

  String? selectedGender;
  String? fotoDepanPath;
  String? fotoSampingPath;

  File? fotoDepan;
  File? fotoSamping;

  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    tanggalLahirController.dispose();
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

  void _showInfo(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> pickImage(bool isDepan) async {
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isDepan ? 'Foto Depan' : 'Foto Samping'),
        content: const Text('Pilih sumber foto:'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            icon: const Icon(Icons.camera_alt_rounded),
            label: const Text('Kamera'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            icon: const Icon(Icons.photo_library_rounded),
            label: const Text('Galeri'),
          ),
        ],
      ),
    );

    if (source == null) return;

    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        if (isDepan) {
          fotoDepan = File(image.path);
          fotoDepanPath = image.name;
        } else {
          fotoSamping = File(image.path);
          fotoSampingPath = image.name;
        }
      });
    }
  }

  Future<void> _submitPhoto() async {
    if (selectedGender == null) {
      _showInfo('Pilih jenis kelamin dulu');
      return;
    }

    if (tanggalLahirController.text.trim().isEmpty) {
      _showInfo('Isi tanggal lahir dulu');
      return;
    }

    if (fotoDepan == null || fotoSamping == null) {
      _showInfo('Pilih foto depan dan foto samping dulu');
      return;
    }

    final uri = Uri.parse(
      'https://web-production-36628.up.railway.app/predict-photo',
    );

    try {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoadingScreen()),
      );

      final request = http.MultipartRequest('POST', uri);

      request.fields['jenis_kelamin'] = selectedGender!;
      request.fields['tanggal_lahir'] = tanggalLahirController.text.trim();

      request.files.add(
        await http.MultipartFile.fromPath('foto_depan', fotoDepan!.path),
      );

      request.files.add(
        await http.MultipartFile.fromPath('foto_samping', fotoSamping!.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;
      Navigator.pop(context);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['error'] == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(data: data, metode: 'foto'),
          ),
        );
      } else {
        _showInfo(data['error']?.toString() ?? 'Gagal memproses foto');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      _showInfo('Gagal terhubung ke backend: $e');
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
        title: const Text('Input Foto'),
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
                'Metode Foto',
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
                'Foto Depan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _photoPickerCard(
                title: 'Pilih Foto Depan',
                subtitle: fotoDepanPath ?? 'Belum ada file dipilih',
                onTap: () => pickImage(true),
              ),
              const SizedBox(height: 22),
              const Text(
                'Foto Samping',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              _photoPickerCard(
                title: 'Pilih Foto Samping',
                subtitle: fotoSampingPath ?? 'Belum ada file dipilih',
                onTap: () => pickImage(false),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPhoto,
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
                    'Proses Foto',
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
                  'Form foto ini akan mengirim jenis kelamin, tanggal lahir, foto depan, dan foto samping ke backend.',
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

  Widget _photoPickerCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFF6EFE4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.image_rounded, color: Color(0xFFC79B6D), size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFC79B6D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.upload_rounded, color: Color(0xFFC79B6D)),
          ],
        ),
      ),
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
