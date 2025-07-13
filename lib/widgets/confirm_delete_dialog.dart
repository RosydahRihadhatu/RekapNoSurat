import 'package:flutter/material.dart';

Future<bool?> showConfirmDeleteDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Yakin ingin menghapus surat ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('BATAL'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('HAPUS'),
            ),
          ],
        ),
  );
}
