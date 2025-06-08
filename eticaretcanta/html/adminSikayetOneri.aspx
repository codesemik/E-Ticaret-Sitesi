<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminSikayetOneri.aspx.cs" Inherits="eticaretcanta.adminSikayetOneri" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Şikayet / Öneri</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" />
    <script src="https://unpkg.com/@tailwindcss/browser@latest"></script>
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7fafc;
        }

        .flex {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            background-color: #2d3748;
            color: white;
            width: 256px;
            padding: 1rem;
        }

        .sidebar-header {
            margin-bottom: 2rem;
        }

        .sidebar-header h1 {
            font-size: 1.5rem;
            font-weight: 600;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }

        .sidebar-menu a {
            display: block;
            padding: 0.75rem 1rem;
            border-radius: 0.375rem;
            color: white;
            text-decoration: none;
            transition: background-color 0.3s ease;
        }

        .sidebar-menu a:hover {
            background-color: #4a5568;
        }

        .active-link {
            background-color: #4a5568;
            font-weight: 600;
        }

        .content-area {
            flex-grow: 1;
            padding: 2rem;
        }

        .form-section {
            background-color: white;
            border-radius: 0.375rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 2rem;
        }

        h2 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #2d3748;
        }

        .gridview {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        .gridview th, .gridview td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
            font-size: 0.95rem;
        }

        .gridview th {
            background-color: #edf2f7;
            font-weight: 600;
            color: #2d3748;
        }

        .gridview tr:nth-child(even) {
            background-color: #f7fafc;
        }

        .gridview tr:hover {
            background-color: #e2e8f0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="flex">
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h1>Admin Paneli</h1>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="adminPanel.aspx">Dashboard</a></li>
                    <li><a href="adminUrunler.aspx">Ürünler</a></li>
                    <li><a href="adminSiparisler.aspx">Siparişler</a></li>
                    <li><a href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                    <li><a href="adminSiteBilgileri.aspx">Site Bilgileri</a></li>
                    <li><a href="adminSikayetOneri.aspx" class="active-link">Şikayet / Öneri</a></li>
                    <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>
            <main class="content-area">
                <div class="form-section">
                    <h2>Gelen Şikayet ve Öneri Mesajları</h2>
                    <asp:GridView ID="GridViewMesajlar" runat="server" AutoGenerateColumns="false" CssClass="gridview">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" />
                            <asp:BoundField DataField="ad" HeaderText="Ad Soyad" />
                            <asp:BoundField DataField="eposta" HeaderText="E-posta" />
                            <asp:BoundField DataField="mesaj" HeaderText="Mesaj" />
                            <asp:BoundField DataField="tarih" HeaderText="Tarih" DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </main>
        </div>
    </form>
</body>
</html>
