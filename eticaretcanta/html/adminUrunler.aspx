<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="adminUrunler.aspx.cs" Inherits="eticaretcanta.html.adminUrunler" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Ürün Yönetimi</title>
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
        .form-group input {
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

/* Çok satırlı açıklama kutusu için */
textarea.form-control {
    resize: none;
    min-height: 100px;
    font-family: inherit;
}

/* Fokus efekti */
.form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.5);
    outline: none;
}

/* Etiketler arası boşluklar */
.form-group label {
    font-weight: 600;
    margin-bottom: 6px;
    display: block;
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
                    <li><a href="adminUrunler.aspx" class="active-link">Ürünler</a></li>
                    <li><a href="adminSiparisler.aspx" >Siparişler</a></li>
                    <li><a href="adminKullanicilar.aspx">Kullanıcılar</a></li>
                    <li><a href="adminSiteBilgileri.aspx">Site Bilgileri</a></li>
                    <li><a href="adminSikayetOneri.aspx">Şikayet / Öneri</a></li>
                    <li><a href="adminAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>

            <main class="content-area">
                <div class="form-section">
                    <h2>Yeni Ürün Ekle</h2>
                    <asp:Literal ID="litMesaj" runat="server" />
                    
                    <div class="form-group">
                        <label for="txtUrunAdi">Ürün Adı</label>
                        <asp:TextBox ID="txtUrunAdi" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtFiyat">Fiyat (₺)</label>
                        <asp:TextBox ID="txtFiyat" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="fuResim">Ürün Resmi</label>
                        <asp:FileUpload ID="fuResim" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="ddlKategori">Kategori</label>
                        <asp:DropDownList ID="ddlKategori" runat="server" CssClass="form-control" />
                    </div>


                    <div class="form-group">
                        <label for="txtAdet">Stok Adedi</label>
                        <asp:TextBox ID="txtAdet" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnUrunEkle" runat="server" Text="Ürünü Ekle" OnClick="btnUrunEkle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

                <!-- Ürün Detayları Ekleme Formu -->
                <div class="form-section mt-8">
                    <h2>Ürün Detayı Ekle</h2>
                    <asp:Literal ID="litDetayMesaj" runat="server" />

                    <div class="form-group">
                        <label for="txtDetayUrunID">Ürün ID</label>
                        <asp:TextBox ID="txtDetayUrunID" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtMateryal">Materyal</label>
                        <asp:TextBox ID="txtMateryal" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtMarka">Marka</label>
                        <asp:TextBox ID="txtMarka" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtOlcu">Ölçü</label>
                        <asp:TextBox ID="txtOlcu" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtCepler">Cepler</label>
                        <asp:TextBox ID="txtCepler" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtAciklama">Açıklama</label>
                        <asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnDetayEkle" runat="server" Text="Detay Ekle" OnClick="btnDetayEkle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

                <!-- Ürün Detayı Güncelleme Formu -->
                <div class="form-section mt-8">
                    <h2>Ürün Detayı Güncelle</h2>
                    <asp:Literal ID="litDetayGuncelleMesaj" runat="server" />
                    <asp:Literal ID="litDetayBulMesaj" runat="server" />


                    <div class="form-group">
                        <label for="txtGuncelleDetayID">Detay ID</label>
                        <asp:TextBox ID="txtGuncelleDetayID" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniMateryal">Yeni Materyal</label>
                        <asp:TextBox ID="txtYeniMateryal" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniMarka">Yeni Marka</label>
                        <asp:TextBox ID="txtYeniMarka" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniOlcu">Yeni Ölçü</label>
                        <asp:TextBox ID="txtYeniOlcu" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniCepler">Yeni Cepler</label>
                        <asp:TextBox ID="txtYeniCepler" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniAciklama">Yeni Açıklama</label>
                        <asp:TextBox ID="txtYeniAciklama" runat="server" 
                            CssClass="form-control" 
                            TextMode="MultiLine" 
                            Rows="4" 
                            Style="width: 100%; resize: none;" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnDetayGuncelle" runat="server" Text="Detayı Güncelle" OnClick="btnDetayGuncelle_Click" CssClass="btn btn-primary" />
                        <asp:Button ID="btnDetayBul" runat="server" Text="Detay Bilgilerini Getir" OnClick="btnDetayBul_Click" CssClass="btn btn-secondary" />

                    </div>
                </div>


                <!-- Stok Güncelleme Formu -->
                <div class="form-section mt-8">
                    <h2>Stok Güncelle</h2>
                    <asp:Literal ID="litGuncelleMesaj" runat="server" />
    
                    <div class="form-group">
                        <label for="txtGuncelleID">Ürün ID</label>
                        <asp:TextBox ID="txtGuncelleID" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <label for="txtYeniAdet">Yeni Stok Adedi</label>
                        <asp:TextBox ID="txtYeniAdet" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnStokGuncelle" runat="server" Text="Stok Güncelle" OnClick="btnStokGuncelle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

                <!-- Ürün Silme Formu -->
                <div class="form-section mt-8">
                    <h2>Stoktan Kaldır</h2>
                    <asp:Literal ID="litSilMesaj" runat="server" />
    
                    <div class="form-group">
                        <label for="txtSilID">Ürün ID</label>
                        <asp:TextBox ID="txtSilID" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnSil" runat="server" Text="Ürünü Sil" OnClick="btnSil_Click" CssClass="btn btn-danger" />
                    </div>
                </div>
                <!-- Ürün Listeleme Formu -->
                <div class="form-section mt-8">
                    <h2>Ürün Ara (İsme Göre)</h2>

                    <div class="form-group">
                        <label for="txtAra">Ürün Adı</label>
                        <asp:TextBox ID="txtAra" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnAra" runat="server" Text="Ara" OnClick="btnAra_Click" CssClass="btn btn-primary" />
                    </div>

                    <asp:GridView ID="gvUrunAra" runat="server" AutoGenerateColumns="False" CssClass="table-auto w-full border border-collapse" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="urunID" HeaderText="ID" />
                            <asp:BoundField DataField="urunAdi" HeaderText="Ürün Adı" />
                            <asp:BoundField DataField="fiyat" HeaderText="Fiyat (₺)" />
                            <asp:BoundField DataField="resimUrl" HeaderText="Resim" />
                            <asp:BoundField DataField="adet" HeaderText="Stok" />
                            <asp:TemplateField HeaderText="Kategori">
                                <ItemTemplate>
                                    <asp:DropDownList ID="ddlKategoriler" runat="server" CssClass="form-control" />
                                </ItemTemplate>
                            </asp:TemplateField>                        
                        </Columns>
                        <RowStyle CssClass="border-b" />
                        <HeaderStyle CssClass="bg-gray-200 font-bold" />
                    </asp:GridView>
                </div>

                <!-- Kategori Ekleme Formu -->
                <div class="form-section mt-8">
                    <h2>Yeni Kategori Ekle</h2>
                    <asp:Literal ID="litKategoriMesaj" runat="server" />

                    <div class="form-group">
                        <label for="txtKategoriAdi">Kategori Adı</label>
                        <asp:TextBox ID="txtKategoriAdi" runat="server" CssClass="form-control" />
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnKategoriEkle" runat="server" Text="Kategori Ekle" OnClick="btnKategoriEkle_Click" CssClass="btn btn-primary" />
                    </div>
                </div>

            </main>
        </div>
    </form>
</body>
</html>
