<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="signin.aspx.cs" Inherits="eticaretcanta.html.signin" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Kayıt Ol</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server" class="auth-form">
        <h2>Kayıt Ol</h2>

        <asp:TextBox ID="txtAd" runat="server" CssClass="input-box" placeholder="Adınız"></asp:TextBox>
        <asp:TextBox ID="txtSoyad" runat="server" CssClass="input-box" placeholder="Soyadınız"></asp:TextBox>
        <asp:TextBox ID="txtKullaniciAdi" runat="server" CssClass="input-box" placeholder="Kullanıcı Adı"></asp:TextBox>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-box" placeholder="E-posta" TextMode="Email"></asp:TextBox>
        <asp:TextBox ID="txtSifre" runat="server" CssClass="input-box" placeholder="Şifre" TextMode="Password"></asp:TextBox>

        <asp:Button ID="btnKayitOl" runat="server" Text="Kayıt Ol" CssClass="btn" OnClick="btnKayitOl_Click" />

        <asp:Label ID="lblHataMesaji" runat="server" ForeColor="Red" CssClass="error-label"></asp:Label>

        <p>Zaten hesabınız var mı? <a href="login.aspx">Giriş Yap</a></p>
    </form>
</body>
</html>
