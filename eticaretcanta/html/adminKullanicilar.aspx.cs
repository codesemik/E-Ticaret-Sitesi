using MySqlConnector;
using System;
using System.Data;
using System.Data.SqlClient;

namespace eticaretcanta.html
{
    public partial class adminKullanicilar : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KullaniciListele();
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

        private void KullaniciListele()
        {
            // MySQL bağlantı stringin (kullanıcı adı ve şifreyi kendine göre ayarla)

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT userID, name, surname, username, mail FROM users";
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);
                    gvKullanicilar.DataSource = dt;
                    gvKullanicilar.DataBind();
                }
                catch (Exception ex)
                {
                    // Hata mesajını yakala ve yönet
                    // Örneğin: litMesaj.Text = "Hata: " + ex.Message;
                }
            }
        }

        protected void btnAra_Click(object sender, EventArgs e)
        {
            string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT userID, name, surname, username, mail FROM users WHERE userID = @userID";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@userID", txtArama.Text.Trim());

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                try
                {
                    conn.Open();
                    da.Fill(dt);
                    gvKullanicilar.DataSource = dt;
                    gvKullanicilar.DataBind();
                }
                catch (Exception ex)
                {
                    // Hata yönetimi (isteğe bağlı: hata mesajını göster)
                }
            }
        }

    }
}