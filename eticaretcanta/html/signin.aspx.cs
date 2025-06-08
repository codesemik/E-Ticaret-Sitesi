using MySqlConnector;
using System;

namespace eticaretcanta.html
{
    public partial class signin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblHataMesaji.Text = "";
            }
        }

        protected void btnKayitOl_Click(object sender, EventArgs e)
        {
            string ad = txtAd.Text.Trim();
            string soyad = txtSoyad.Text.Trim();
            string kullaniciAdi = txtKullaniciAdi.Text.Trim();
            string email = txtEmail.Text.Trim();
            string sifre = txtSifre.Text.Trim();

            string connectionString = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

            if (string.IsNullOrEmpty(ad) || string.IsNullOrEmpty(soyad) ||
                string.IsNullOrEmpty(kullaniciAdi) || string.IsNullOrEmpty(email) ||
                string.IsNullOrEmpty(sifre))
            {
                string hataMesaji = "Lütfen tüm alanları doldurun!";
                lblHataMesaji.Text = hataMesaji;
                return;
            }

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    // Aynı email varsa uyarı ver
                    string kontrolQuery = "SELECT COUNT(*) FROM users WHERE mail = @Email or username = @username";
                    using (MySqlCommand cmdKontrol = new MySqlCommand(kontrolQuery, conn))
                    {
                        cmdKontrol.Parameters.AddWithValue("@Email", email);
                        cmdKontrol.Parameters.AddWithValue("@username", kullaniciAdi);
                        long count = (long)cmdKontrol.ExecuteScalar();

                        if (count > 0)
                        {
                            lblHataMesaji.Text = "Bu e-posta zaten kayıtlı!";
                            return;
                        }
                    }

                    // Yeni kullanıcıyı ekle
                    string insertQuery = "INSERT INTO users (name, surname, username, mail, password) VALUES (@Ad, @Soyad, @KullaniciAdi, @Email, @Sifre)";
                    using (MySqlCommand cmd = new MySqlCommand(insertQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Ad", ad);
                        cmd.Parameters.AddWithValue("@Soyad", soyad);
                        cmd.Parameters.AddWithValue("@KullaniciAdi", kullaniciAdi);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@Sifre", sifre);

                        cmd.ExecuteNonQuery();
                        Response.Redirect("login.aspx");
                    }
                }
                catch (Exception ex)
                {
                    lblHataMesaji.Text = "Hata oluştu: " + ex.Message;
                }
            }
        }
    }
}
