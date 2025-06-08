using System;
using System.Data;
using System.Configuration;
using MySqlConnector;

namespace eticaretcanta
{
    public partial class homepage : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulerUrunleriGetir();
            }
        }

        private void PopulerUrunleriGetir()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT urunAdi, fiyat, resimUrl FROM urunler ORDER BY populerlik DESC LIMIT 3";
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dlPopulerUrunler.DataSource = dt;
                dlPopulerUrunler.DataBind();
            }
        }

    }
}
