<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="iletisim.aspx.cs" Inherits="eticaretcanta.iletisim" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>İletişim - Ürün Satış Sitesi</title>
    <link rel="stylesheet" href="index.css"> <style>
        /* Bu sayfaya özel CSS stilleri buraya gelebilir (şu anda bir fark yok) */
        .contact-info {
            margin-top: 20px;
            text-align: left;
        }

        .contact-info p {
            margin-bottom: 10px;
        }

        .contact-form {
            margin-top: 30px;
            text-align: left;
        }

        .contact-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .contact-form input[type="text"],
        .contact-form input[type="email"],
        .contact-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .contact-form button {
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.3s ease;
        }

        .contact-form button:hover {
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

        <main class="content-container">
            <section class="contact-page">
                <h2><asp:Label ID="lblBaslik" runat="server" Text="İletişim"></asp:Label></h2>
                    <div class="contact-info">
                        <p>Bize aşağıdaki bilgiler aracılığıyla ulaşabilirsiniz:</p>
                        <p><strong>Adres:</strong> <asp:Label ID="lblAdres" runat="server" /></p>
                        <p><strong>Telefon:</strong> <asp:Label ID="lblTelefon" runat="server" /></p>
                        <p><strong>E-posta:</strong> <asp:Label ID="lblEposta" runat="server" /></p>
                    </div>


                <div class="contact-form">
                    <h3>Bize Mesaj Gönderin</h3>
                    <label for="ad">Adınız:</label>
                    <input type="text" id="ad" name="ad" required="required" />

                    <label for="eposta">E-posta Adresiniz:</label>
                    <input type="email" id="eposta" name="eposta" required="required" />

                    <label for="mesaj">Mesajınız:</label>
                    <textarea id="mesaj" name="mesaj" rows="5" required="required"></textarea>

                    <asp:Button ID="btnGonder" runat="server" Text="Gönder" OnClick="btnGonder_Click" CssClass="submit-button" />
                </div>
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