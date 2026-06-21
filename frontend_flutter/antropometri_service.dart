class AntropometriService {
  static String classifyTbu({
    required double umurBulan,
    required double tinggi,
    required List<dynamic> data,
  }) {
    dynamic closest;
    double minDiff = double.infinity;

    for (var row in data) {
      final double umurRef = (row['umur_bulan'] as num).toDouble();
      final double diff = (umurRef - umurBulan).abs();

      if (diff < minDiff) {
        minDiff = diff;
        closest = row;
      }
    }

    if (closest == null) return "Tidak diketahui";

    final double minus3 = (closest['minus_3sd'] as num).toDouble();
    final double minus2 = (closest['minus_2sd'] as num).toDouble();
    final double plus2 = (closest['plus_2sd'] as num).toDouble();

    if (tinggi < minus3) return "Sangat Pendek";
    if (tinggi < minus2) return "Pendek";
    if (tinggi > plus2) return "Tinggi";

    return "Normal";
  }

  static String classifyBbtb({
    required double tinggi,
    required double berat,
    required List<dynamic> data,
  }) {
    dynamic closest;
    double minDiff = double.infinity;

    for (var row in data) {
      final double tinggiRef = (row['tinggi_cm'] as num).toDouble();
      final double diff = (tinggiRef - tinggi).abs();

      if (diff < minDiff) {
        minDiff = diff;
        closest = row;
      }
    }

    if (closest == null) return "Tidak diketahui";

    final double minus3 = (closest['minus_3sd'] as num).toDouble();
    final double minus2 = (closest['minus_2sd'] as num).toDouble();
    final double plus2 = (closest['plus_2sd'] as num).toDouble();

    if (berat < minus3) return "Sangat Kurus";
    if (berat < minus2) return "Kurus";
    if (berat > plus2) return "Gemuk";

    return "Normal";
  }
}
