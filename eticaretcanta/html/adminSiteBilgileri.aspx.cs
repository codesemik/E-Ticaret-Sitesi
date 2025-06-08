using System;
using System.IO;
using MySqlConnector;

namespace eticaretcanta.html
{
    public partial class adminSiteBilgileri : System.Web.UI.Page
    {
        // MySQL bağlantı cümlesi
        private string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Sayfa ilk yüklendiğinde verileri getir
                BilgileriGetir();
            }
        }

        // Site bilgilerini veritabanından çekip form alanlarına doldurur
        private void BilgileriGetir()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sorgu = "SELECT * FROM site_bilgileri WHERE id = 1";
                MySqlCommand cmd = new MySqlCommand(sorgu, conn);
                var dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtHakkimizdaBaslik.Text = dr["hakkimizda_baslik"].ToString();
                    txtHakkimizdaYazi.Text = dr["hakkimizda_yazi"].ToString();
                    txtIletisimBaslik.Text = dr["iletisim_baslik"].ToString();
                    txtIletisimAdres.Text = dr["iletisim_adres"].ToString();
                    txtIletisimTelefon.Text = dr["iletisim_telefon"].ToString();
                    txtIletisimEposta.Text = dr["iletisim_eposta"].ToString();
                }
                conn.Close();
            }
        }

        // Güncelle butonuna tıklanınca veritabanını günceller
        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sorgu = @"
                    UPDATE site_bilgileri SET
                        hakkimizda_baslik = @hb,
                        hakkimizda_yazi = @hy,
                        iletisim_baslik = @ib,
                        iletisim_adres = @ia,
                        iletisim_telefon = @it,
                        iletisim_eposta = @ie
                    WHERE id = 1";

                MySqlCommand cmd = new MySqlCommand(sorgu, conn);
                cmd.Parameters.AddWithValue("@hb", txtHakkimizdaBaslik.Text.Trim());
                cmd.Parameters.AddWithValue("@hy", txtHakkimizdaYazi.Text.Trim());
                cmd.Parameters.AddWithValue("@ib", txtIletisimBaslik.Text.Trim());
                cmd.Parameters.AddWithValue("@ia", txtIletisimAdres.Text.Trim());
                cmd.Parameters.AddWithValue("@it", txtIletisimTelefon.Text.Trim());
                cmd.Parameters.AddWithValue("@ie", txtIletisimEposta.Text.Trim());

                int etkilenenSatir = cmd.ExecuteNonQuery();

                if (etkilenenSatir > 0)
                    litGuncellemeMesaji.Text = "<span style='color:green;'>Site bilgileri başarıyla güncellendi.</span>";
                else
                    litGuncellemeMesaji.Text = "<span style='color:red;'>Güncelleme işlemi başarısız oldu.</span>";

                conn.Close();
            }
        }

        // Dosya yükleme butonuna tıklanınca dosya kaydeder
        // Dosya yükleme butonuna tıklanınca dosyayı 'hakkimizda.jpg' olarak kaydeder
        protected void btnYukle_Click(object sender, EventArgs e)
        {
            if (fileUploader.HasFile)
            {
                string dosyaUzantisi = Path.GetExtension(fileUploader.FileName).ToLower();

                string[] izinliUzantilar = { ".jpg" };

                if (Array.IndexOf(izinliUzantilar, dosyaUzantisi) < 0)
                {
                    litMesaj.Text = "<span style='color:red;'>Sadece JPG dosyaları yükleyebilirsiniz.</span>";
                    return;
                }

                // Kaydedilecek dosya adı sabit: hakkimizda + orijinal uzantı
                string sabitDosyaAdi = "hakkimizda" + dosyaUzantisi;
                string kaydetmeYolu = Server.MapPath("~/images/") + sabitDosyaAdi;

                try
                {
                    fileUploader.SaveAs(kaydetmeYolu);
                    litMesaj.Text = "<span style='color:green;'>Dosya başarıyla yüklendi.</span>";
                }
                catch (Exception ex)
                {
                    litMesaj.Text = $"<span style='color:red;'>Dosya yükleme sırasında hata oluştu: {ex.Message}</span>";
                }
            }
            else
            {
                litMesaj.Text = "<span style='color:red;'>Lütfen yüklemek için bir dosya seçin.</span>";
            }
        }

    }
}
