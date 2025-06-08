using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.UI.WebControls;
using MySqlConnector;

namespace eticaretcanta.html
{
    public partial class adminPanel : System.Web.UI.Page
    {
        protected string ToplamSatis { get; set; }
        protected string ToplamSiparisAdet { get; set; }
        protected string AktifKullaniciSayisi { get; set; }

        string connectionString = "Server=localhost;Database=internetproje;Uid=root;Pwd=;"; // Şifreyi Web.config'den okumak daha güvenli olabilir.
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SiparisleriGetir();
                VerileriYukle();
                // Oturum kontrolü
                if (Session["yetki"] == null)
                {
                    Response.Redirect("login.aspx");
                    return;
                }

                string email = Session["mail"].ToString();
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT yetki FROM users WHERE mail = @eposta";
                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@eposta", email);

                    object sonuc = cmd.ExecuteScalar();

                    if (sonuc == null || Convert.ToInt32(sonuc) != 1)
                    {
                        // Yetkisi yok, yönlendir
                        Response.Redirect("homepage.aspx");
                    }
                }
            }
        }

        private void VerileriYukle()
        {
            // Veritabanı bağlantı dizesini Web.config dosyasından al

            using (MySqlConnection baglanti = new MySqlConnection(connectionString))
            {
                try
                {
                    baglanti.Open();

                    // Toplam Satışı Hesapla
                    string toplamSatisSorgusu = "SELECT COALESCE(SUM(ToplamFiyat), 0) FROM siparisler";
                    MySqlCommand toplamSatisKomut = new MySqlCommand(toplamSatisSorgusu, baglanti);
                    ToplamSatis = toplamSatisKomut.ExecuteScalar()?.ToString() ?? "0"; // Null kontrolü

                    // Toplam Sipariş Adedini Hesapla
                    string toplamSiparisSorgusu = "SELECT COUNT(*) FROM siparisler";
                    MySqlCommand toplamSiparisKomutAdet = new MySqlCommand(toplamSiparisSorgusu, baglanti);
                    ToplamSiparisAdet = toplamSiparisKomutAdet.ExecuteScalar()?.ToString() ?? "0"; // Null kontrolü

                    // Aktif Kullanıcı Sayısını Hesapla (Örnek bir sorgu, gerçek tablo ve sütun adlarına göre düzenleyin)
                    string aktifKullaniciSorgusu = "SELECT COUNT(*) FROM users";
                    MySqlCommand aktifKullaniciKomut = new MySqlCommand(aktifKullaniciSorgusu, baglanti);
                    AktifKullaniciSayisi = aktifKullaniciKomut.ExecuteScalar()?.ToString() ?? "0"; // Null kontrolü
                }
                catch (Exception ex)
                {
                    // Hata yönetimi burada yapılabilir. Örneğin loglama veya kullanıcıya mesaj gösterme.
                    Response.Write("Veritabanı hatası: " + ex.Message);
                }
            }
        }

        private void SiparisleriGetir()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = @"SELECT SiparisID, userID, SiparisTarihi, Durum, ToplamFiyat
                         FROM Siparisler
                         ORDER BY SiparisTarihi DESC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);
                    dlSonSiparisler.DataSource = dt;
                    dlSonSiparisler.DataBind();
                }
                catch (Exception ex)
                {
                    Response.Write("Veri çekilirken bir hata oluştu: " + ex.Message);
                }
            }
        }
    }
}
