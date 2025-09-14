import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/alternatif.dart';
import '../../services/spk_provider.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/notification_service.dart';

class AlternatifPage extends StatelessWidget {
  const AlternatifPage({super.key});

  void _tampilkanDialogForm(BuildContext context, SpkProvider provider,
      {Alternatif? alternatif}) {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: alternatif?.nama ?? '');

    // Form tambah/edit
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alternatif == null ? 'Tambah Pilihan' : 'Edit Pilihan'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: namaController,
            decoration: const InputDecoration(
                labelText: 'Nama Pilihan', border: OutlineInputBorder()),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Nama tidak boleh kosong'
                : null,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                provider.addOrUpdateAlternatif(
                  id: alternatif?.id,
                  nama: namaController.text,
                );
                Navigator.of(context).pop();
              }
            },
            child: Text(alternatif == null ? 'Tambah' : 'Update'),
          ),
        ],
      ),
    );
  }

  // Form hapus data
  void _showKonfirmasiHapusSemua(BuildContext context) {
    final provider = Provider.of<SpkProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Pilihan?'),
        content: const Text(
            'Semua pilihan dan nilai yang terkait akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              provider.clearAllAlternatif();
              NotificationService.showNotification(
                context,
                message: 'Semua pilihan berhasil dihapus.',
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

  // Halaman Kosong
  @override
  Widget build(BuildContext context) {
    return Consumer<SpkProvider>(
      builder: (context, provider, child) {
        if (provider.daftarAlternatif.isEmpty) {
          return EmptyStateWidget(
            imagePath: 'assets/images/empty_set.png',
            title: 'Belum Ada Pilihan',
            subtitle:
                'Silakan tambahkan beberapa pilihan atau opsi yang akan dinilai.',
            buttonText: 'Tambah Pilihan Pertama',
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
                // Text('Daftar Pilihan',
                //     style: Theme.of(context)
                //         .textTheme
                //         .titleLarge
                //         ?.copyWith(fontWeight: FontWeight.bold)),
                // const Divider(height: 24),

                // Form konfirm hapus data
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.daftarAlternatif.length,
                    itemBuilder: (context, index) {
                      final alternatif = provider.daftarAlternatif[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: const Icon(Icons.lightbulb_outline),
                          ),
                          title: Text(alternatif.nama,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit_note,
                                    color: Colors.blue.shade700),
                                onPressed: () => _tampilkanDialogForm(
                                    context, provider,
                                    alternatif: alternatif),
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
                                            'Apakah Anda yakin ingin menghapus pilihan "${alternatif.nama}"?'),
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
                                              provider.deleteAlternatif(
                                                  alternatif.id);
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
