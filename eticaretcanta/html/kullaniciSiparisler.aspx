<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="kullaniciSiparisler.aspx.cs" Inherits="eticaretcanta.html.kullaniciSiparisler" %>

<!DOCTYPE html>
<html lang="tr">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kullanıcı Paneli - Siparişler</title>
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
        .gridview-container table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            background-color: white;
            border-radius: 0.375rem;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .gridview-container th, .gridview-container td {
            padding: 12px;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
        }
        .gridview-container th {
            background-color: #f7fafc;
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
                    <li><a href="kullaniciSiparisler.aspx" class="active-link">Tüm Siparişler</a></li>
                    <li><a href="kullaniciAyarlar.aspx">Ayarlar</a></li>
                </ul>
            </aside>

            <!-- İçerik Alanı -->
            <main class="content-area">
                <h2 class="text-2xl font-semibold mb-4">Siparişleriniz</h2>
                <div class="gridview-container">
                    <asp:GridView ID="gvSiparisler" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="table-auto w-full"
                        DataKeyNames="SiparisID"
                        AutoGenerateSelectButton="True"
                        OnSelectedIndexChanged="gvSiparisler_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="SiparisID" HeaderText="Sipariş No" />
                            <asp:BoundField DataField="SiparisTarihi" HeaderText="Tarih" DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                            <asp:BoundField DataField="Durum" HeaderText="Durum" />
                            <asp:BoundField DataField="ToplamFiyat" HeaderText="Toplam Tutar (₺)" DataFormatString="{0:C}" />
                            <asp:CommandField ShowSelectButton="True" SelectText="Seç" />
                        </Columns>
                    </asp:GridView>

                </div>

             <!-- Sipariş Detayları -->
                <h3 class="text-xl font-semibold mt-8 mb-4">Sipariş Detayları</h3>
                <div class="gridview-container">
                    <asp:GridView ID="gvSiparisDetaylari" runat="server" AutoGenerateColumns="False" CssClass="table-auto w-full">
                        <Columns>
                            <asp:TemplateField HeaderText="Ürün">
                                <ItemTemplate>
                                    <asp:Image ID="imgUrun" runat="server"
                                        ImageUrl='<%# VirtualPathUtility.ToAbsolute("~/images/" + Eval("resimUrl")) %>'
                                        CssClass="urun-resmi"
                                        Height="80" Width="80"
                                        AlternateText='<%# Eval("urunAdi") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="urunAdi" HeaderText="Ürün Adı" />
                            <asp:BoundField DataField="adet" HeaderText="Adet" />
                            <asp:BoundField DataField="fiyat" HeaderText="Birim Fiyat (₺)" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>
                </div>


            </main>
        </div>
    </form>
</body>
</html>
