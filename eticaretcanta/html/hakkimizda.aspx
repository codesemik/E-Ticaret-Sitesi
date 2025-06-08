<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="hakkimizda.aspx.cs" Inherits="eticaretcanta.hakkimizda" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Hakkımızda - Mağazam</title>
    <link rel="stylesheet" href="index.css" />
    <style>
        .about-us {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            align-items: center;
            justify-content: center;
            padding: 50px 20px;
            background-color: #f9f9f9;
            border-radius: 12px;
            max-width: 1200px;
            margin: 40px auto;
        }

        .about-us-text {
            flex: 1;
            min-width: 300px;
        }

        .about-us-text h2 {
            font-size: 2em;
            margin-bottom: 20px;
            color: #333;
        }

        .about-us-text p {
            font-size: 1.1em;
            line-height: 1.6;
            color: #555;
        }

        .about-us-image {
            flex: 1;
            min-width: 280px;
            text-align: center;
        }

        .about-us-image img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        @media screen and (max-width: 768px) {
            .about-us {
                flex-direction: column;
                padding: 30px 15px;
            }

            .about-us-text, .about-us-image {
                text-align: center;
            }
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
                    <button type="button" class="dropbtn" onclick="toggleDropdown()">👤 
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
                            <a href='<%= (Session["yetki"] != null && Session["yetki"].ToString() == "1") ? "adminpanel.aspx" : "kullaniciSiparisler.aspx" %>'>Profilim</a>
                            <a href="cikis.aspx">Çıkış</a>
                        <% } %>
                    </div>
                </div>
            </nav>
        </header>

        <main>
            <div class="about-us">
                <div class="about-us-text">
                    <h2><asp:Literal ID="litBaslik" runat="server" /></h2>
                    <p><asp:Literal ID="litYazi" runat="server" /></p>
                </div>
                <div class="about-us-image">
                    <asp:Image ID="imgHakkimizda" runat="server" />
                </div>
            </div>
        </main>


        <footer>
            <p>&copy; 2025 Mağazam. Tüm hakları saklıdır.</p>
        </footer>
    </form>

    <script>
        function toggleDropdown() {
            document.getElementById("dropdownContent").classList.toggle("show");
        }

        window.onclick = function (event) {
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
