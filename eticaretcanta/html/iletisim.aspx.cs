using MySqlConnector;
using System;
using System.Configuration;
using System.Data.SqlClient;

namespace eticaretcanta
{
    public partial class iletisim : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["name"] != null) // Kullanıcı giriş yapmışsa (örnek bir Session değişkeni)
            {
                // Giriş yapıldığını JavaScript'e bildirecek bir kayıt ekleyebiliriz.
                string script = "var kullaniciGirisYapmis = true;";
                ClientScript.RegisterStartupScript(this.GetType(), "KullaniciGirisDurumu", script, true);
            }
            else
            {
                string script = "var kullaniciGirisYapmis = false;";
                ClientScript.RegisterStartupScript(this.GetType(), "KullaniciGirisDurumu", script, true);
            }
            if (!IsPostBack)
            {
                VerileriGetir();
            }
        }

        private void VerileriGetir()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT iletisim_baslik, iletisim_adres, iletisim_telefon, iletisim_eposta FROM site_bilgileri WHERE id = 1";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                MySqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblBaslik.Text = dr["iletisim_baslik"].ToString();
                    lblAdres.Text = dr["iletisim_adres"].ToString();
                    lblTelefon.Text = dr["iletisim_telefon"].ToString();
                    lblEposta.Text = dr["iletisim_eposta"].ToString();
                }
                conn.Close();
            }
        }

        protected void btnGonder_Click(object sender, EventArgs e)
        {
            string ad = Request.Form["ad"];
            string eposta = Request.Form["eposta"];
            string mesaj = Request.Form["mesaj"];


            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "INSERT INTO iletisim_mesajlari (ad, eposta, mesaj) VALUES (@ad, @eposta, @mesaj)";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ad", ad);
                    cmd.Parameters.AddWithValue("@eposta", eposta);
                    cmd.Parameters.AddWithValue("@mesaj", mesaj);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }

            // Başarılı mesaj göstermek istersen:
            Response.Write("<script>alert('Mesajınız başarıyla gönderildi.');</script>");
        }


    }
}
