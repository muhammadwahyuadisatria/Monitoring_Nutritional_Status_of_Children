import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> exportRiwayatToPdf(List<Map<String, dynamic>> riwayat) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => [
        // HEADER
        pw.Center(
          child: pw.Column(
            children: [
              pw.Text(
                'MONAS',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'Monitoring Nutritional Status of Children',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Laporan Riwayat Pemeriksaan Gizi',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Tanggal: ${_formatTanggalHari(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),

        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 10),

        // TABEL
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1.2),
            3: const pw.FlexColumnWidth(1),
            4: const pw.FlexColumnWidth(1),
            5: const pw.FlexColumnWidth(1.5),
            6: const pw.FlexColumnWidth(1),
          },
          children: [
            // HEADER TABEL
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.brown200),
              children: [
                _headerCell('Nama'),
                _headerCell('Usia'),
                _headerCell('Tgl Lahir'),
                _headerCell('Tinggi'),
                _headerCell('Berat'),
                _headerCell('Status Gizi'),
                _headerCell('Metode'),
              ],
            ),
            // DATA
            ...riwayat.map((item) {
              return pw.TableRow(
                children: [
                  _dataCell(item['nama'] ?? '-'),
                  _dataCell('${item['umur_bulan']} bln'),
                  _dataCell(item['tanggal_lahir'] ?? '-'),
                  _dataCell('${item['tinggi']?.toStringAsFixed(1)} cm'),
                  _dataCell('${item['berat']?.toStringAsFixed(1)} kg'),
                  _dataCell(_statusGizi(item['status_bbtb'] ?? '-')),
                  _dataCell(item['metode'] ?? '-'),
                ],
              );
            }),
          ],
        ),

        pw.SizedBox(height: 20),

        // TOTAL DATA
        pw.Text(
          'Total data: ${riwayat.length} pemeriksaan',
          style: const pw.TextStyle(fontSize: 10),
        ),

        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 8),

        pw.Center(
          child: pw.Text(
            '© 2025 MONAS. All rights reserved.',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

pw.Widget _headerCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      textAlign: pw.TextAlign.center,
    ),
  );
}

pw.Widget _dataCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(5),
    child: pw.Text(
      text,
      style: const pw.TextStyle(fontSize: 9),
      textAlign: pw.TextAlign.center,
    ),
  );
}

String _formatTanggalHari(DateTime dt) {
  return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
}

String _statusGizi(String statusBbtb) {
  final bb = statusBbtb.toLowerCase();
  if (bb.contains('normal')) return 'Sehat';
  if (bb.contains('gemuk')) return 'Gemuk';
  if (bb.contains('kurus')) return 'Kurang Gizi';
  return 'Perlu Perhatian';
}
