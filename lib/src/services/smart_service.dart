import '../models/kriteria.dart';
import '../models/alternatif.dart';

// Kelas untuk nampung hasil akhir
class HasilPerankingan {
  final Alternatif alternatif;
  final double skor;
  HasilPerankingan({required this.alternatif, required this.skor});
}

// Kelas semua hasil analisis
class HasilAnalisis {
  final Map<String, Map<String, double>> matriksNormalisasi;
  final List<HasilPerankingan> ranking;

  HasilAnalisis({required this.matriksNormalisasi, required this.ranking});
}

class SmartService {
  static HasilAnalisis hitung(
    List<Kriteria> daftarKriteria,
    List<Alternatif> daftarAlternatif,
    Map<String, Map<String, double>> nilai,
  ) {
    if (daftarKriteria.isEmpty || daftarAlternatif.isEmpty) {
      return HasilAnalisis(matriksNormalisasi: {}, ranking: []);
    }

    // 1. Hitung nilai min/max untuk setiap kriteria
    final Map<String, Map<String, double>> minMaxPerKriteria = {};
    for (var kriteria in daftarKriteria) {
      double minVal = double.infinity;
      double maxVal = double.negativeInfinity;
      for (var alternatif in daftarAlternatif) {
        final double val = nilai[alternatif.id]?[kriteria.id] ?? 0.0;
        if (val < minVal) minVal = val;
        if (val > maxVal) maxVal = val;
      }
      minMaxPerKriteria[kriteria.id] = {'min': minVal, 'max': maxVal};
    }

    // 2. Normalisasi
    final Map<String, Map<String, double>> matriksNormalisasi = {};
    for (var alternatif in daftarAlternatif) {
      matriksNormalisasi[alternatif.id] = {};
      for (var kriteria in daftarKriteria) {
        final double val = nilai[alternatif.id]?[kriteria.id] ?? 0.0;
        final minVal = minMaxPerKriteria[kriteria.id]!['min']!;
        final maxVal = minMaxPerKriteria[kriteria.id]!['max']!;
        double nilaiNormal;

        // Hindari pembagian dengan nol jika semua nilai sama
        if (maxVal == minVal) {
          nilaiNormal = 1.0;
        } else {
          if (kriteria.tipe == TipeKriteria.benefit) {
            nilaiNormal = (val - minVal) / (maxVal - minVal);
          } else {
            // Cost
            nilaiNormal = (maxVal - val) / (maxVal - minVal);
          }
        }
        matriksNormalisasi[alternatif.id]![kriteria.id] = nilaiNormal;
      }
    }

    // 3. Hitung Skor Akhir dan Lakukan Perankingan
    final List<HasilPerankingan> scores = [];
    for (var alternatif in daftarAlternatif) {
      double totalScore = 0;
      for (var kriteria in daftarKriteria) {
        final double nilaiNormal =
            matriksNormalisasi[alternatif.id]![kriteria.id]!;
        totalScore += nilaiNormal * kriteria.bobot;
      }
      scores.add(HasilPerankingan(alternatif: alternatif, skor: totalScore));
    }

    // Sortir dari tinggi ke rendah
    scores.sort((a, b) => b.skor.compareTo(a.skor));

    return HasilAnalisis(
        matriksNormalisasi: matriksNormalisasi, ranking: scores);
  }
}
