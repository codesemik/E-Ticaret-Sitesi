using MySqlConnector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace eticaretcanta
{
    public partial class sepet : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SepetiYukle();
                ToplamFiyatiGuncelle();
            }
        }

        private void SepetiYukle()
        {
            List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];
            decimal toplamSepetFiyati = 0;

            if (sepet != null && sepet.Count > 0)
            {
                foreach (var item in sepet)
                {
                    item.toplamFiyat = item.Adet * item.Fiyat;
                    toplamSepetFiyati += item.toplamFiyat; // Toplamı hesapla
                }

                SepetGridView.DataSource = sepet;
                SepetGridView.DataBind();

                // Toplam fiyatı Literal kontrolüne yazdır
                ToplamFiyatLiteral.Text = toplamSepetFiyati.ToString("C");
            }
            else
            {
                // Sepet boşsa
                SepetGridView.DataSource = null;
                SepetGridView.DataBind();
                ToplamFiyatLiteral.Text = "0.00 TL"; // veya uygun bir mesaj
            }
        }

        protected void SepetGridView_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // Silinecek ürünün ID'sini DataKeys koleksiyonundan alıyoruz.
            int urunId = Convert.ToInt32(SepetGridView.DataKeys[e.RowIndex].Value);

            // Session'dan sepet listesini alıyoruz.
            List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];

            if (sepet != null)
            {
                // Silinecek ürünü listeden buluyoruz.
                SepetItem silinecekItem = sepet.FirstOrDefault(item => item.UrunID == urunId);

                if (silinecekItem != null)
                {
                    if (silinecekItem.Adet > 1)
                    {
                        // Adet 1'den fazlaysa sadece 1 azalt
                        silinecekItem.Adet--;
                        silinecekItem.toplamFiyat = silinecekItem.Adet * silinecekItem.Fiyat;
                    }
                    else
                    {
                        // Adet 1 ise ürünü tamamen sil
                        sepet.Remove(silinecekItem);
                    }

                    // Güncellenmiş sepet listesini Session'a geri kaydediyoruz.
                    Session["Sepet"] = sepet;

                    // GridView'i yeniden yüklüyoruz ki değişiklikler görünsün.
                    SepetiYukle();
                }
            }
        }

        protected void BtnSatınAl_Click(object sender, EventArgs e)
        {
            // Kullanıcı e-postasını Session'dan al
            string kullaniciEmail = Session["mail"] as string;
            if (string.IsNullOrEmpty(kullaniciEmail))
            {
                string script = "<script type=\"text/javascript\">alert('Lütfen giriş yapın!');</script>";
                ClientScript.RegisterStartupScript(this.GetType(), "alert", script);
                return; // Satın alma işlemini durdur
            }

            int userID = 0; // Başlangıç değeri
            string connectionString = "Server=localhost;Port=3306;Database=internetproje;Uid=root;"; //veritabanı bağlantı stringi

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                // Kullanıcı ID'sini almak için sorgu
                string userIdQuery = "SELECT userID FROM users WHERE mail = @email";
                MySqlCommand userIdCmd = new MySqlCommand(userIdQuery, conn);
                userIdCmd.Parameters.AddWithValue("@email", kullaniciEmail);

                object result = userIdCmd.ExecuteScalar(); // Tek bir değer al
                if (result != null)
                {
                    userID = Convert.ToInt32(result); // userID'yi al
                }
                else
                {
                    string script = "<script type=\"text/javascript\">alert('Kullanıcı bulunamadı!');</script>";
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", script);
                    return; // Satın alma işlemini durdur.  Kullanıcı bulunamazsa hata ver.
                }
            }

            List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];
            if (sepet != null && sepet.Count > 0)
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    MySqlCommand cmd = conn.CreateCommand();
                    MySqlTransaction transaction = conn.BeginTransaction(); // İşlem başlat

                    try
                    {
                        decimal toplamSiparisFiyati = 0;
                        // Yeni sipariş oluştur ve sipariş ID'sini al
                        string siparisEkleQuery = "INSERT INTO siparisler (userID, SiparisTarihi, Durum, ToplamFiyat) VALUES (@userID, @siparisTarihi, @durum, @toplamFiyat); SELECT LAST_INSERT_ID();";
                        MySqlCommand siparisEkleCmd = new MySqlCommand(siparisEkleQuery, conn, transaction);
                        siparisEkleCmd.Parameters.AddWithValue("@userID", userID);
                        siparisEkleCmd.Parameters.AddWithValue("@siparisTarihi", DateTime.Now);
                        siparisEkleCmd.Parameters.AddWithValue("@durum", "Beklemede");
                        siparisEkleCmd.Parameters.AddWithValue("@toplamFiyat", toplamSiparisFiyati);

                        int siparisID = Convert.ToInt32(siparisEkleCmd.ExecuteScalar()); // Sipariş ID'sini al

                        foreach (var item in sepet)
                        {
                            toplamSiparisFiyati += item.toplamFiyat;

                            // Sipariş detaylarını kaydet
                            string siparisDetayEkleQuery = "INSERT INTO siparis_detaylari (siparisID, urunID, adet, fiyat) VALUES (@siparisID, @urunID, @adet, @fiyat)";
                            MySqlCommand siparisDetayEkleCmd = new MySqlCommand(siparisDetayEkleQuery, conn, transaction);
                            siparisDetayEkleCmd.Parameters.AddWithValue("@siparisID", siparisID);
                            siparisDetayEkleCmd.Parameters.AddWithValue("@urunID", item.UrunID);
                            siparisDetayEkleCmd.Parameters.AddWithValue("@adet", item.Adet);
                            siparisDetayEkleCmd.Parameters.AddWithValue("@fiyat", item.Fiyat); // Ürün fiyatını ekle
                            siparisDetayEkleCmd.ExecuteNonQuery();

                            // Stok güncelleme
                            string stokGuncelleQuery = "UPDATE urunler SET adet = adet - @adet WHERE urunID = @urunId";
                            MySqlCommand stokGuncelleCmd = new MySqlCommand(stokGuncelleQuery, conn, transaction);
                            stokGuncelleCmd.Parameters.AddWithValue("@adet", item.Adet);
                            stokGuncelleCmd.Parameters.AddWithValue("@urunId", item.UrunID);
                            stokGuncelleCmd.ExecuteNonQuery();

                            // Popülerlik artırma
                            string populerlikArtirQuery = "UPDATE urunler SET populerlik = populerlik + @adet WHERE urunID = @urunId";
                            MySqlCommand populerlikArtirCmd = new MySqlCommand(populerlikArtirQuery, conn, transaction);
                            populerlikArtirCmd.Parameters.AddWithValue("@adet", item.Adet);
                            populerlikArtirCmd.Parameters.AddWithValue("@urunId", item.UrunID);
                            populerlikArtirCmd.ExecuteNonQuery();
                        }
                        //toplam fiyatı güncelle
                        string guncelleSiparisToplamFiyatQuery = "UPDATE siparisler SET ToplamFiyat = @toplamFiyat WHERE siparisID = @siparisID";
                        MySqlCommand guncelleSiparisToplamFiyatCmd = new MySqlCommand(guncelleSiparisToplamFiyatQuery, conn, transaction);
                        guncelleSiparisToplamFiyatCmd.Parameters.AddWithValue("@toplamFiyat", toplamSiparisFiyati);
                        guncelleSiparisToplamFiyatCmd.Parameters.AddWithValue("@siparisID", siparisID);
                        guncelleSiparisToplamFiyatCmd.ExecuteNonQuery();

                        transaction.Commit(); // İşlemi onayla

                        // Başarılı mesaj
                        string script = "<script type=\"text/javascript\">alert('Siparişiniz başarıyla alınmıştır!');</script>";
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", script);

                        Session.Remove("Sepet"); // Sepeti temizle
                        SepetiYukle(); // GridView'i güncelle
                        ToplamFiyatiGuncelle();
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback(); // Hata durumunda geri al
                        Response.Write("Hata: " + ex.Message);
                    }
                }
            }
            else
            {
                string script = "<script type=\"text/javascript\">alert('Sepetinizde ürün bulunmamaktadır!');</script>";
                ClientScript.RegisterStartupScript(this.GetType(), "alert", script);
            }
        }

        protected void SepetGridView_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Arttir")
            {
                // ... (Mevcut Arttir butonu kodunuz)
                int index = Convert.ToInt32(e.CommandArgument);
                int urunId = Convert.ToInt32(SepetGridView.DataKeys[index].Value);
                List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];

                if (sepet != null)
                {
                    SepetItem mevcutUrun = sepet.FirstOrDefault(item => item.UrunID == urunId);
                    if (mevcutUrun != null)
                    {
                        string connectionString = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";
                        using (MySqlConnection conn = new MySqlConnection(connectionString))
                        {
                            conn.Open();
                            string stokQuery = "SELECT adet, urunAdi FROM urunler WHERE urunID = @urunId";
                            MySqlCommand stokCmd = new MySqlCommand(stokQuery, conn);
                            stokCmd.Parameters.AddWithValue("@urunId", urunId);

                            using (MySqlDataReader stokReader = stokCmd.ExecuteReader())
                            {
                                if (stokReader.Read())
                                {
                                    int mevcutStok = Convert.ToInt32(stokReader["adet"]);
                                    string urunAdi = stokReader["urunAdi"].ToString();

                                    if (mevcutUrun.Adet + 1 > mevcutStok)
                                    {
                                        string script = $"<script type=\"text/javascript\">alert('{urunAdi} için stokta yeterli ürün bulunmamaktadır. Mevcut stok: {mevcutStok}, Sepetteki adet: {mevcutUrun.Adet}');</script>";
                                        ClientScript.RegisterStartupScript(this.GetType(), "adetArttirmaStokUyarisi", script);
                                        return;
                                    }

                                    mevcutUrun.Adet++;
                                    Session["Sepet"] = sepet;
                                    SepetiYukle();
                                    ToplamFiyatiGuncelle();
                                }
                            }
                        }
                    }
                }
            }
            else if (e.CommandName == "Azalt") // Yeni Azalt butonu işlevi
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int urunId = Convert.ToInt32(SepetGridView.DataKeys[index].Value);
                List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];

                if (sepet != null)
                {
                    SepetItem mevcutUrun = sepet.FirstOrDefault(item => item.UrunID == urunId);
                    if (mevcutUrun != null)
                    {
                        if (mevcutUrun.Adet > 1)
                        {
                            mevcutUrun.Adet--;
                            Session["Sepet"] = sepet;
                            SepetiYukle();
                            ToplamFiyatiGuncelle();
                        }
                        else
                        {
                            // Adet 1 ise ürünü sepetten çıkar
                            sepet.Remove(mevcutUrun);
                            Session["Sepet"] = sepet;
                            SepetiYukle();
                            ToplamFiyatiGuncelle();
                        }
                    }
                }
            }
        }

        // Sepet verilerini GridView'a bağlayan metot (eğer henüz yoksa)
        private void BindSepet()
        {
            if (Session["Sepet"] != null)
            {
                SepetGridView.DataSource = (List<SepetItem>)Session["Sepet"];
                SepetGridView.DataBind();
            }
            else
            {
                SepetGridView.DataSource = null;
                SepetGridView.DataBind();
            }
        }

        // Toplam fiyatı hesaplayıp Literal kontrolüne yazdıran metot (eğer henüz yoksa)
        private void ToplamFiyatiGuncelle()
        {
            if (Session["Sepet"] != null)
            {
                List<SepetItem> sepet = (List<SepetItem>)Session["Sepet"];
                decimal toplamFiyat = sepet.Sum(item => item.toplamFiyat); // Doğrudan toplamFiyat özelliğini kullan
                ToplamFiyatLiteral.Text = toplamFiyat.ToString("C");
            }
            else
            {
                ToplamFiyatLiteral.Text = "0.00 TL";
            }
        }
    }
}