using System;
using System.Data;
using MySqlConnector;

namespace eticaretcanta.html
{
    public partial class adminAyarlar : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Database=internetproje;Uid=root;Pwd=;";

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


        protected void btnGuncelle_Click(object sender, EventArgs e)
        {
            int userId = int.Parse(txtUserID.Text);
            bool adminMi = chkAdmin.Checked;

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE users SET yetki = @admin WHERE userID = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@admin", adminMi ? 1 : 0);
                cmd.Parameters.AddWithValue("@id", userId);
                cmd.ExecuteNonQuery();
                lblMesaj.Text = "Yetkiler başarıyla güncellendi.";
            }
        }

        protected void btnMailGuncelle_Click(object sender, EventArgs e)
        {
            string yeniMail = txtYeniMail.Text.Trim();
            string mevcutMail = Session["mail"]?.ToString();

            if (string.IsNullOrEmpty(mevcutMail))
            {
                lblMailDurum.Text = "Oturum geçerli değil.";
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "UPDATE users SET mail = @yeniMail WHERE mail = @eskiMail";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@yeniMail", yeniMail);
                cmd.Parameters.AddWithValue("@eskiMail", mevcutMail);
                int rows = cmd.ExecuteNonQuery();

                if (rows > 0)
                {
                    Session["mail"] = yeniMail;
                    lblMailDurum.Text = "Mail adresi başarıyla güncellendi.";
                }
                else
                {
                    lblMailDurum.Text = "Mail güncellenemedi.";
                }
            }
        }

        protected void btnSifreGuncelle_Click(object sender, EventArgs e)
        {
            string eskiSifre = txtEskiSifre.Text;
            string yeniSifre = txtYeniSifre.Text;
            string yeniSifreTekrar = txtYeniSifreTekrar.Text;
            string email = Session["mail"]?.ToString();

            if (yeniSifre != yeniSifreTekrar)
            {
                lblSifreDurum.Text = "Yeni şifreler uyuşmuyor.";
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string kontrolQuery = "SELECT COUNT(*) FROM users WHERE mail = @eposta AND password = @sifre";
                MySqlCommand kontrolCmd = new MySqlCommand(kontrolQuery, conn);
                kontrolCmd.Parameters.AddWithValue("@eposta", email);
                kontrolCmd.Parameters.AddWithValue("@sifre", eskiSifre);

                int mevcut = Convert.ToInt32(kontrolCmd.ExecuteScalar());

                if (mevcut > 0)
                {
                    string updateQuery = "UPDATE users SET password = @yeniSifre WHERE mail = @eposta";
                    MySqlCommand updateCmd = new MySqlCommand(updateQuery, conn);
                    updateCmd.Parameters.AddWithValue("@yeniSifre", yeniSifre);
                    updateCmd.Parameters.AddWithValue("@eposta", email);
                    updateCmd.ExecuteNonQuery();

                    lblSifreDurum.ForeColor = System.Drawing.Color.Green;
                    lblSifreDurum.Text = "Şifre başarıyla güncellendi.";
                }
                else
                {
                    lblSifreDurum.Text = "Eski şifre yanlış.";
                }
            }
        }
    }
}
