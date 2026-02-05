import 'package:flutter/material.dart';
import 'package:pem_ble_app/app/app.dart';
import 'package:pem_ble_app/data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  runApp(const PemBleApp());
}