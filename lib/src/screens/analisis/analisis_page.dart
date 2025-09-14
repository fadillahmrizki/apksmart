import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alternatif.dart';
import '../../models/kriteria.dart';
import '../../services/spk_provider.dart';
import '../../services/smart_service.dart';
import '../../widgets/empty_state_widget.dart';

class AnalisisPage extends StatelessWidget {
  const AnalisisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SpkProvider>(
      builder: (context, provider, child) {
        if (provider.daftarKriteria.isEmpty ||
            provider.daftarAlternatif.isEmpty) {
          return EmptyStateWidget(
            imagePath: 'assets/images/empty_set.png',
            title: 'Analisis Belum Tersedia',
            subtitle:
                'Anda perlu menambahkan Aspek Penilaian dan Pilihan untuk melihat hasil.',
            buttonText: 'Tambah Aspek Penilaian',
            onButtonPressed: () => provider.changePage(1),
          );
        }

        if (!provider.apakahHasilTersedia) {
          return EmptyStateWidget(
            imagePath: 'assets/images/empty_set.png',
            title: 'Hasil Belum Siap',
            subtitle:
                'Silakan isi dan tekan "Simpan Nilai" di halaman Input Nilai terlebih dahulu.',
            buttonText: 'Ke Halaman Input Nilai',
            onButtonPressed: () => provider.changePage(3),
          );
        }

        final hasil = SmartService.hitung(
          provider.daftarKriteria,
          provider.daftarAlternatif,
          provider.nilai,
        );

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTabelHasil(
              context,
              judul: 'Ringkasan Penilaian',
              kriteria: provider.daftarKriteria,
              alternatif: provider.daftarAlternatif,
              data: provider.nilai,
              formatAngka: (n) => n.toStringAsFixed(0),
            ),
            const SizedBox(height: 24),
            _buildTabelHasil(
              context,
              judul: 'Adu Nilai',
              kriteria: provider.daftarKriteria,
              alternatif: provider.daftarAlternatif,
              data: hasil.matriksNormalisasi,
              formatAngka: (n) => n.toStringAsFixed(3),
            ),
            const SizedBox(height: 24),
            _buildTabelRanking(context,
                judul: 'Hasil Ranking', ranking: hasil.ranking),
          ],
        );
      },
    );
  }

  Widget _buildTabelHasil(
    BuildContext context, {
    required String judul,
    required List<Kriteria> kriteria,
    required List<Alternatif> alternatif,
    required Map<String, Map<String, double>> data,
    required String Function(double) formatAngka,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder(
                horizontalInside:
                    BorderSide(width: 1, color: Colors.blue.shade100),
              ),
              defaultColumnWidth: const IntrinsicColumnWidth(),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade500),
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Text('Pilihan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                    ...kriteria.map((k) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Center(
                              child: Text(
                            k.nama,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                        )),
                  ],
                ),
                ...alternatif.asMap().entries.map((entry) {
                  final index = entry.key;
                  final a = entry.value;
                  return TableRow(
                    decoration: BoxDecoration(
                        color:
                            index.isEven ? Colors.white : Colors.blue.shade50),
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(a.nama)),
                      ...kriteria.map((k) {
                        final nilai = data[a.id]?[k.id] ?? 0.0;
                        return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(child: Text(formatAngka(nilai))));
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabelRanking(BuildContext context,
      {required String judul, required List<HasilPerankingan> ranking}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Table(
            border: TableBorder(
              horizontalInside:
                  BorderSide(width: 1, color: Colors.blue.shade100),
            ),
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
              2: IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                  decoration: BoxDecoration(color: Colors.blue.shade500),
                  children: const [
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                            child: Text('Urutan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))),
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Pilihan',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Center(
                            child: Text('Nilai Akhir',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))),
                  ]),
              ...ranking.asMap().entries.map((entry) {
                final index = entry.key;
                final hasil = entry.value;
                return TableRow(
                    decoration: BoxDecoration(
                        color:
                            index.isEven ? Colors.white : Colors.blue.shade50),
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(child: Text((index + 1).toString()))),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(hasil.alternatif.nama)),
                      Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                              child: Text(hasil.skor.toStringAsFixed(4)))),
                    ]);
              }),
            ],
          ),
        ),
      ],
    );
  }
}
