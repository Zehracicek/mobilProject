# 🏢 AssetHub: Microservices Asset & Support System

![Microservices](https://img.shields.io/badge/Architecture-Microservices-blueviolet)
![Team](https://img.shields.io/badge/Team-4%20Contributors-orange)
![Status](https://img.shields.io/badge/Status-In%20Development-green)

## 📖 Proje Hakkında

**AssetHub**, şirket içi IT varlıklarını (laptop, telefon, monitör vb.) yönetmek ve bu varlıklarla ilgili teknik destek taleplerini takip etmek için tasarlanmış **mikroservis tabanlı** bir yönetim sistemidir.

Bu proje, **Monolitik** yapıdan kaçınarak, modern yazılım dünyasının standardı olan **Microservices** mimarisini simüle etmek amacıyla geliştirilmiştir. 4 kişilik bir geliştirme ekibinin, birbirinin kodunu ezmeden, bağımsız servisler üzerinde çalışarak bütünü oluşturduğu bir eğitim ve uygulama projesidir.

## 🏗️ Mimari Yapı (Local Microservices)

Proje tek bir devasa uygulama yerine, belirli sorumlulukları olan ve HTTP (REST) üzerinden haberleşen 4 farklı servisten oluşur.

* **Bağımsızlık:** Her servis kendi veritabanına (veya şemasına) ve kendi portuna sahiptir.
* **İletişim:** Servisler birbirleriyle REST API istekleri aracılığıyla konuşur.
* **Ölçeklenebilirlik:** İleride sadece "Ticket Service" yoğunluk yaşarsa, sadece o servisi çoğaltmak mümkündür.

## 👥 Ekip ve İş Bölümü (4 Kişilik Yapı)

Her ekip üyesi bir servisin "Owner"ı (Sahibi) konumundadır.

| Rol | Sorumlu | Servis / Katman | Görev Tanımı |
| :--- | :--- | :--- | :--- |
| **Backend (Core)** | `Üye 1` | **Auth Service** | Kullanıcı yönetimi, JWT Token üretimi, Security konfigürasyonları ve Gateway mantığı. |
| **Backend (Inventory)**| `Üye 2` | **Inventory Service** | Demirbaşların (Asset) eklenmesi, zimmetlenmesi ve stok takibi. |
| **Backend (Ops)** | `Üye 3` | **Ticket Service** | Arıza kayıtlarının açılması, durum güncellemeleri (Açık/Çözüldü) ve iş mantığı. |
| **Frontend Lead** | `Üye 4` | **Web UI** | Tüm servislerden gelen verileri birleştiren React/Vue arayüzü. UX/UI tasarımı. |

## 🔌 Servis Haritası ve Portlar

Tüm servisler `localhost` üzerinde aşağıdaki portlarda çalışır:

| Servis Adı | Port | Açıklama | Örnek Endpoint |
| :--- | :--- | :--- | :--- |
| **Auth Service** | `:8081` | Kimlik Doğrulama | `POST /api/auth/login` |
| **Inventory Service**| `:8082` | Varlık Yönetimi | `POST /api/items` (Yeni Laptop Ekle) |
| **Ticket Service** | `:8083` | Destek Talepleri | `GET /api/tickets` (Talepleri Listele) |
| **Notification S.** | `:8084` | Loglama & Bildirim | `POST /api/logs` (Arka plan işlemi) |

## 🛠️ Kullanılan Teknolojiler (Tech Stack)

* **Backend:** Java (Spring Boot) / .NET Core / Node.js (Servis bazlı değişebilir)
* **Frontend:** React.js / Vue.js
* **Veritabanı:** PostgreSQL (Her servis için ayrı database/schema önerilir)
* **İletişim:** RESTful API (HTTP)
* **Güvenlik:** JWT (JSON Web Token)

## 🚀 Senaryo ve Akış Örneği

1.  **Login:** Kullanıcı Frontend üzerinden giriş yapar. İstek **Auth Service (8081)**'e gider, geçerli ise bir `JWT Token` döner.
2.  **Zimmetleme:** Admin, "Yeni MacBook Pro" ekler. İstek **Inventory Service (8082)**'e gider.
3.  **Talep:** Kullanıcı "Bilgisayarım açılmıyor" diye talep açar. İstek **Ticket Service (8083)**'e gider.
4.  **Log:** Ticket servisi, talep oluştuğunda arka planda **Notification Service (8084)**'e "Mail atıldı varsay" isteği gönderir.

## ⚙️ Kurulum (Local Development)

Projeyi ayağa kaldırmak için her servisi ayrı ayrı çalıştırmanız gerekmektedir.

1.  Veritabanınızı oluşturun (PostgreSQL).
2.  `auth-service` klasörüne gidip uygulamayı başlatın (Port 8081).
3.  `inventory-service` klasörüne gidip uygulamayı başlatın (Port 8082).
4.  `ticket-service` klasörüne gidip uygulamayı başlatın (Port 8083).
5.  `frontend` klasöründe `npm start` ile arayüzü başlatın.

---
*Geliştirici Notu: Bu proje, mikroservis mimarisinin temel prensiplerini (Separation of Concerns, API Communication) öğrenmek amacıyla tasarlanmıştır.*
