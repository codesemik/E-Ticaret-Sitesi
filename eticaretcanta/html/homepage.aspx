<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="homepage.aspx.cs" Inherits="eticaretcanta.homepage" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ana Sayfa - Ürün Satış Sitesi</title>
    <link rel="stylesheet" href="index.css">
    <style>
        /* Ana sayfaya özel CSS stilleri buraya gelebilir */
        .hero {
            background-color: #f8f9fa;
            padding: 50px 20px;
            text-align: center;
            margin-bottom: 30px;
        }

        .hero h2 {
            font-size: 2.5em;
            color: #333;
            margin-bottom: 15px;
        }

        .hero p {
            font-size: 1.1em;
            color: #666;
            margin-bottom: 25px;
        }

        .featured-products {
            padding: 20px;
            text-align: center;
        }

        .featured-products h2 {
            font-size: 2em;
            color: #333;
            margin-bottom: 20px;
        }

        .featured-products .product-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .featured-products .product-item {
            width: 250px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            background-color: #fff;
        }

        .featured-products .product-item img {
            max-width: 100%;
            height: auto;
            border-radius: 5px;
            margin-bottom: 10px;
        }

        .featured-products .product-item h3 {
            font-size: 1.2em;
            color: #333;
            margin-bottom: 5px;
        }

        .featured-products .product-item p {
            color: #666;
        }

        .call-to-action {
            background-color: #e9ecef;
            padding: 40px 20px;
            text-align: center;
            margin-top: 30px;
        }

        .call-to-action h2 {
            font-size: 2em;
            color: #333;
            margin-bottom: 15px;
        }

        .call-to-action a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }

        .call-to-action a:hover {
            background-color: #0056b3;
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
            <section class="hero">
                <h2>En Yeni Ürünlerle Tanışın!</h2>
                <p>Kaliteli ve şık ürünlerimizle tarzınızı yansıtın.</p>
                <a href="index.aspx" class="go-to-products-btn">Ürünleri Keşfet</a>
            </section>

            <section class="featured-products">
                <h2>Öne Çıkan Ürünler</h2>
                <div class="product-list">
                    <asp:DataList ID="dlPopulerUrunler" runat="server" RepeatDirection="Horizontal" RepeatColumns="3" CellPadding="10" CssClass="product-list">
                        <ItemTemplate>
                            <div class="product-item">
                                <img src='<%# ResolveUrl("~/images/" + Eval("resimUrl")) %>' alt='<%# Eval("urunAdi") %>' />
                                <h3><%# Eval("urunAdi") %></h3>
                                <p>Fiyat: <%# Eval("fiyat") %> ₺</p>
                            </div>
                        </ItemTemplate>

                    </asp:DataList>
                </div>


            </section>

            <section class="call-to-action">
                <h2>Kampanyalarımıza Göz Atın!</h2>
                <p>Sezonun en özel indirimleri ve fırsatları sizleri bekliyor.</p>
                <a href="#">Kampanyaları İncele</a>
            </section>
        </main>

        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>

    <script>
        function toggleDropdown() {
            document.getElementById("dropdownContent").classList.toggle("show");
        }

        window.onclick = function(event) {
            if (!event.target.matches('.dropbtn')) {
                var dropdowns = document.getElementsByClassName("dropdown-content");
                for (var i = 0; i < dropdowns.length; i++) {
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