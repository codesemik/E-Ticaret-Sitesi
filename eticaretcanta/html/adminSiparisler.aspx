<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminSiparisler.aspx.cs" Inherits="eticaretcanta.html.adminSiparisler" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sipariş Yönetimi</title>
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
    flex-shrink: 0;
}

.sidebar-header {
    margin-bottom: 2rem;
}

.sidebar-header h1 {
    font-size: 1.5rem;
    font-weight: 600;
    color: white;
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

.sidebar-menu a:hover,
.sidebar-menu a.active-link {
    background-color: #4a5568;
    font-weight: 600;
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
            max-width: 700px;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.375rem;
        }
        .form-group button {
            background-color: #3b82f6;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.375rem;
            font-weight: 600;
            cursor: pointer;
        }
        .form-group button:hover {
            background-color: #2563eb;
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
                    <li><a href="adminSiparisler.aspx" class="active-link">Siparişler</a></li>
                    <li><a href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                    <li><a href="adminSiteBilgileri.aspx">Site Bilgileri</a></li>
                    <li><a href="adminSikayetOneri.aspx">Şikayet / Öneri</a></li>
                    <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>

            <main class="content-area">
                <div class="form-section">
                    <h2>Sipariş Durumu Güncelle</h2>
                    <asp:Literal ID="litDurumMesaj" runat="server" />

                    <div class="form-group">
                        <label for="txtSiparisID">Sipariş ID</label>
                        <asp:TextBox ID="txtSiparisID" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="ddlSiparisDurumu">Yeni Durum</label>
                        <asp:DropDownList ID="ddlSiparisDurumu" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Beklemede" Value="Beklemede" />
                            <asp:ListItem Text="Kargoya Verildi" Value="Kargoya Verildi" />
                            <asp:ListItem Text="Teslim Edildi" Value="Teslim Edildi" />
                            <asp:ListItem Text="İptal Edildi" Value="İptal Edildi" />
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnDurumGuncelle" runat="server" Text="Durumu Güncelle" OnClick="btnDurumGuncelle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

                <!-- Sipariş Listeleme -->
                <div class="form-section mt-8">
                    <h2>Mevcut Siparişler</h2>
                    <asp:GridView ID="gvSiparisler" runat="server" AutoGenerateColumns="False" CssClass="table-auto w-full border border-collapse" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="SiparisID" HeaderText="ID" />
                            <asp:BoundField DataField="userID" HeaderText="Kullanıcı ID" />
                            <asp:BoundField DataField="SiparisTarihi" HeaderText="Tarih" />
                            <asp:BoundField DataField="Durum" HeaderText="Durum" />
                            <asp:BoundField DataField="ToplamFiyat" HeaderText="Fiyat" />
                        </Columns>
                        <RowStyle CssClass="border-b" />
                        <HeaderStyle CssClass="bg-gray-200 font-bold" />
                    </asp:GridView>
                </div>

                <div class="form-section mt-8">
                    <h2>Sipariş Detaylarını Görüntüle</h2>
                    <asp:Literal ID="litDetayMesaj" runat="server" />

                    <div class="form-group">
                        <label for="txtSiparisIDDetay">Sipariş ID</label>
                        <asp:TextBox ID="txtSiparisIDDetay" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnDetayGoruntule" runat="server" Text="Detayları Göster" OnClick="btnDetayGoruntule_Click" CssClass="btn btn-primary" />
                    </div>

                    <asp:GridView ID="gvSiparisDetaylari" runat="server" AutoGenerateColumns="False" CssClass="table-auto w-full border border-collapse mt-4" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="siparisDetayID" HeaderText="Detay ID" />
                            <asp:BoundField DataField="siparisID" HeaderText="Sipariş ID" />
                            <asp:BoundField DataField="urunID" HeaderText="Ürün ID" />
                            <asp:BoundField DataField="adet" HeaderText="Adet" />
                            <asp:BoundField DataField="fiyat" HeaderText="Fiyat (₺)" DataFormatString="{0:N2}" />
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
