using MySqlConnector;
using System;
using System.Web;

namespace eticaretcanta.html
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Sayfa ilk kez yüklendiğinde mesaj gizlenir
            if (!IsPostBack)
            {
                Label2.Text = "";
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            string kullaniciAdi = txtEmail.Text.Trim();
            string sifre = txtSifre.Text.Trim();
            string girisHataMesaji = "";

            string connectionString = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                try
                {
                    conn.Open();

                    string sorguquery = "Select * from users where username = @username and password = @sifre";
                    using (MySqlCommand cmd = new MySqlCommand(sorguquery, conn))
                    {
                        cmd.Parameters.AddWithValue("@username", kullaniciAdi);
                        cmd.Parameters.AddWithValue("@Sifre", sifre);
  
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                Session["userID"] = reader["userID"].ToString();
                                Session["name"] = reader["name"].ToString();
                                Session["username"] = kullaniciAdi;
                                Session["surname"] = reader["surname"].ToString();
                                Session["mail"] = reader["mail"].ToString();
                                Session["yetki"] = reader["yetki"].ToString();
                                Response.Redirect("index.aspx");
                            }
                            else
                            {
                                girisHataMesaji = "Kullanıcı adı veya şifre hatalı!";
                            }
                        }
                    }
                }
                catch (MySqlException ex)
                {
                    girisHataMesaji = "Veritabanı hatası: " + ex.Message;
                }
            }

            if (!string.IsNullOrEmpty(girisHataMesaji))
            {
                Label2.Text = girisHataMesaji;
            }
        }
    }
}
