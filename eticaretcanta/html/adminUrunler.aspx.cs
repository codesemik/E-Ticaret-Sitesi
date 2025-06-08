using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using MySqlConnector;

namespace eticaretcanta.html
{
    public partial class adminUrunler : System.Web.UI.Page
    {
        string connectionString = "Server=localhost;Database=internetproje;Uid=root;Pwd=;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Oturum kontrolü
                if (Session["yetki"] == null)
                {
                    Response.Redirect("login.aspx");
                    return;
                }
                string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

                string email = Session["mail"].ToString();
                using (MySqlConnection conn = new MySqlConnection(connStr))
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
                KategorileriYukle();

            }
        }

        protected void btnUrunEkle_Click(object sender, EventArgs e)
        {
            string urunAdi = txtUrunAdi.Text.Trim();
            int fiyat = int.Parse(txtFiyat.Text.Trim());
            int adet = int.Parse(txtAdet.Text.Trim());
            string kategoriAdi = ddlKategori.SelectedItem.Text;

            string dosyaAdi = "";
            if (fuResim.HasFile)
            {
                string klasorYolu = Server.MapPath("~/images/");
                string uzanti = Path.GetExtension(fuResim.FileName).ToLower();
                int sayac = 0;

                do
                {
                    dosyaAdi = sayac == 0 ? "canta" + uzanti : $"canta{sayac}{uzanti}";
                    sayac++;
                }
                while (File.Exists(Path.Combine(klasorYolu, dosyaAdi)));

                fuResim.SaveAs(Path.Combine(klasorYolu, dosyaAdi));
            }
            else
            {
                litMesaj.Text = "<span style='color:red;'>Lütfen bir resim seçin.</span>";
                return;
            }

            // Veritabanına kayıt
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "INSERT INTO urunler (urunAdi, fiyat, resimUrl, adet, kategori) VALUES (@adi, @fiyat, @resim, @adet, @kategori)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@adi", urunAdi);
                cmd.Parameters.AddWithValue("@fiyat", fiyat);
                cmd.Parameters.AddWithValue("@resim", dosyaAdi);
                cmd.Parameters.AddWithValue("@adet", adet);
                cmd.Parameters.AddWithValue("@kategori", kategoriAdi);
                FormuTemizle();

                conn.Open();
                int sonuc = cmd.ExecuteNonQuery();
                if (sonuc > 0)
                {
                    litMesaj.Text = "<span style='color:green;'>Ürün başarıyla eklendi.</span>";
                }
                else
                {
                    litMesaj.Text = "<span style='color:red;'>Ürün eklenemedi.</span>";
                }
            }
        }

        protected void btnStokGuncelle_Click(object sender, EventArgs e)
        {
            int urunID = int.Parse(txtGuncelleID.Text.Trim());
            int yeniAdet = int.Parse(txtYeniAdet.Text.Trim());

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "UPDATE urunler SET adet = @adet WHERE urunID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@adet", yeniAdet);
                cmd.Parameters.AddWithValue("@id", urunID);
                FormuTemizle();

                conn.Open();
                int sonuc = cmd.ExecuteNonQuery();
                litGuncelleMesaj.Text = sonuc > 0
                    ? "<span style='color:green;'>Stok güncellendi.</span>"
                    : "<span style='color:red;'>Ürün bulunamadı.</span>";
            }
        }

        protected void btnSil_Click(object sender, EventArgs e)
        {
            int urunID = int.Parse(txtSilID.Text.Trim());

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "UPDATE urunler SET adet = 0 WHERE urunID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", urunID);
                FormuTemizle();

                conn.Open();
                int sonuc = cmd.ExecuteNonQuery();
                litSilMesaj.Text = sonuc > 0
                    ? "<span style='color:green;'>Ürün stoğu sıfırlandı.</span>"
                    : "<span style='color:red;'>Ürün bulunamadı.</span>";
            }
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            string aranan = txtAra.Text.Trim();

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "SELECT urunID, urunAdi, fiyat, resimUrl, adet FROM urunler WHERE urunAdi LIKE @aranan";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@aranan", "%" + aranan + "%");

                    MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    gvUrunAra.DataSource = dt;
                    gvUrunAra.DataBind();
                    FormuTemizle();

                }
            }
        }

        private void KategorileriYukle()
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                string query = "SELECT kategoriID, kategoriAdi FROM kategoriler";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                conn.Open();
                using (MySqlDataReader dr = cmd.ExecuteReader())
                {
                    ddlKategori.DataSource = dr;
                    ddlKategori.DataTextField = "kategoriAdi";
                    ddlKategori.DataValueField = "kategoriID";
                    ddlKategori.DataBind();
                }
            }

            ddlKategori.Items.Insert(0, new ListItem("-- Kategori Seçin --", "0"));
        }

        protected void btnDetayEkle_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "INSERT INTO urun_detaylari (urunID, materyal, marka, olcu, cepler, açıklama) VALUES (@urunID, @materyal, @marka, @olcu, @cepler, @aciklama)";
                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@urunID", txtDetayUrunID.Text);
                    cmd.Parameters.AddWithValue("@materyal", txtMateryal.Text);
                    cmd.Parameters.AddWithValue("@marka", txtMarka.Text);
                    cmd.Parameters.AddWithValue("@olcu", txtOlcu.Text);
                    cmd.Parameters.AddWithValue("@cepler", txtCepler.Text);
                    cmd.Parameters.AddWithValue("@aciklama", txtAciklama.Text);

                    int result = cmd.ExecuteNonQuery();

                    if (result > 0)
                    {
                        // Detay başarıyla eklendiyse ürünler tablosunu güncelle
                        string updateQuery = "UPDATE urunler SET detayvaryok = 1 WHERE urunID = @urunID";
                        MySqlCommand updateCmd = new MySqlCommand(updateQuery, conn);
                        updateCmd.Parameters.AddWithValue("@urunID", txtDetayUrunID.Text);
                        updateCmd.ExecuteNonQuery();

                        litDetayMesaj.Text = "<span style='color: green;'>Detay başarıyla eklendi.</span>";
                        FormuTemizle();
                    }
                    else
                    {
                        litDetayMesaj.Text = "<span style='color: red;'>Detay eklenemedi.</span>";
                    }
                }
                catch (Exception ex)
                {
                    litDetayMesaj.Text = "<span style='color: red;'>Hata: " + ex.Message + "</span>";
                }
            }
        }


        protected void btnDetayGuncelle_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string query = "UPDATE urun_detaylari SET materyal=@materyal, marka=@marka, olcu=@olcu, cepler=@cepler, açıklama = @aciklama WHERE detayID=@detayID";
                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@materyal", txtYeniMateryal.Text);
                    cmd.Parameters.AddWithValue("@marka", txtYeniMarka.Text);
                    cmd.Parameters.AddWithValue("@olcu", txtYeniOlcu.Text);
                    cmd.Parameters.AddWithValue("@cepler", txtYeniCepler.Text);
                    cmd.Parameters.AddWithValue("@detayID", txtGuncelleDetayID.Text);
                    cmd.Parameters.AddWithValue("@aciklama", txtYeniAciklama.Text);
                    FormuTemizle();

                    int result = cmd.ExecuteNonQuery();
                    if (result > 0)
                    {
                        litDetayGuncelleMesaj.Text = "<span style='color: green;'>Detay başarıyla güncellendi.</span>";
                    }
                    else
                    {
                        litDetayGuncelleMesaj.Text = "<span style='color: red;'>Detay güncellenemedi.</span>";
                    }
                }
                catch (Exception ex)
                {
                    litDetayGuncelleMesaj.Text = "<span style='color: red;'>Hata: " + ex.Message + "</span>";
                }
            }
        }

        protected void btnDetayBul_Click(object sender, EventArgs e)
        {
            int detayID;
            if (int.TryParse(txtGuncelleDetayID.Text.Trim(), out detayID))
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();
                    string query = "SELECT materyal, marka, olcu, cepler, açıklama FROM urun_detaylari WHERE detayID = @detayID";
                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@detayID", detayID);
                        using (MySqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                // Formu doldur
                                txtGuncelleDetayID.Text = detayID.ToString();
                                txtYeniMateryal.Text = dr["materyal"].ToString();
                                txtYeniMarka.Text = dr["marka"].ToString();
                                txtYeniOlcu.Text = dr["olcu"].ToString();
                                txtYeniCepler.Text = dr["cepler"].ToString();
                                txtYeniAciklama.Text = dr["açıklama"].ToString();
                                litDetayBulMesaj.Text = "<span style='color: green;'>Detay bilgileri yüklendi.</span>";
                            }
                            else
                            {
                                litDetayBulMesaj.Text = "<span style='color: red;'>Belirtilen ID ile detay bulunamadı.</span>";
                            }
                        }
                    }
                }
            }
            else
            {
                litDetayBulMesaj.Text = "<span style='color: red;'>Lütfen geçerli bir Detay ID girin.</span>";
            }
        }

        protected void btnKategoriEkle_Click(object sender, EventArgs e)
        {
            string kategoriAdi = txtKategoriAdi.Text.Trim();

            if (string.IsNullOrEmpty(kategoriAdi))
            {
                litKategoriMesaj.Text = "<span style='color:red;'>Kategori adı boş olamaz.</span>";
                return;
            }

            // Bağlantı dizesi (kendi bağlantı dizesi ile değiştirin)

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();
                    string sql = "INSERT INTO kategoriler (kategoriAdi) VALUES (@kategoriAdi)";
                    using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@kategoriAdi", kategoriAdi);
                        int etkilenensatir = cmd.ExecuteNonQuery();

                        if (etkilenensatir > 0)
                        {
                            litKategoriMesaj.Text = "<span style='color:green;'>Kategori başarıyla eklendi.</span>";
                            txtKategoriAdi.Text = "";
                            // Kategori dropdownlarını yenilemek için metod çağırabilirsiniz
                            DoldurKategoriDropdownlari();
                        }
                        else
                        {
                            litKategoriMesaj.Text = "<span style='color:red;'>Kategori eklenemedi.</span>";
                        }
                    }
                }
                catch (Exception ex)
                {
                    litKategoriMesaj.Text = $"<span style='color:red;'>Hata: {ex.Message}</span>";
                }
            }
        }

        private void DoldurKategoriDropdownlari()
        {

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();
                string sql = "SELECT kategoriID, kategoriAdi FROM kategoriler ORDER BY kategoriAdi";
                using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                {
                    using (MySqlDataReader dr = cmd.ExecuteReader())
                    {
                        List<ListItem> items = new List<ListItem>();
                        while (dr.Read())
                        {
                            items.Add(new ListItem(dr["kategoriAdi"].ToString(), dr["kategoriID"].ToString()));
                        }

                        // Örneğin ddlKategori ve diğer kategori dropdownlarınız varsa hepsine doldurun
                        ddlKategori.Items.Clear();
                        ddlKategori.Items.AddRange(items.ToArray());

                        // GridView içindeki dropdown doldurma işlemi için de benzer şekilde yapabilirsiniz
                    }
                }
            }
        }


        private void FormuTemizle()
        {
            // Ürün ekleme alanları
            txtUrunAdi.Text = "";
            txtFiyat.Text = "";
            txtAdet.Text = "";
            ddlKategori.SelectedIndex = 0;
            fuResim.Attributes.Clear();

            // Stok güncelleme alanları
            txtGuncelleID.Text = "";
            txtYeniAdet.Text = "";

            // Silme alanı
            txtSilID.Text = "";

            // Ürün arama
            txtAra.Text = "";

            // Detay ekleme alanları
            txtDetayUrunID.Text = "";
            txtMateryal.Text = "";
            txtMarka.Text = "";
            txtOlcu.Text = "";
            txtCepler.Text = "";
            txtAciklama.Text = "";

            // Detay güncelleme alanları (bul hariç)
            // NOT: txtGuncelleDetayID temizlenmez çünkü 'bul' sonrası güncelleme yapılabiliyor
            txtYeniMateryal.Text = "";
            txtYeniMarka.Text = "";
            txtYeniOlcu.Text = "";
            txtYeniCepler.Text = "";
            txtYeniAciklama.Text = "";
        }
    }
}
