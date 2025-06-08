<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminSiteBilgileri.aspx.cs" Inherits="eticaretcanta.html.adminSiteBilgileri" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Site Bilgileri</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" />
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
        max-width: 600px;
    }
    .form-group {
        margin-bottom: 1rem;
    }
    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 600;
    }
    .form-group input,
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #e2e8f0;
        border-radius: 0.375rem;
    }
    .form-group button,
    .form-group input[type="submit"] {
        background-color: #3b82f6;
        color: white;
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 0.375rem;
        font-weight: 600;
        cursor: pointer;
    }
    .form-group button:hover,
    .form-group input[type="submit"]:hover {
        background-color: #2563eb;
    }

    .form-control {
        width: 100%;
        padding: 10px 12px;
        font-size: 16px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
        margin-bottom: 12px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    textarea.form-control {
        resize: none;
        min-height: 100px;
        font-family: inherit;
    }

    .form-control:focus {
        border-color: #007bff;
        box-shadow: 0 0 4px rgba(0, 123, 255, 0.5);
        outline: none;
    }
</style>

</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="flex">
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h1>Admin Paneli</h1>
                </div>
                <ul class="sidebar-menu">
                    <li><a href="adminPanel.aspx">Dashboard</a></li>
                    <li><a href="adminUrunler.aspx">Ürünler</a></li>
                    <li><a href="adminSiparisler.aspx" >Siparişler</a></li>
                    <li><a href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                    <li><a href="adminSiteBilgileri.aspx" class="active-link">Site Bilgileri</a></li>
                    <li><a href="adminSikayetOneri.aspx">Şikayet / Öneri</a></li>
                    <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>

            <main class="content-area">
                <div class="form-section">
                    <h2>Site Bilgilerini Düzenle</h2>
                    <asp:Literal ID="litGuncellemeMesaji" runat="server" />

                    <div class="form-group">
                        <label for="txtHakkimizdaBaslik">Hakkımızda Başlık</label>
                        <asp:TextBox ID="txtHakkimizdaBaslik" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtHakkimizdaYazi">Hakkımızda Yazı</label>
                        <asp:TextBox ID="txtHakkimizdaYazi" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtIletisimBaslik">İletişim Başlık</label>
                        <asp:TextBox ID="txtIletisimBaslik" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtIletisimAdres">İletişim Adres</label>
                        <asp:TextBox ID="txtIletisimAdres" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtIletisimTelefon">İletişim Telefon</label>
                        <asp:TextBox ID="txtIletisimTelefon" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtIletisimEposta">İletişim E-Posta</label>
                        <asp:TextBox ID="txtIletisimEposta" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnGuncelle" runat="server" Text="Bilgileri Güncelle" OnClick="btnGuncelle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

                <div class="form-section">
                    <h2>Hakkımızda Resim Yükle</h2>
                    <asp:FileUpload ID="fileUploader" runat="server" />
                    <asp:Button ID="btnYukle" runat="server" Text="Yükle" OnClick="btnYukle_Click" />
<asp:Literal ID="litMesaj" runat="server" />
                </div>
            </main>
        </div>
    </form>
</body>
</html>
