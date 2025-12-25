Proje Yapısı
Uygulama: Basit bir Not Defteri Uygulaması (Todo/Note App)
Takım Dağılımı:
1. Kişi 1 - Authentication (Giriş İşlemleri)

feature/auth branch
Login ekranı
Register ekranı
Şifre doğrulama
Oturum yönetimi (SharedPreferences)

2. Kişi 2 - CRUD İşlemleri

feature/crud branch
Not ekleme (Create)
Not okuma (Read)
Not güncelleme (Update)
Not silme (Delete)
SQLite veritabanı entegrasyonu

3. Kişi 3 - Servis İşlemleri

feature/services branch
API servisleri (HTTP istekleri)
Database helper servisleri
Auth service (giriş/çıkış mantığı)
Local storage service

4. Kişi 4 - UI/UX ve Ana Yapı

feature/ui branch
Ana sayfa tasarımı
Drawer/Navigation
Widget'lar (custom button, card vb.)
Theme ayarları

---

## Provider + SharedPreferences ile Basit Not Uygulaması (CRUD)

Bu projede örnek olarak `Note` modeli ve `NoteService` (Provider kullanan) eklendi. Veriler veritabanı yerine `SharedPreferences` içinde JSON olarak saklanır.

### Gerekli paketler (pubspec.yaml altında `dependencies`):

```
provider: ^6.0.0
shared_preferences: ^2.0.0
```

### Nasıl çalıştırılır

1. `pubspec.yaml` dosyanıza üstteki paketleri ekleyin ve `flutter pub get` çalıştırın.
2. Uygulamayı çalıştırın: `flutter run` veya VS Code/Android Studio içinde Run.
3. Uygulama başlarken `NoteService` `SharedPreferences`'tan notları yükler ve her CRUD işleminde otomatik kaydeder.

---

Not: `Note` modelinde `id`, `baslik`, `icerik`, `olusturmaTarihi` bulunur; `toJson` ve `fromJson` metodları ile serileştirme yapılır.
