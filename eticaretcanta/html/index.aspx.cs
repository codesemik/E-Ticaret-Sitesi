using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySqlConnector;

namespace eticaretcanta
{
    public partial class index : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Her zaman kategorileri getir ve radio buttonları oluştur

            if (!IsPostBack)
            {
                KategorileriGetir();
                UrunleriGetir(null); // ilk açılışta tüm ürünleri getir
            }
        }

        protected void rblKategoriler_SelectedIndexChanged(object sender, EventArgs e)
        {
            string secilenKategori = rblKategoriler.SelectedValue;
            if (string.IsNullOrEmpty(secilenKategori))
                UrunleriGetir(null); // Tümü seçildi
            else
                UrunleriGetir(secilenKategori);
        }

        private void UrunleriGetir(string kategori)
        {
            string query;

            if (!string.IsNullOrEmpty(kategori))
            {
                query = "SELECT * FROM urunler WHERE kategori = @kategori AND detayvaryok = 1";
            }
            else
            {
                query = "SELECT * FROM urunler WHERE detayvaryok = 1";
            }

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                MySqlCommand cmd = new MySqlCommand(query, conn);
                if (!string.IsNullOrEmpty(kategori))
                    cmd.Parameters.AddWithValue("@kategori", kategori);

                try
                {
                    conn.Open();

                    // using bloğunda data reader'ı düzgün kapatıyoruz
                    using (MySqlDataReader dr = cmd.ExecuteReader())
                    {
                        ProductDataList.DataSource = dr;
                        ProductDataList.DataBind();
                    }

                    // Bu satır hata veriyordu ve gereksizdi, kaldırıldı
                    // if (!string.IsNullOrEmpty(kategori))
                    // {
                    //     rblKategoriler_SelectedIndexChanged();
                    // }
                }
                catch (Exception ex)
                {
                    Response.Write("Veri çekme hatası: " + ex.Message);
                }
            }
        }



        protected void ProductDataList_ItemCommand(object source, DataListCommandEventArgs e)
        {
            if (e.CommandName == "SepeteEkle")
            {
                int urunId = Convert.ToInt32(e.CommandArgument);
                int istenenAdet = Convert.ToInt32(((TextBox)e.Item.FindControl("txtAdet")).Text);

                using (MySqlConnection conn = new MySqlConnection(connStr))
                {
                    conn.Open();
                    string stokQuery = "SELECT adet, urunAdi, fiyat, resimUrl FROM urunler WHERE urunID = @urunId";
                    MySqlCommand stokCmd = new MySqlCommand(stokQuery, conn);
                    stokCmd.Parameters.AddWithValue("@urunId", urunId);

                    using (MySqlDataReader stokReader = stokCmd.ExecuteReader())
                    {
                        if (stokReader.Read())
                        {
                            int mevcutStok = Convert.ToInt32(stokReader["adet"]);
                            string urunAdi = stokReader["urunAdi"].ToString();
                            decimal fiyat = Convert.ToDecimal(stokReader["fiyat"]);
                            string resimUrl = stokReader["resimUrl"].ToString();

                            if (istenenAdet > mevcutStok)
                            {
                                string script = $"<script>alert('{urunAdi} için stok yetersiz. Mevcut stok: {mevcutStok}');</script>";
                                ClientScript.RegisterStartupScript(this.GetType(), "stokUyarisi", script);
                                return;
                            }

                            List<SepetItem> sepet = Session["Sepet"] as List<SepetItem> ?? new List<SepetItem>();

                            SepetItem existingItem = sepet.Find(item => item.UrunID == urunId);
                            if (existingItem != null)
                            {
                                if (existingItem.Adet + istenenAdet > mevcutStok)
                                {
                                    string script = $"<script>alert('{urunAdi} için sepetteki miktarla toplam istek stoğu aşıyor. Mevcut stok: {mevcutStok}');</script>";
                                    ClientScript.RegisterStartupScript(this.GetType(), "stokAsimiUyarisi", script);
                                    return;
                                }
                                existingItem.Adet += istenenAdet;
                                existingItem.toplamFiyat = existingItem.Adet * existingItem.Fiyat;
                            }
                            else
                            {
                                SepetItem yeniUrun = new SepetItem
                                {
                                    UrunID = urunId,
                                    UrunAdi = urunAdi,
                                    Fiyat = fiyat,
                                    ResimUrl = resimUrl,
                                    Adet = istenenAdet,
                                    toplamFiyat = fiyat * istenenAdet
                                };
                                sepet.Add(yeniUrun);
                            }

                            Session["Sepet"] = sepet;
                        }
                    }
                }
            }
        }

        private void KategorileriGetir()
{
    using (MySqlConnection conn = new MySqlConnection(connStr))
    {
        string query = "SELECT kategoriAdi FROM kategoriler ORDER BY kategoriAdi";
        MySqlCommand cmd = new MySqlCommand(query, conn);

        try
        {
            conn.Open();
            using (MySqlDataReader dr = cmd.ExecuteReader())
            {
                rblKategoriler.Items.Clear();
                rblKategoriler.Items.Add(new ListItem("Tümü", "")); // Tümü seçeneği, value boş

                while (dr.Read())
                {
                    string kategoriAdi = dr["kategoriAdi"].ToString();
                    rblKategoriler.Items.Add(new ListItem(kategoriAdi, kategoriAdi));
                }
            }
        }
        catch (Exception ex)
        {
            Response.Write("Kategori çekme hatası: " + ex.Message);
        }
    }
}


        // Dinamik olarak oluşturulan radyo düğmeleri için olay işleyici
        protected void KategoriRadioButton_CheckedChanged(object sender, EventArgs e)
        {
            RadioButton selectedRadio = (RadioButton)sender;
            if (selectedRadio.Checked)
            {
                UrunleriGetir(selectedRadio.Text == "Tümü" ? null : selectedRadio.Text);
            }
        }


    }

    public class SepetItem
    {
        public int UrunID { get; set; }
        public string UrunAdi { get; set; }
        public decimal Fiyat { get; set; }
        public string ResimUrl { get; set; }
        public int Adet { get; set; }
        public decimal toplamFiyat { get; set; }
    }

    public class kullanicilar
    {
        public int name { get; set; }
        public string surname { get; set; }
        public decimal username { get; set; }
        public string mail { get; set; }
        public int password { get; set; }
    }
}
