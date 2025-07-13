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
    futureSurat = suratDao.getAllSurat();
  }

  Future<void> _refreshData() async {
    setState(() {
      futureSurat = suratDao.getAllSurat();
    });
  }

  void _navigateToForm(bool isMasuk) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(isMasuk: isMasuk)),
    );
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DAFTAR NOMOR SURAT'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'masuk') {
                _navigateToForm(true);
              } else {
                _navigateToForm(false);
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'masuk',
                    child: Text('Surat Masuk'),
                  ),
                  const PopupMenuItem(
                    value: 'keluar',
                    child: Text('Surat Keluar'),
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
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final surat = list[index];
                return SuratListTile(surat: surat);
              },
            ),
          );
        },
      ),
    );
  }
}
