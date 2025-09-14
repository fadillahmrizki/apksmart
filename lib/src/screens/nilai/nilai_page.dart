import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/spk_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/notification_service.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _initializeOrRefreshControllers();
  }

  void _initializeOrRefreshControllers() {
    _controllers.forEach((key, controller) => controller.dispose());
    _controllers = {};

    final provider = Provider.of<SpkProvider>(context, listen: false);
    for (var alternatif in provider.daftarAlternatif) {
      for (var kriteria in provider.daftarKriteria) {
        final key = '${alternatif.id}-${kriteria.id}';
        final nilaiAwal = provider.getNilai(alternatif.id, kriteria.id);
        _controllers[key] =
            TextEditingController(text: nilaiAwal?.toStringAsFixed(0) ?? '');
      }
    }
    if (mounted) setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeOrRefreshControllers();
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  // Simpan nilai
  void _simpanSemuaNilai() {
    final adaInputKosong =
        _controllers.values.any((controller) => controller.text.isEmpty);
    // kondisi pemberitahuan
    if (adaInputKosong) {
      NotificationService.showNotification(
        context,
        message: 'Harap isi semua kolom nilai terlebih dahulu!',
        color: Colors.orange.shade700,
        icon: Icons.warning_amber_rounded,
      );
      return;
    }

    final provider = Provider.of<SpkProvider>(context, listen: false);
    _controllers.forEach((key, controller) {
      final ids = key.split('-');
      final idAlternatif = ids[0];
      final idKriteria = ids[1];
      final nilaiInput = double.tryParse(controller.text) ?? 0.0;
      provider.updateNilai(idAlternatif, idKriteria, nilaiInput);
    });

    provider.submitNilai();

    NotificationService.showNotification(
      context,
      message: 'Semua nilai berhasil disimpan!',
      color: Colors.blue.shade500,
      icon: Icons.check_circle_outline,
    );
  }

  //  Konfirmasi Hapus Semua Nilai
  void _showKonfirmasiHapusNilai(BuildContext context) {
    final provider = Provider.of<SpkProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Semua Nilai?'),
          content: const Text(
              'Apakah Anda yakin ingin mengosongkan semua nilai yang telah diinput?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                provider.clearAllNilai();
                _controllers.forEach((key, controller) {
                  controller.clear();
                });
                NotificationService.showNotification(
                  context,
                  message: 'Semua nilai berhasil dihapus.',
                  color: Colors.greenAccent,
                  icon: Icons.info_outline,
                );
              },
              child:
                  Text('Hapus', style: TextStyle(color: Colors.red.shade700)),
            ),
          ],
        );
      },
    );
  }

  @override
  // UI Halaman kosong
  Widget build(BuildContext context) {
    return Consumer<SpkProvider>(
      builder: (context, provider, child) {
        if (provider.daftarAlternatif.isEmpty ||
            provider.daftarKriteria.isEmpty) {
          return EmptyStateWidget(
            imagePath: 'assets/images/empty_set.png',
            title: 'Input Nilai Belum Siap',
            subtitle:
                'Anda harus memiliki setidaknya satu aspek dan satu pilihan untuk bisa mengisi nilai.',
            buttonText: 'Pergi ke halaman Aspek Penilaian',
            onButtonPressed: () {
              provider.changePage(1);
            },
          );
        }

        // Tampilan tabel modern
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: OutlinedButton.icon(
                icon: Icon(Icons.delete_sweep_outlined,
                    color: Colors.red.shade700),
                label: Text('Hapus Semua Nilai',
                    style: TextStyle(color: Colors.red.shade700)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                  side: BorderSide(color: Colors.red.shade200),
                ),
                onPressed: () => _showKonfirmasiHapusNilai(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      columnWidths: {
                        0: const IntrinsicColumnWidth(flex: 2),
                        for (var i = 1;
                            i <= provider.daftarKriteria.length;
                            i++)
                          i: const IntrinsicColumnWidth(),
                      },
                      border: TableBorder(
                        horizontalInside:
                            BorderSide(width: 1, color: Colors.blue.shade100),
                      ),
                      children: [
                        // Baris Header
                        TableRow(
                          decoration:
                              BoxDecoration(color: Colors.blue.shade500),
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Pilihan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            ...provider.daftarKriteria
                                .map((kriteria) => Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Center(
                                          child: Text(kriteria.nama,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center)),
                                    )),
                          ],
                        ),
                        // Baris Data
                        ...provider.daftarAlternatif
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final alternatif = entry.value;
                          return TableRow(
                            decoration: BoxDecoration(
                                color: index.isEven
                                    ? Colors.white
                                    : Colors.blue.shade50),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 15.0),
                                child: Text(alternatif.nama,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ),
                              ...provider.daftarKriteria.map((kriteria) {
                                final key = '${alternatif.id}-${kriteria.id}';
                                return TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _controllers[key],
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          isDense: true),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Button Save data
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Simpan Nilai'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: _simpanSemuaNilai,
              ),
            ),
          ],
        );
      },
    );
  }
}
