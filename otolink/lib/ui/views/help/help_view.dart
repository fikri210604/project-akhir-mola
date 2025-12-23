import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2C6C),
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bagaimana kami bisa membantu?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2C6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Temukan jawaban atas pertanyaan umum atau hubungi tim support kami.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text("FAQ (Pertanyaan Umum)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildExpansionTile(
              "Bagaimana cara membeli mobil?",
              "Pilih mobil yang Anda inginkan, klik tombol 'Chat Penjual' untuk berdiskusi, dan lakukan kesepakatan harga serta metode pembayaran langsung dengan penjual."
            ),
            _buildExpansionTile(
              "Apakah transaksi di aplikasi ini aman?",
              "Kami menyarankan untuk selalu melakukan pertemuan langsung (COD) di tempat aman dan mengecek kondisi kendaraan sebelum melakukan pembayaran."
            ),
            _buildExpansionTile(
              "Bagaimana cara posting iklan?",
              "Masuk ke menu 'Produk Saya' atau klik tombol (+) di halaman utama, isi detail kendaraan, unggah foto, dan klik 'Simpan'."
            ),
            _buildExpansionTile(
              "Lupa kata sandi akun?",
              "Silakan pergi ke halaman Login dan klik 'Lupa Password' atau hubungi admin jika Anda mengalami kendala akses."
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2C6C).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0A2C6C).withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.headset_mic, size: 48, color: Color(0xFF0A2C6C)),
                  const SizedBox(height: 16),
                  const Text(
                    "Masih butuh bantuan?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tim support kami siap membantu Anda 24/7.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar("Info", "Menghubungkan ke WhatsApp Support...", backgroundColor: Colors.green, colorText: Colors.white);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A2C6C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Hubungi Kami"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildExpansionTile(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
        ),
        iconColor: const Color(0xFF0A2C6C),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}