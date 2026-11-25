# E-Ticaret Web Uygulaması (Çanta Mağazası)

ASP.NET Web Forms ve C# kullanılarak geliştirilmiş, müşteri vitrini ve yönetim (admin) paneli modüllerini içeren uçtan uca bir e-ticaret web uygulamasıdır.

## Özellikler

### Kullanıcı (Müşteri) Modülü
* **Kayıt & Giriş:** Yeni kullanıcı kaydı (`signin.aspx`), oturum açma (`login.aspx`) ve çıkış (`cikis.aspx`) işlemleri
* **Ürün Vitrini & Detay:** Ana sayfa ürün listeleme (`index.aspx`, `homepage.aspx`) ve ürün detay görüntüleme (`detaygoruntule.aspx`)
* **Sepet & Sipariş Takibi:** Dinamik alışveriş sepeti yönetimi (`sepet.aspx`) ve geçmiş siparişleri görüntüleme (`kullaniciSiparisler.aspx`)
* **Hesap & İletişim:** Kullanıcı profil/ayar yönetimi (`kullaniciAyarlar.aspx`), kurumsal sayfalar (`hakkimizda.aspx`, `iletisim.aspx`)

### Yönetim (Admin) Paneli
* **Dashboard:** Genel yönetim paneli (`adminPanel.aspx`)
* **Ürün Yönetimi:** Ürün ekleme, güncelleme ve silme işlemleri (`adminUrunler.aspx`)
* **Sipariş & Kullanıcı Yönetimi:** Gelen siparişlerin takibi (`adminSiparisler.aspx`) ve kayıtlı kullanıcıların yönetimi (`adminKullanicilar.aspx`)
* **Site & Geri Bildirim Yönetimi:** Site genel bilgileri (`adminSiteBilgileri.aspx`), sistem ayarları (`adminAyarlar.aspx`) ve müşteri şikayet/öneri takibi (`adminSikayetOneri.aspx`)

## Kullanılan Teknolojiler
* **Backend:** C#, ASP.NET Web Forms (.NET Framework)
* **Frontend:** HTML5, CSS3, JavaScript
* **Veritabanı:** İlişkisel Veritabanı (SQL Server / MySQL)

## Kurulum ve Çalıştırma
1. Repoyu bilgisayarınıza klonlayın:
   ```bash
   git clone https://github.com/codesemik/E-Ticaret-Sitesi.git
   ```
2. `eticaretcanta.sln` dosyasını Visual Studio ile açın.
3. `Web.config` dosyasındaki veritabanı bağlantı dizesini (`connectionStrings`) kendi yerel ayarlarınıza göre güncelleyin.
4. Eksik NuGet paketlerini Visual Studio üzerinden geri yükleyin (`Restore NuGet Packages`).
5. Başlangıç sayfası olarak `eticaretcanta/html/index.aspx` dosyasını seçip projeyi çalıştırın (`F5`).
