<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sepet.aspx.cs" Inherits="eticaretcanta.sepet" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Sepetim</title>
    <link rel="stylesheet" href="index.css" />
    <style>
        .product-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 10px;
            width: 400px;
        }

        .product-card img {
            max-width: 100px;
            height: auto;
            margin-right: 15px;
        }

        .product-card h2 {
            font-size: 1.2em;
            margin-bottom: 5px;
            margin-right: 10px;
        }

        .product-card p {
            font-size: 1em;
            margin-bottom: 0;
            margin-right: 10px;
        }

        .product-adet {
            font-size: 1em;
            margin-bottom: 0;
            margin-right: 10px;
        }

        .sepet-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-family: Arial, sans-serif;
        }

        .sepet-grid th, .sepet-grid td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .sepet-grid th {
            background-color: #f4f4f4;
            font-weight: bold;
        }

        .sepet-grid tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .sepet-grid tr:hover {
            background-color: #f1f1f1;
        }

        .urun-resmi img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        .sil-butonu {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }

        .sil-butonu:hover {
            background-color: #c0392b;
        }
        .satinal-butonu {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            margin-left: 10px;
        }

        .satinal-butonu:hover {
            background-color: #219653;
        }
    </style>
</head>
<body>
    <form runat="server">
        <header>
            <h1>Runwayology</h1>
            <nav>
                <a href="homepage.aspx">Ana Sayfa</a>
                <a href="hakkimizda.aspx">Hakkımızda</a>
                <a href="index.aspx">Ürünler</a>
                <a href="iletisim.aspx">İletişim</a>
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
                            <a href='<% = (Session["yetki"] != null && Session["yetki"].ToString() == "1") ? "adminpanel.aspx" : "kullaniciSiparisler.aspx" %>'>Profilim</a> <a href="cikis.aspx">Çıkış</a>                        <% } %>
                    </div>
                </div>
            </nav>
        </header>

        <main>
            <center>
            <asp:GridView ID="SepetGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="UrunID" OnRowDeleting="SepetGridView_RowDeleting" CssClass="sepet-grid" OnRowCommand="SepetGridView_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="Ürün Resmi">
                        <ItemTemplate>
                            <asp:Image ID="imgUrun" runat="server"
                                ImageUrl='<%# VirtualPathUtility.ToAbsolute("~/images/" + Eval("ResimUrl")) %>'
                                CssClass="urun-resmi"
                                Height="80" Width="80"
                                AlternateText='<%# Eval("UrunAdi") %>' />
                        </ItemTemplate>
                        <ItemStyle CssClass="urun-resmi" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="UrunAdi" HeaderText="Ürün Adı" />
                    <asp:TemplateField HeaderText="Adet">
                        <ItemTemplate>
                            <asp:Button ID="btnAzalt" runat="server" Text="-" CommandName="Azalt" CommandArgument='<%# Container.DataItemIndex %>' CssClass="sil-butonu" />
                            <asp:Label ID="lblAdet" runat="server" Text='<%# Eval("Adet") %>' CssClass="product-adet"></asp:Label>
                            <asp:Button ID="btnArttir" runat="server" Text="+" CommandName="Arttir" CommandArgument='<%# Container.DataItemIndex %>' CssClass="satinal-butonu" />
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Fiyat" HeaderText="Birim Fiyat" DataFormatString="{0:C}" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnSil" runat="server" Text="Sil" CommandName="Delete" CssClass="sil-butonu" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <br />
            <br />
            </center>
            <p>
                <strong>Toplam Fiyat: </strong>
                <asp:Literal ID="ToplamFiyatLiteral" runat="server" />
                <asp:Button ID="btnSatınAl" runat="server" Text="Satın Al" OnClick="BtnSatınAl_Click" CssClass="satinal-butonu" />    </p>
        </main>

        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>
    <script>
        function toggleDropdown() {
            var dropdownContent = document.getElementById("dropdownContent");
            dropdownContent.classList.toggle("show");
        }

        window.onclick = function(event) {
            if (!event.target.matches('.dropbtn')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                var i;
                for (i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }
    </script>
</body>
</html>
