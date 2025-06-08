using System;
using System.Data;
using MySqlConnector;
namespace eticaretcanta.html
{
    public partial class kullaniciSiparisler : System.Web.UI.Page
    {
        string connStr = "server=localhost;user=root;database=internetproje;port=3306;password=;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Kullanıcı giriş yapmış mı kontrol et
                if (Session["userID"] != null)
                {
                    int userId = Convert.ToInt32(Session["userID"]);
                    SiparisleriGetir(userId);
                }
                else
                {
                    // Giriş yapılmamışsa login sayfasına yönlendir
                    Response.Redirect("login.aspx");
                }
            }
        }

        private void SiparisleriGetir(int userId)
        {

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {

                try
                {
                    conn.Open();

                    string query = @"SELECT SiparisID, SiparisTarihi, Durum, ToplamFiyat FROM siparisler WHERE userID = @userID ORDER BY SiparisTarihi DESC";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@userID", userId);

                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);

                            gvSiparisler.DataSource = dt;
                            gvSiparisler.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Hataları yakala ve ekrana yaz (geliştirme aşamasında)
                    Response.Write("<script>alert('Veri çekme hatası: " + ex.Message + "');</script>");
                }

            }
        }

        protected void gvSiparisler_SelectedIndexChanged(object sender, EventArgs e)
        {
            int siparisID = Convert.ToInt32(gvSiparisler.SelectedDataKey.Value);
            SiparisDetaylariniGetir(siparisID);
        }

        private void SiparisDetaylariniGetir(int siparisID)
        {
            string connStr = "server=localhost;user=root;database=internetproje;port=3306;password=;";
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                try
                {
                    conn.Open();
                    string query = @"
                SELECT 
                    urunler.resimUrl, urunler.urunAdi, siparis_detaylari.adet, siparis_detaylari.fiyat
                FROM 
                    siparis_detaylari
                INNER JOIN urunler ON urunler.urunID = siparis_detaylari.urunID
                WHERE 
                    siparis_detaylari.siparisID = @siparisID";

                    using (MySqlCommand cmd = new MySqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@siparisID", siparisID);

                        using (MySqlDataAdapter adapter = new MySqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            adapter.Fill(dt);
                            gvSiparisDetaylari.DataSource = dt;
                            gvSiparisDetaylari.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("Detay hata: " + ex.Message);
                }
            }
        }

    }
}
