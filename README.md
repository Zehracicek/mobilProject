# Not Defteri Uygulaması - Takım Geliştirme Kılavuzu

## 📋 Proje Genel Bakış
Bu proje, Flutter kullanılarak geliştirilen bir not defteri uygulamasıdır. Takım halinde çalışmak için modüler bir yapı oluşturulmuştur.

## 👥 Takım Dağılımı ve Sorumluluklar

### 🔐 Kişi 1 - Authentication (Auth Ekibi)
**Branch:** `feature/auth`
**Sorumluluk Alanları:**
- Login/Register sayfaları (temel yapı hazır)
- Şifre doğrulama ve sıfırlama
- Oturum yönetimi (SharedPreferences)
- AuthProvider implementasyonu

**Çalışacağın Dosyalar:**
- `lib/providers/auth_provider.dart` - Ana auth logic'i burada implement et
- `lib/screens/login_page.dart` - Login fonksiyonlarını tamamla
- `lib/screens/register_page.dart` - Register fonksiyonlarını tamamla
- `lib/services/local_storage_service.dart` - Auth token yönetimi için kullan

**Yapman Gerekenler:**
1. `AuthProvider` sınıfındaki TODO'ları tamamla
2. Login/Register API çağrılarını implement et
3. Token yönetimi ve oturum kontrolü
4. Şifre sıfırlama fonksiyonu
5. Otomatik login kontrolü (app açıldığında)

---

### 📝 Kişi 2 - CRUD İşlemleri (CRUD Ekibi)
**Branch:** `feature/crud`
**Sorumluluk Alanları:**
- Not ekleme, okuma, güncelleme, silme
- SQLite veritabanı entegrasyonu
- NoteProvider implementasyonu
- Not detay ve düzenleme sayfaları

**Çalışacağın Dosyalar:**
- `lib/providers/note_provider.dart` - CRUD operasyonlarını implement et
- `lib/services/database_helper.dart` - SQLite işlemlerini tamamla
- `lib/models/note.dart` - Model sınıfı hazır
- Yeni sayfalar: `add_note_page.dart`, `edit_note_page.dart`, `note_detail_page.dart`

**Yapman Gerekenler:**
1. `NoteProvider` sınıfındaki TODO'ları tamamla
2. SQLite database helper'ı implement et
3. Not ekleme sayfası oluştur
4. Not düzenleme sayfası oluştur
5. Not detay sayfası oluştur
6. Arama ve filtreleme fonksiyonları

---

### 🌐 Kişi 3 - Servis İşlemleri (Services Ekibi)
**Branch:** `feature/services`
**Sorumluluk Alanları:**
- API servisleri (HTTP istekleri)
- Database helper servisleri
- Auth service (giriş/çıkış mantığı)
- Local storage service

**Çalışacağın Dosyalar:**
- `lib/services/api_service.dart` - API çağrılarını implement et
- `lib/services/database_helper.dart` - CRUD ekibi ile koordineli çalış
- `lib/services/local_storage_service.dart` - Tamamla ve optimize et

**Yapman Gerekenler:**
1. API endpoints'lerini implement et
2. HTTP error handling
3. Network connectivity kontrolü
4. Data synchronization logic
5. Cache management
6. Background sync işlemleri

---

### 🎨 Kişi 4 - UI/UX ve Ana Yapı (UI Ekibi) - SEN
**Branch:** `feature/ui` 
**Sorumluluk Alanları:** ✅ TAMAMLANDI
- Ana sayfa tasarımı ✅
- Drawer/Navigation ✅
- Widget'lar (custom button, card vb.) ✅
- Theme ayarları ✅
- Routing yapısı ✅

## 🚀 Nasıl Başlarsın?

### 1. Projeyi Clone Et
```bash
git clone https://github.com/Zehracicek/mobilProject.git
cd mobilProject
```

### 2. Kendi Branch'ini Oluştur
```bash
git checkout -b feature/[senin-alan]
# Örnek: git checkout -b feature/auth
```

### 3. Paketleri Yükle
```bash
flutter pub get
```

### 4. Projeyi Çalıştır
```bash
flutter run
```

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart          # ✅ Tema ayarları
│   └── routing/
│       └── app_routes.dart         # ✅ Routing yapısı
├── models/
│   ├── note.dart                   # ✅ Not modeli
│   ├── user.dart                   # ✅ Kullanıcı modeli
│   └── category.dart               # ✅ Kategori modeli
├── providers/
│   ├── auth_provider.dart          # 🔄 Auth ekibi tamamlayacak
│   └── note_provider.dart          # 🔄 CRUD ekibi tamamlayacak
├── services/
│   ├── api_service.dart            # 🔄 Services ekibi tamamlayacak
│   ├── database_helper.dart        # 🔄 Services/CRUD ekibi koordineli
│   └── local_storage_service.dart  # 🔄 Services ekibi tamamlayacak
├── screens/
│   ├── login_page.dart             # ✅ Auth ekibi fonksiyonları ekleyecek
│   ├── register_page.dart          # ✅ Auth ekibi fonksiyonları ekleyecek
│   └── home_page.dart              # ✅ UI tamamlandı
└── widgets/
    ├── custom_button.dart          # ✅ Hazır widget
    ├── custom_text_field.dart      # ✅ Hazır widget
    └── note_card.dart              # ✅ Hazır widget
