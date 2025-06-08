<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="eticaretcanta.index" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ürün Satış Sitesi</title>
    <link rel="stylesheet" href="index.css">
    <script src="script.js" defer></script>
    <style>
    .kategori-list td {
        padding: 0 10px;
        white-space: nowrap;
    }

    .kategori-list input[type="radio"] {
        margin-right: 5px;
    }
</style>

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
            <center>
            <asp:RadioButtonList ID="rblKategoriler" runat="server" 
                AutoPostBack="true" 
                RepeatDirection="Horizontal"
                CssClass="kategori-list"
                OnSelectedIndexChanged="rblKategoriler_SelectedIndexChanged">
            </asp:RadioButtonList>
                </center>


            <div class="product-container">
                <center>
                    <asp:DataList ID="ProductDataList" runat="server" RepeatDirection="Horizontal" RepeatColumns="3"
                        OnItemCommand="ProductDataList_ItemCommand" CssClass="product-datalist">
                        <ItemTemplate>
                            <div class="product-card">
                                <img src='<%# ResolveUrl("~/images/" + Eval("resimUrl")) %>' alt='<%# Eval("urunAdi") %>' />
                                <h2><%# Eval("urunAdi") %></h2>
                                <p><%# Eval("fiyat") %> ₺</p>
                                Adet: <asp:TextBox ID="txtAdet" runat="server" Text="1" CssClass="adet-kutusu"></asp:TextBox>
                                <asp:Button runat="server" Text="Sepete Ekle" CssClass="sepete-ekle-btn"
                                    CommandName="SepeteEkle"
                                    CommandArgument='<%# Eval("urunID") %>' />

                                <br />
                                <asp:HyperLink runat="server" NavigateUrl='<%# "detaygoruntule.aspx?urunID=" + Eval("urunID") %>' CssClass="detay-btn">
                                    Detay Görüntüle
                                </asp:HyperLink>
                            </div>
                        </ItemTemplate>
                    </asp:DataList>
                </center>
            </div>
        </main>

        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>
</body>
</html>