import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/log_service.dart';

class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  
  RxBool get loading => isLoading;

  Future<T?> runAsync<T>(
    Future<T> Function() function, {
    String loadingMessage = 'Memuat...',
    Duration timeout = const Duration(seconds: 10),
    bool showLoading = true,
    T? defaultValue,
  }) async {
    if (showLoading) isLoading.value = true;
    try {
      LogService.info(runtimeType.toString(), 'Starting operation...');
      
      final result = await function().timeout(
        timeout,
        onTimeout: () {
          throw TimeoutException('Koneksi internet lambat atau tidak stabil');
        },
      );
      
      LogService.info(runtimeType.toString(), 'Operation success');
      return result;
    } catch (e, stack) {
      LogService.error(runtimeType.toString(), 'Operation failed', e, stack);
      _handleError(e);
      return defaultValue;
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  void _handleError(dynamic e) {
    String message = 'Terjadi kesalahan tidak dikenal';
    if (e is TimeoutException) {
      message = 'Koneksi internet terlalu lambat. Coba lagi.';
    } else {
      message = e.toString();
      if (message.contains('permission-denied')) {
        message = 'Akses ditolak. Periksa aturan database Anda.';
      } else if (message.contains('unavailable')) {
        message = 'Layanan sedang tidak tersedia (Offline).';
      }
    }

    if (Get.context != null) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}