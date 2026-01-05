<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ChiaSeBH_TT.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Đăng nhập - ThanhTrung CourseShare</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-container { background: white; padding: 40px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        .brand { font-size: 24px; font-weight: bold; margin-bottom: 20px; color: #2c3e50; }
        .brand span { color: #e74c3c; }
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-group label { display: block; margin-bottom: 5px; color: #666; font-weight: 500; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        .btn-login { width: 100%; padding: 10px; background-color: #3498db; color: white; border: none; border-radius: 4px; font-size: 16px; cursor: pointer; margin-top: 10px; }
        .btn-login:hover { background-color: #2980b9; }
        .error-msg { color: #e74c3c; font-size: 14px; margin-top: 15px; display: block; }
        .links { margin-top: 20px; font-size: 13px; }
        .links a { color: #3498db; text-decoration: none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="brand">ThanhTrung <span>CourseShare</span></div>
            
            <div class="form-group">
                <label>Tên đăng nhập</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Nhập username..."></asp:TextBox>
            </div>
            
            <div class="form-group">
                <label>Mật khẩu</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Nhập mật khẩu..."></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Đăng nhập" CssClass="btn-login" OnClick="btnLogin_Click" />
            
            <asp:Label ID="lblMessage" runat="server" CssClass="error-msg" Visible="false"></asp:Label>

            <div class="links">
                <a href="Home.aspx">← Quay lại trang chủ</a>
            </div>
        </div>
    </form>
</body>
</html>