import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/spk_provider.dart';
import '../../services/smart_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SpkProvider>();

    final hasil = SmartService.hitung(
      provider.daftarKriteria,
      provider.daftarAlternatif,
      provider.nilai,
    );
    final peringkatPertama =
        hasil.ranking.isNotEmpty ? hasil.ranking.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context),
          const SizedBox(height: 16),

          // Card aspek * pilihan
          Row(
            children: [
              Expanded(
                  child: _buildSummaryCard(
                      context,
                      'Aspek Penilaian',
                      '(Kriteria)',
                      provider.daftarKriteria.length.toString(),
                      Icons.library_books_outlined)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildSummaryCard(
                      context,
                      'Pilihan',
                      '(Alternatif)',
                      provider.daftarAlternatif.length.toString(),
                      Icons.emoji_objects_outlined)),
            ],
          ),
          const SizedBox(height: 16),

          _buildPeringkatSatuCard(context, peringkatPertama),
          const SizedBox(height: 24),
          Text('Aksi Cepat',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Input Nilai',
                  Icons.calculate_outlined,
                  () => provider.changePage(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionButton(
                  context,
                  'Hasil Perhitungan',
                  Icons.analytics_outlined,
                  () => provider.changePage(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget bantuan untuk Aksi Cepat
  Widget _buildQuickActionButton(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Card Welcome
  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Selamat Datang di Aplikasi SMART Decision',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  //
  Widget _buildSummaryCard(BuildContext context, String mainTitle,
      String subTitle, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColorDark)),
            const SizedBox(height: 4),
            Column(
              children: [
                Text(mainTitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text(subTitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Card Peringkat #1
  Widget _buildPeringkatSatuCard(
      BuildContext context, HasilPerankingan? peringkatSatu) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 36, color: Colors.lightBlueAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Peringkat #1',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  if (peringkatSatu != null)
                    Text(peringkatSatu.alternatif.nama,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent),
                        overflow: TextOverflow.ellipsis)
                  else
                    Text('Data Masih Kosong',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
