<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminPanel.aspx.cs" Inherits="eticaretcanta.html.adminPanel" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Paneli</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap">
    <script src="https://unpkg.com/@tailwindcss/browser@latest"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
        /* Özel CSS Stilleri Başlangıcı */
        .sidebar {
            background-color: #2d3748; /* Koyu gri */
            color: white;
            width: 256px; /* Sabit genişlik */
            padding: 1rem;
        }
        .sidebar-header {
            margin-bottom: 2rem;
        }
        .sidebar-header h1 {
            font-size: 1.5rem; /* Daha büyük başlık */
            font-weight: 600; /* Yarı-kalın */
        }
        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }
        .sidebar-menu a {
            display: block;
            padding: 0.75rem 1rem;
            border-radius: 0.375rem; /* Köşeleri yuvarlat */
            color: white;
            text-decoration: none;
            transition: background-color 0.3s ease; /* Yumuşak geçiş */
        }
        .sidebar-menu a:hover {
            background-color: #4a5568; /* Hover rengi */
        }
        .active-link {
            background-color: #4a5568; /* Aktif bağlantı rengi */
            font-weight: 600;
        }
        .content-area {
            flex-grow: 1;
            padding: 1.5rem;
        }
        .dashboard-heading {
            font-size: 1.875rem; /* Daha büyük başlık */
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .summary-cards {
            display: grid;
            grid-template-columns: 1fr; /* Başlangıçta tek sütun */
            @media (min-width: 768px) {
                grid-template-columns: repeat(2, 1fr); /* Orta boy ekranlarda iki sütun */
            }
            @media (min-width: 1024px) {
                grid-template-columns: repeat(3, 1fr); /* Büyük ekranlarda üç sütun */
            }
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .summary-card {
            background-color: white;
            border-radius: 0.375rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); /* Daha belirgin gölge */
            padding: 1rem;
        }
        .summary-card h3 {
            font-size: 1.25rem; /* Daha büyük başlık */
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .summary-card p {
            font-size: 1.5rem; /* Daha büyük sayı */
            color: #4a5568;
        }

        .recent-orders {
            margin-top: 2rem;
        }
        .recent-orders h3 {
            font-size: 1.25rem; /* Daha büyük başlık */
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 0.375rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); /* Daha belirgin gölge */
        }
        .order-table thead {
            background-color: #edf2f7; /* Daha açık başlık arka planı */
        }
        .order-table th, .order-table td {
            text-align: left;
            padding: 0.75rem;
            border-bottom: 1px solid #e2e8f0; /* Daha açık ayırıcı çizgi */
        }
        .order-table th {
            font-weight: 600;
        }
        .order-table tbody tr:hover {
            background-color: #f7fafc; /* Hover rengi */
        }
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropbtn {
            background-color: #3b82f6;
            color: white;
            padding: 10px;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 5px;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            border-radius: 5px;
        }

        .dropdown-content a:hover {
            background-color: #ddd;
        }

        .show {
            display: block;
        }
        /* Özel CSS Stilleri Sonu */
    </style>
</head>
<body class="bg-gray-100">
    <div class="flex h-screen">
        <aside class="sidebar">
    <div class="sidebar-header">
        <h1>Admin Paneli</h1>
    </div>
    <ul class="sidebar-menu">
        <li><a href="adminPanel.aspx" class="active-link">Dashboard</a></li>
        <li><a href="adminUrunler.aspx">Ürünler</a></li>
        <li><a href="adminSiparisler.aspx" >Siparişler</a></li>
        <li><a href="adminKullanicilar.aspx">Kullanıcılar</a></li>
        <li><a href="adminSiteBilgileri.aspx">Site Bilgileri</a></li>
        <li><a href="adminSikayetOneri.aspx">Şikayet / Öneri</a></li>
        <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
    </ul>
</aside>

        <main class="content-area">
            <h2 class="dashboard-heading">Dashboard</h2>
            <div class="summary-cards">
                <div class="summary-card">
                    <h3>Toplam Satış</h3>
                    <p>₺<%= ToplamSatis %></p>
                </div>
                <div class="summary-card">
                    <h3>Toplam Sipariş</h3>
                    <p><%= ToplamSiparisAdet %></p>
                </div>
                <div class="summary-card">
                    <h3>Aktif Kullanıcılar</h3>
                    <p><%= AktifKullaniciSayisi %></p>
                </div>
            </div>

            <div class="recent-orders">
                <h3>Son Siparişler</h3>
                <div class="bg-white rounded-md shadow-md p-4">
                    <asp:DataList ID="dlSonSiparisler" runat="server" Width="100%" ItemStyle-CssClass="border-bottom border-gray-200">
                        <HeaderTemplate>
                            <table class="order-table">
                                <thead class="bg-gray-100">
                                    <tr>
                                        <th class="text-left py-2">Sipariş ID</th>
                                        <th class="text-left py-2">Müşteri</th>
                                        <th class="text-left py-2">Tarih</th>
                                        <th class="text-left py-2">Durum</th>
                                        <th class="text-left py-2">Toplam</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td class="py-2"><%# Eval("SiparisID") %></td>
                                <td class="py-2"><%# Eval("userID") %></td>
                                <td class="py-2"><%# Eval("SiparisTarihi") %></td>
                                <td class="py-2"><%# Eval("Durum") %></td>
                                <td class="py-2">₺<%# Eval("ToplamFiyat") %></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                                </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:DataList>
                </div>
            </div>
        </main>
    </div>
    <script>
        function toggleDropdown() {
            var dropdownContent = document.getElementById("dropdownContent");
            dropdownContent.classList.toggle("show");
        }

        window.onclick = function (event) {
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
