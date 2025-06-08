<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="detaygoruntule.aspx.cs" Inherits="eticaretcanta.detaygoruntule" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Ürün Detayı</title>
    <link rel="stylesheet" href="index.css" />
    <style>
        .gridview-container {
            margin-top: 30px;
            max-width: 900px;
            margin-left: auto;
            margin-right: auto;
        }
        .gridview-container asp\\:GridView {
            width: 100%;
            border-collapse: collapse;
        }
        .gridview-container table {
            width: 100%;
            border-collapse: collapse;
        }
        .gridview-container th, .gridview-container td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .gridview-container th {
            background-color: #f2f2f2;
        }

        .product-detail-container {
    display: flex;
    gap: 30px;
    align-items: stretch;
}

.product-image-container {
    background-color: #f9f9f9;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px;
}

.product-image {
    max-width: 100%;
    max-height: 500px;
    object-fit: contain;
}

.product-details {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}


.gridview {
    width: 100%;
    border-collapse: collapse;
    margin-top: 15px;
}

.gridview th, .gridview td {
    border: 1px solid #ddd;
    padding: 8px;
}

.gridview th {
    background-color: #f4f4f4;
    text-align: left;
}

.sepete-ekle-btn {
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #28a745;
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 5px;
}

    </style>
    <script src="script.js" defer></script>
</head>
<body>
    <form id="form1" runat="server">
        <header>
    <h1>Runwayology</h1>
    <nav>

        <a href="homepage.aspx">Ana Sayfa</a>
        <a href="hakkimizda.aspx">Hakkımızda</a>
        <a href="index.aspx">Ürünler</a>
        <a href="iletisim.aspx">İletişim</a>
        <a href="sepet.aspx" class="go-to-cart-btn" style="margin-left: 10px;">Sepete Git</a>
        <div class="dropdown">
            <button type="button" class="dropbtn" onclick="toggleDropdown()">
                👤 
                <% if (Session["username"] != null) { %>
                    <%= Session["username"].ToString() %>
                <% } else { %>
                    Hesabım
                <% } %>
            </button>
            <div id="dropdownContent" class="dropdown-content">
                <% if (Session["username"] == null) { %>
                    <a href="login.aspx">Üye Giriş</a>
                    <a href="signin.aspx">Üye Ol</a>
                <% } else { %>
                    <a href='<% = (Session["yetki"] != null && Session["yetki"].ToString() == "1") ? "adminpanel.aspx" : "kullaniciSiparisler.aspx" %>'>Profilim</a> <a href="cikis.aspx">Çıkış</a>     <% } %>
            </div>
        </div>
    </nav>
</header>

        <main>
    <div class="product-detail-container" style="display: flex; gap: 30px; align-items: stretch;">
        <!-- Sol tarafta ürün görseli -->
        <div class="product-image-container" style="flex: 1; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9; padding: 10px;">
            <asp:Image ID="imgUrun" runat="server" CssClass="product-image" Style="max-width: 100%; max-height: 500px; object-fit: contain;" />
        </div>

        <!-- Sağ tarafta ürün bilgileri ve GridView -->
        <div class="product-details" style="flex: 1; display: flex; flex-direction: column; justify-content: space-between;">
            <div>
                <h2><asp:Label ID="lblUrunAdi" runat="server" Text="Ürün Adı"></asp:Label></h2>
                <p><strong>Fiyat:</strong> <asp:Label ID="lblFiyat" runat="server" Text="0 ₺"></asp:Label></p>
                <p><strong>Kategori:</strong> <asp:Label ID="lblKategori" runat="server" Text="Kategori"></asp:Label></p>
                <p><strong>Stok:</strong> <asp:Label ID="lblAdet" runat="server" Text="0"></asp:Label></p>
                <p><strong>Açıklama:</strong></p>
                <p><asp:Label ID="lblAciklama" runat="server" Text="Ürün açıklaması buraya gelecek."></asp:Label></p>
            </div>

            <asp:Button ID="btnSepeteEkle" runat="server" Text="Sepete Ekle" CssClass="sepete-ekle-btn" OnClick="btnSepeteEkle_Click" Style="margin-top: 15px;" />

            <!-- GridView burada -->
            <div class="gridview-container" style="width: 100%; padding: 0; margin: 0;">
                <h3 style="margin-left: 0;">Ürün Özellikleri</h3>
                <asp:GridView ID="gvUrunOzellikler" runat="server" AutoGenerateColumns="false"
                    CssClass="gridview" EmptyDataText="Özellik bulunmamaktadır."
                    style="width: 100%;">
                    <Columns>
                        <asp:BoundField DataField="materyal" HeaderText="Materyal" />
                        <asp:BoundField DataField="marka" HeaderText="Marka" />
                        <asp:BoundField DataField="olcu" HeaderText="Ölçü" />
                        <asp:BoundField DataField="cepler" HeaderText="Cepler" />
                    </Columns>
                </asp:GridView>
            </div>

    </div>
</main>

    </div>
</main>



        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>
</body>
</html>
