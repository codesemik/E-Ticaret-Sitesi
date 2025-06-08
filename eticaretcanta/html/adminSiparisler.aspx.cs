using MySqlConnector;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eticaretcanta.html
{
	public partial class adminSiparisler : System.Web.UI.Page
	{
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                SiparisleriGetir();

                // Oturum kontrolü
                if (Session["yetki"] == null)
                {
                    Response.Redirect("login.aspx");
                    return;
                }
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
            }
        }

        private void SiparisleriGetir()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT SiparisID, userID, SiparisTarihi, Durum, ToplamFiyat FROM siparisler";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvSiparisler.DataSource = dt;
                gvSiparisler.DataBind();
            }
        }

        protected void btnDurumGuncelle_Click(object sender, EventArgs e)
        {
            string siparisID = txtSiparisID.Text.Trim();
            string yeniDurum = ddlSiparisDurumu.SelectedValue;

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "UPDATE siparisler SET Durum = @durum WHERE SiparisID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@durum", yeniDurum);
                cmd.Parameters.AddWithValue("@id", siparisID);

                conn.Open();
                int sonuc = cmd.ExecuteNonQuery();
                litDurumMesaj.Text = sonuc > 0
                    ? "<span style='color:green;'>Sipariş durumu güncellendi.</span>"
                    : "<span style='color:red;'>Sipariş bulunamadı.</span>";
                SiparisleriGetir();
            }
        }

        protected void btnDetayGoruntule_Click(object sender, EventArgs e)
        {
            string siparisID = txtSiparisIDDetay.Text.Trim();
            if (string.IsNullOrEmpty(siparisID))
            {
                litDetayMesaj.Text = "<span style='color:red;'>Lütfen Sipariş ID giriniz.</span>";
                gvSiparisDetaylari.DataSource = null;
                gvSiparisDetaylari.DataBind();
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT siparisDetayID, siparisID, urunID, adet, fiyat FROM siparis_detaylari WHERE siparisID = @siparisID";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@siparisID", siparisID);
                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    gvSiparisDetaylari.DataSource = dt;
                    gvSiparisDetaylari.DataBind();
                    litDetayMesaj.Text = "";
                }
                else
                {
                    gvSiparisDetaylari.DataSource = null;
                    gvSiparisDetaylari.DataBind();
                    litDetayMesaj.Text = "<span style='color:red;'>Bu ID'ye ait sipariş detayı bulunamadı.</span>";
                }
            }
        }

    }
}