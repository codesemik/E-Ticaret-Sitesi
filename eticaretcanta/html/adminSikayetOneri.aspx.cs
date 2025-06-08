using System;
using System.Data;
using MySqlConnector;

namespace eticaretcanta
{
    public partial class adminSikayetOneri : System.Web.UI.Page
    {
        string connStr = "Server=localhost;Port=3306;Database=internetproje;Uid=root;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                MesajlariYukle();
            }
        }

        private void MesajlariYukle()
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT id, ad, eposta, mesaj, tarih FROM iletisim_mesajlari ORDER BY tarih DESC";
                using (MySqlCommand cmd = new MySqlCommand(query, conn))
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        GridViewMesajlar.DataSource = dt;
                        GridViewMesajlar.DataBind();
                    }
                }
            }
        }
    }
}