```

## 🔧 Kullanılan Teknolojiler

- **Flutter**: UI Framework
- **Provider**: State Management
- **GoRouter**: Navigation
- **SQLite**: Local Database
- **SharedPreferences**: Local Storage
- **HTTP**: API Çağrıları
- **Google Fonts**: Typography

## 📦 Önemli Paketler

```yaml
dependencies:
  provider: ^6.1.2          # State management
  go_router: ^14.2.0        # Routing
  shared_preferences: ^2.2.2 # Local storage
  sqflite: ^2.3.0          # SQLite database
  http: ^1.2.0             # HTTP requests
  google_fonts: ^6.2.1     # Fonts
  intl: ^0.19.0            # Date formatting
```

## 🎯 Mevcut Özellikler (Hazır)

### ✅ UI/UX Tamamlandı
- Modern ve responsive tasarım
- Material Design 3 uyumlu tema
- Custom widget'lar (Button, TextField, NoteCard)
- Ana sayfa layout'u
- Navigation drawer
- Routing sistemi

### ✅ Modeller Hazır
- Note model (JSON/Map dönüştürme ile)
- User model (Auth için hazır)
- Category model (Varsayılan kategoriler ile)

### 🔄 Yapılacaklar

#### Auth Ekibi İçin:
```dart
// lib/providers/auth_provider.dart içinde
Future<bool> login(String email, String password) async {
  // TODO: API çağrısı yap
  // TODO: Token'ı kaydet
  // TODO: User bilgilerini set et
}
```

#### CRUD Ekibi İçin:
```dart
// lib/providers/note_provider.dart içinde
Future<bool> addNote(Note note) async {
  // TODO: SQLite'a kaydet
  // TODO: UI'ı güncelle
}
```

#### Services Ekibi İçin:
```dart
// lib/services/api_service.dart içinde
static Future<Map<String, dynamic>> login(String email, String password) async {
  // TODO: HTTP POST request
  // TODO: Response handling
}
```

## 🤝 Takım Çalışması İpuçları

### Git Workflow
1. **Her zaman kendi branch'inden çalış**
2. **Düzenli commit at**
3. **Açıklayıcı commit mesajları yaz**
4. **Pull request açmadan önce test et**

### Kod Standartları
- Türkçe comment'ler kullan
- Anlamlı değişken isimleri
- TODO comment'leri bırak
- Code review için PR aç

### Koordinasyon
- **Auth + Services**: Token yönetimi için koordineli çalışın
- **CRUD + Services**: Database işlemleri için koordineli çalışın
- **Herkes + UI**: Widget'ları kullanırken feedback verin

## 📞 İletişim ve Yardım

### Ortak Kullanılan Yapılar
Tüm ekipler bu hazır yapıları kullanabilir:

#### Widgets
```dart
// Custom Button kullanımı
CustomButton(
  text: 'Kaydet',
  onPressed: () => {},
  isLoading: false,
  icon: Icons.save,
)

// Custom TextField kullanımı  
CustomTextField(
  labelText: 'Email',
  controller: emailController,
  validator: (value) => value?.isEmpty ?? true ? 'Gerekli' : null,
)
```

#### Navigation
```dart
// Sayfa geçişleri
context.go('/home');
context.go('/register');
```

#### State Management
```dart
// Provider kullanımı
final authProvider = Provider.of<AuthProvider>(context);
final noteProvider = Provider.of<NoteProvider>(context, listen: false);
```

## 🎉 Başarı Kriterleri

### ✅ Auth Ekibi Tamamlandığında:
- [x] Kullanıcı giriş yapabiliyor
- [x] Kullanıcı kayıt olabiliyor  
- [x] Oturum yönetimi çalışıyor
- [x] Şifre sıfırlama çalışıyor

### ✅ CRUD Ekibi Tamamlandığında:
- [x] Not ekleme çalışıyor
- [x] Notlar listeleniyor
- [x] Not düzenleme çalışıyor
- [x] Not silme çalışıyor
- [x] Arama/filtreleme çalışıyor

### ✅ Services Ekibi Tamamlandığında:
- [x] API çağrıları çalışıyor
- [x] Database işlemleri stabil
- [x] Senkronizasyon çalışıyor
- [x] Offline çalışabiliyor

## 🐛 Debug ve Test

```bash
# Debug modda çalıştırma
flutter run --debug

# Release modda test
flutter run --release

# Test çalıştırma
flutter test
```

## 📱 Örnek Ekran Görüntüleri

Hazır olan sayfalar:
- ✅ Login Sayfası
- ✅ Register Sayfası  
- ✅ Ana Sayfa (Home)
- ✅ Navigation Drawer

Eklenmesi gereken sayfalar:
- 🔄 Not Detay Sayfası
- 🔄 Not Ekleme Sayfası
- 🔄 Not Düzenleme Sayfası
- 🔄 Ayarlar Sayfası

---

**Happy Coding! 🚀**

Bu yapı ile her ekip kendi alanında rahatça çalışabilir ve projede sıkıntı yaşamaz. Sorularınız için ekip arkadaşlarınızla koordine olun!
