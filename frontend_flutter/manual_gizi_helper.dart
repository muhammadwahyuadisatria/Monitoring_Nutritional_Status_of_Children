class ManualGiziHelper {
  static int? hitungUmurBulan(String tanggalLahirStr) {
    try {
      final parts = tanggalLahirStr.split('-');
      if (parts.length != 3) return null;

      final int day = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int year = int.parse(parts[2]);

      final lahir = DateTime(year, month, day);
      final sekarang = DateTime.now();

      int umurBulan =
          (sekarang.year - lahir.year) * 12 + (sekarang.month - lahir.month);

      if (sekarang.day < lahir.day) {
        umurBulan -= 1;
      }

      return umurBulan;
    } catch (_) {
      return null;
    }
  }

  static String gabungStatus(String statusBbtb, String statusTbu) {
    if (statusBbtb == "Normal" && statusTbu == "Normal") {
      return "Kondisi Normal";
    } else if ((statusBbtb == "Kurus" || statusBbtb == "Sangat Kurus") &&
        statusTbu == "Normal") {
      return "Perlu Perhatian Gizi";
    } else if (statusBbtb == "Normal" &&
        (statusTbu == "Pendek" || statusTbu == "Sangat Pendek")) {
      return "Perlu Perhatian Pertumbuhan";
    } else if ((statusBbtb == "Kurus" || statusBbtb == "Sangat Kurus") &&
        (statusTbu == "Pendek" || statusTbu == "Sangat Pendek")) {
      return "Perlu Perhatian Gizi dan Pertumbuhan";
    } else if (statusBbtb == "Gemuk" && statusTbu == "Normal") {
      return "Berat Badan Berlebih";
    } else if (statusBbtb == "Gemuk" &&
        (statusTbu == "Pendek" || statusTbu == "Sangat Pendek")) {
      return "Berat Badan Berlebih dan Pertumbuhan Tidak Optimal";
    } else {
      return "Perlu Pemantauan Lanjutan";
    }
  }
}
