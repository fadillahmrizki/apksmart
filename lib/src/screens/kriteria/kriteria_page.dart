import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/kriteria.dart';
import '../../services/spk_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/notification_service.dart';

class KriteriaPage extends StatelessWidget {
  const KriteriaPage({super.key});

  void _tampilkanDialogForm(BuildContext context, SpkProvider provider,
      {Kriteria? kriteria}) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: kriteria?.nama ?? '');
    final bobotController =
        TextEditingController(text: kriteria?.bobot.toString() ?? '');
    var selectedTipe = kriteria?.tipe ?? TipeKriteria.benefit;

    // Form tambah/edit
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(kriteria == null ? 'Tambah Aspek' : 'Edit Aspek Penilaian'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                      labelText: 'Nama', border: OutlineInputBorder()),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Nama tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, setDialogState) {
                    return DropdownButtonFormField<TipeKriteria>(
                      value: selectedTipe,
                      decoration: const InputDecoration(
                          labelText: 'Jenis', border: OutlineInputBorder()),
                      items: TipeKriteria.values
                          .map((tipe) => DropdownMenuItem(
                              value: tipe,
                              child: Text(
                                  tipe.toString().split('.').last == 'benefit'
                                      ? 'Benefit'
                                      : 'Cost')))
                          .toList(),
                      onChanged: (value) =>
                          setDialogState(() => selectedTipe = value!),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: bobotController,
                  decoration: const InputDecoration(
                      labelText: 'Nilai (0-1)', border: OutlineInputBorder()),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tingkat kepentingan tidak boleh kosong';
                    }
                    final n = double.tryParse(value);
                    if (n == null) return 'Silakan masukkan angka yang valid';
                    if (n < 0 || n > 1) return 'Nilai harus antara 0 dan 1';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.addOrUpdateKriteria(
                  id: kriteria?.id,
                  nama: namaController.text,
                  tipe: selectedTipe,
                  bobot: double.parse(bobotController.text),
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(kriteria == null ? 'Tambah' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Konfirmasi hapus
  void _showKonfirmasiHapusSemua(BuildContext context) {
    final provider = Provider.of<SpkProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Aspek Penilaian?'),
        content: const Text(
            'Semua aspek penilaian dan nilai yang terkait akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.clearAllKriteria();
              NotificationService.showNotification(
                context,
                message: 'Semua aspek penilaian berhasil dihapus.',
                color: Colors.green.shade700,
                icon: Icons.info_outline,
              );
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red.shade700)),
          ),
        ],
      ),
    );
  }

  @override
  // UI Halaman kosong
  Widget build(BuildContext context) {
    return Consumer<SpkProvider>(
      builder: (context, provider, child) {
        if (provider.daftarKriteria.isEmpty) {
          return EmptyStateWidget(
            imagePath: 'assets/images/empty_set.png',
            title: 'Belum Ada Aspek Penilaian',
            subtitle: 'Silakan tambah aspek penilaian untuk memulai.',
            buttonText: 'Tambah Aspek Pertama',
            icon: Icons.add_circle_outline,
            onButtonPressed: () => _tampilkanDialogForm(context, provider),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Baru'),
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () =>
                            _tampilkanDialogForm(context, provider),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.delete_sweep_outlined,
                            color: Colors.red.shade700),
                        label: Text('Hapus Semua',
                            style: TextStyle(color: Colors.red.shade700)),
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: Colors.red.shade200)),
                        onPressed: () => _showKonfirmasiHapusSemua(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Text('Daftar Aspek Penilaian',
                //     style: Theme.of(context)
                //         .textTheme
                //         .titleLarge
                //         ?.copyWith(fontWeight: FontWeight.bold)),
                // const Divider(height: 24),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.daftarKriteria.length,
                    itemBuilder: (context, index) {
                      final kriteria = provider.daftarKriteria[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(kriteria.nama,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Tipe: ${kriteria.tipeToString} | Bobot: ${kriteria.bobot}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_note,
                                    color: Colors.blue.shade700),
                                onPressed: () => _tampilkanDialogForm(
                                    context, provider,
                                    kriteria: kriteria),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.red.shade700),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Apakah Anda yakin ingin menghapus aspek penilaian "${kriteria.nama}"?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Batal'),
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Hapus',
                                                style: TextStyle(
                                                    color:
                                                        Colors.red.shade700)),
                                            onPressed: () {
                                              provider
                                                  .deleteKriteria(kriteria.id);
                                              Navigator.of(dialogContext).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
