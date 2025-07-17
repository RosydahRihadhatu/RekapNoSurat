import 'package:flutter/material.dart';
import '../models/surat_model.dart';
import '../database/surat_dao.dart';
import '../screens/form_screen.dart';
import '../widgets/surat_list_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SuratDao suratDao = SuratDao();
  late Future<List<SuratModel>> futureSurat;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureSurat = suratDao.getAllSurat();
    });
  }

  void _navigateToForm(bool isMasuk) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(isMasuk: isMasuk)),
    );

    if (result == true && mounted) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR NOMOR SURAT'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            onSelected: (value) {
              _navigateToForm(value == 'masuk');
            },
            itemBuilder:
                (_) => const [
                  PopupMenuItem(
                    value: 'masuk',
                    child: Text('Tambah Surat Masuk'),
                  ),
                  PopupMenuItem(
                    value: 'keluar',
                    child: Text('Tambah Surat Keluar'),
                  ),
                ],
          ),
        ],
      ),
      body: FutureBuilder<List<SuratModel>>(
        future: futureSurat,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data surat'));
          }

          final list = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final surat = list[index];
                return SuratListTile(
                  surat: surat,
                  onRefresh:
                      _refreshData, // agar bisa refresh setelah edit/hapus
                );
              },
            ),
          );
        },
      ),
    );
  }
}
