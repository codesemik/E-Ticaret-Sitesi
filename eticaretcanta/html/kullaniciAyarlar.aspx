<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kullaniciAyarlar.aspx.cs" Inherits="eticaretcanta.html.kullaniciAyarlar" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kullanıcı Paneli</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap">
    <script src="https://unpkg.com/@tailwindcss/browser@latest"></script>
    <style>
        body { font-family: 'Inter', sans-serif; }
        .sidebar { background-color: #2d3748; color: white; width: 256px; padding: 1rem; }
        .sidebar-header { margin-bottom: 2rem; }
        .sidebar-header h1 { font-size: 1.5rem; font-weight: 600; }
        .sidebar-menu li { margin-bottom: 0.5rem; }
        .sidebar-menu a {
            display: block; padding: 0.75rem 1rem; border-radius: 0.375rem;
            color: white; text-decoration: none; transition: background-color 0.3s ease;
        }
        .sidebar-menu a:hover { background-color: #4a5568; }
        .active-link { background-color: #4a5568; font-weight: 600; }
        .content-area { flex-grow: 1; padding: 1.5rem; overflow-y: auto; }
        .form-section {
            background-color: white; border-radius: 0.375rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 2rem; max-width: 800px;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body class="bg-gray-100">
    <form id="form1" runat="server">
        <div class="flex h-screen">
            <!-- Sidebar -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h1>Kullanıcı Paneli</h1>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="kullaniciSiparisler.aspx">Tüm Siparişler</a></li>
                    <li><a href="kullaniciAyarlar.aspx" class="active-link">Ayarlar</a></li>
                </ul>
            </aside>

            <!-- İçerik Alanı -->
            <main class="content-area">

                <!-- Mail Güncelleme -->
                <div class="form-section">
                    <h2 class="text-xl font-semibold mb-4">Mail Değiştir</h2>

                    <div class="mb-4">
                        <label class="block font-semibold mb-1">Yeni Mail:</label>
                        <asp:TextBox ID="txtYeniMail" runat="server" CssClass="border p-2 rounded w-1/2" />
                    </div>

                    <asp:Button ID="btnMailGuncelle" runat="server" Text="Maili Güncelle" CssClass="bg-green-500 text-white px-4 py-2 rounded" OnClick="btnMailGuncelle_Click" />
                    <asp:Label ID="lblMailDurum" runat="server" CssClass="block mt-2" ForeColor="Green" />
                </div>

                <!-- Şifre Güncelleme -->
                <div class="form-section">
                    <h2 class="text-xl font-semibold mb-4">Şifre Değiştir</h2>

                    <div class="mb-4">
                        <label class="block font-semibold mb-1">Eski Şifre:</label>
                        <asp:TextBox ID="txtEskiSifre" runat="server" CssClass="border p-2 rounded w-1/2" TextMode="Password" />
                    </div>

                    <div class="mb-4">
                        <label class="block font-semibold mb-1">Yeni Şifre:</label>
                        <asp:TextBox ID="txtYeniSifre" runat="server" CssClass="border p-2 rounded w-1/2" TextMode="Password" />
                    </div>

                    <div class="mb-4">
                        <label class="block font-semibold mb-1">Yeni Şifre (Tekrar):</label>
                        <asp:TextBox ID="txtYeniSifreTekrar" runat="server" CssClass="border p-2 rounded w-1/2" TextMode="Password" />
                    </div>

                    <asp:Button ID="btnSifreGuncelle" runat="server" Text="Şifreyi Güncelle" CssClass="bg-yellow-500 text-white px-4 py-2 rounded" OnClick="btnSifreGuncelle_Click" />
                    <asp:Label ID="lblSifreDurum" runat="server" CssClass="block mt-2" ForeColor="Red" />
                </div>
            </main>
        </div>
    </form>
</body>
</html>
