import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_routes.dart';
import 'providers/auth_provider.dart';
import 'providers/note_provider.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth Provider - Auth ekibi bu provider'ı geliştirecek
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Note Provider - CRUD ekibi bu provider'ı geliştirecek
        ChangeNotifierProvider(create: (_) => NoteProvider()),

        // Services ekibi: Diğer provider'lar buraya eklenebilir
        // Örnek: ApiProvider, ThemeProvider vb.
      ],
      child: MaterialApp.router(
        title: 'Not Defterim',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
