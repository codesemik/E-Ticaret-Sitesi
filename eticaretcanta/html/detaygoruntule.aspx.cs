using System;
using MySqlConnector;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace eticaretcanta
{
    public partial class detaygoruntule : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string urunID = Request.QueryString["urunID"];
                if (!string.IsNullOrEmpty(urunID))
                {
                    Session["SecilenUrunID"] = urunID;
                    UrunDetayGetir(Convert.ToInt32(urunID));
                    UrunDetaylariGetir(Convert.ToInt32(urunID));
                }
                else
                {
                    Response.Redirect("index.aspx");
                }
            }
        }

        private void UrunDetayGetir(int urunID)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string sql = @"SELECT urunAdi, fiyat, kategori, adet, resimUrl 
                       FROM urunler 
                       WHERE urunID = @urunID";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@urunID", urunID);
                conn.Open();

                using (MySqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        lblUrunAdi.Text = dr["urunAdi"].ToString();
                        lblFiyat.Text = dr["fiyat"].ToString() + " ₺";
                        lblKategori.Text = dr["kategori"].ToString();
                        int stokSayisi = Convert.ToInt32(dr["adet"]); // ya da veritabanındaki stok sütunu

                        if (stokSayisi > 3)
                        {
                            lblAdet.Text = "Var";
                        }
                        else if(stokSayisi == 0)
                        {
                            lblAdet.Text = "Yok";
                        }
                        else
                        {
                            lblAdet.Text = "Son " + stokSayisi.ToString();
                        }


                        string resimAdi = dr["resimUrl"].ToString(); // Örnek: "canta1.jpg"
                        string tamYol = string.IsNullOrEmpty(resimAdi) ? "~/images/no-image.png" : "~/images/" + resimAdi;
                        imgUrun.ImageUrl = tamYol;

                    }
                }
            }
        }

        private void UrunDetaylariGetir(int urunID)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string sql = @"SELECT materyal, marka, olcu, cepler, açıklama 
                       FROM urun_detaylari 
                       WHERE urunID = @urunID";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@urunID", urunID);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    lblAciklama.Text = dt.Rows[0]["açıklama"].ToString();
                }
                else
                {
                    lblAciklama.Text = "Açıklama bulunamadı.";
                }

                gvUrunOzellikler.DataSource = dt;
                gvUrunOzellikler.DataBind();
            }
        }



        protected void btnSepeteEkle_Click(object sender, EventArgs e)
        {
            if (Session["SecilenUrunID"] == null)
                return;

            int urunId = Convert.ToInt32(Session["SecilenUrunID"]);
            int istenenAdet = 1; // Burada dilersen adet textbox ekleyip alabilirsin.

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
                        int fiyat = Convert.ToInt32(stokReader["fiyat"]);
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
                        string alertScript = $"<script>alert('{urunAdi} sepete eklendi.');</script>";
                        ClientScript.RegisterStartupScript(this.GetType(), "sepeteEklendi", alertScript);
                    }
                }
            }
        }
    }
}
