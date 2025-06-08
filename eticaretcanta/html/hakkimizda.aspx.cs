using System;
using System.Configuration;
using MySqlConnector;

namespace eticaretcanta
{
    public partial class hakkimizda : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAboutInfo();
                imgHakkimizda.ImageUrl = ResolveUrl("~/images/hakkimizda.jpg");

            }
        }

        private void LoadAboutInfo()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string query = "SELECT hakkimizda_baslik, hakkimizda_yazi FROM site_bilgileri LIMIT 1";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                using (MySqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        litBaslik.Text = dr["hakkimizda_baslik"].ToString();
                        litYazi.Text = dr["hakkimizda_yazi"].ToString();
                    }
                }
            }
        }
    }
}
