<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="eticaretcanta.html.login" %>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Giriş Yap</title>
    <link rel="stylesheet" href="index.css">
</head>
<body>
    <form id="form1" runat="server" class="auth-form">
        <h2>Giriş Yap</h2>
        
        <asp:TextBox ID="txtEmail" runat="server" CssClass="input-box" placeholder="Kullanıcı Adı"></asp:TextBox>
        <asp:TextBox ID="txtSifre" runat="server" CssClass="input-box" TextMode="Password" placeholder="Şifre"></asp:TextBox>

        <asp:Button ID="btnGiris" runat="server" Text="Giriş Yap" CssClass="btn" OnClick="btnGiris_Click" />

        <asp:Label ID="Label2" runat="server" CssClass="error-label" ForeColor="Red"></asp:Label>

        <p>Hesabınız yok mu? <a href="signin.aspx">Kayıt Ol</a></p>
    </form>
</body>
</html>
