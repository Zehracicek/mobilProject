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
