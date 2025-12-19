import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/controllers/search_controller.dart' as app;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _controller;
  late final app.SearchController searchCtrl;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    searchCtrl = Get.put(app.SearchController());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    searchCtrl.addHistory(value);
    searchCtrl.search(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari barang, kendaraan, dll...',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onChanged: searchCtrl.search,
          onSubmitted: _submit,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              searchCtrl.search('');
            },
          ),
        ],
      ),
      body: Obx(() {
        final hasQuery = _controller.text.trim().isNotEmpty;
        if (!hasQuery) {
          final items = searchCtrl.history;
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada riwayat pencarian'));
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Riwayat', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: searchCtrl.clearHistory,
                      child: const Text('Hapus semua'),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items
                      .map((e) => ActionChip(
                            label: Text(e),
                            onPressed: () {
                              _controller.text = e;
                              _controller.selection = TextSelection.fromPosition(
                                TextPosition(offset: e.length),
                              );
                              searchCtrl.search(e);
                            },
                          ))
                      .toList(),
                ),
              ],
            ),
          );
        }

        final results = searchCtrl.liveResults;
        if (results.isEmpty) {
          return const Center(child: Text('Tidak ada hasil'));
        }
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = results[index];
            return ListTile(
              title: Text(item),
              onTap: () => _submit(item),
            );
          },
        );
      }),
    );
  }
}