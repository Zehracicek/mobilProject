import 'package:flutter/material.dart';

/// Ana uygulama giriş noktası
void main() async {
  // Flutter binding'leri başlat
  WidgetsFlutterBinding.ensureInitialized();
  
  // Uygulamayı çalıştır
  runApp(const MyApp());
}

/// Ana uygulama widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Defteri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // TODO: Kişi 1 - Login ekranını buraya ekleyin
      // TODO: Kişi 4 - Ana sayfayı buraya ekleyin
      home: const PlaceholderScreen(),
    );
  }
}

/// Geçici placeholder ekranı
/// Diğer takım üyeleri kendi ekranlarını ekleyene kadar kullanılacak
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Defteri'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.note_add,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'Servis Katmanı Hazır!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Kişi 3 - Servis İşlemleri Tamamlandı\n\n'
                '✓ Database Helper\n'
                '✓ HTTP Service\n'
                '✓ Note API Service\n'
                '✓ Auth Service\n'
                '✓ Local Storage Service',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
