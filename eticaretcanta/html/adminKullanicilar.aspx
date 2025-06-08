<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminKullanicilar.aspx.cs" Inherits="eticaretcanta.html.adminKullanicilar" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kullanıcı Yönetimi</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap">
    <script src="https://unpkg.com/@tailwindcss/browser@latest"></script>
    <style>
        body {
            font-family: 'Inter', sans-serif;
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
            padding: 1.5rem;
        }
        .form-section {
            background-color: white;
            border-radius: 0.375rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            padding: 2rem;
            max-width: 800px;
        }
    </style>
</head>
<body class="bg-gray-100">
    <form id="form1" runat="server">
        <div class="flex h-screen">
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h1>Admin Paneli</h1>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="adminPanel.aspx">Dashboard</a></li>
                    <li><a href="adminUrunler.aspx">Ürünler</a></li>
                    <li><a href="adminSiparisler.aspx" >Siparişler</a></li>
                    <li><a href="adminKullanicilar.aspx" class="active-link">Kullanıcılar</a></li>
                    <li><a href="adminSiteBilgileri.aspx">Site Bilgileri</a></li>
                    <li><a href="adminSikayetOneri.aspx">Şikayet / Öneri</a></li>
                    <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>

            <main class="content-area">
                <div class="form-section">
                    <h2>Kullanıcı Listesi</h2>

                    <!-- Arama Formu -->
                    <div class="mb-4">
                        <label for="txtArama" class="block mb-1 font-semibold">Kullanıcı ID'ye Göre Ara:</label>
                        <asp:TextBox ID="txtArama" runat="server" CssClass="border p-2 rounded w-1/2" />
                        <asp:Button ID="btnAra" runat="server" Text="Ara" CssClass="bg-blue-500 text-white px-4 py-2 rounded ml-2" OnClick="btnAra_Click" />
                    </div>

                    <asp:GridView ID="gvKullanicilar" runat="server" AutoGenerateColumns="False" CssClass="table-auto w-full border border-collapse mt-4" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="userID" HeaderText="Kullanıcı ID" />
                            <asp:BoundField DataField="name" HeaderText="İsim" />
                            <asp:BoundField DataField="surname" HeaderText="Soyisim" />
                            <asp:BoundField DataField="username" HeaderText="Kullanıcı Adı" />
                            <asp:BoundField DataField="mail" HeaderText="E-Posta" />
                        </Columns>
                        <RowStyle CssClass="border-b" />
                        <HeaderStyle CssClass="bg-gray-200 font-bold" />
                    </asp:GridView>
                </div>
            </main>
        </div>
    </form>
</body>
</html>
