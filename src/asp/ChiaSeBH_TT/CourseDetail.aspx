<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseDetail.aspx.cs" Inherits="ChiaSeBH_TT.CourseDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chi tiết khóa học</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f6f9; margin: 0; }
        .header { background-color: #2c3e50; color: white; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; }
        .nav a { color: white; text-decoration: none; margin-left: 20px; font-weight: 500; }
        
        .container { max-width: 1100px; margin: 40px auto; display: flex; gap: 40px; }
        
        /* Cột trái: Nội dung */
        .main-content { flex: 2; }
        .course-title { font-size: 32px; font-weight: bold; color: #2c3e50; margin-bottom: 10px; }
        .instructor { color: #7f8c8d; margin-bottom: 20px; font-size: 16px; }
        .course-img { width: 100%; height: 400px; object-fit: cover; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        
        .section-box { background: white; padding: 30px; border-radius: 10px; margin-top: 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .section-head { font-size: 20px; font-weight: bold; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        
        /* Cột phải: Thông tin mua */
        .sidebar { flex: 1; }
        .buy-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); position: sticky; top: 20px; text-align: center; }
        .price { font-size: 32px; color: #e74c3c; font-weight: bold; display: block; margin-bottom: 20px; }
        .btn-buy { background: #e74c3c; color: white; border: none; padding: 15px; width: 100%; font-size: 18px; font-weight: bold; border-radius: 5px; cursor: pointer; transition: 0.3s; }
        .btn-buy:hover { background: #c0392b; }
        .guarantee { font-size: 13px; color: #777; margin-top: 15px; display: block; }

        /* Đề cương bài học */
        .chapter-title { background: #f8f9fa; padding: 10px 15px; font-weight: bold; margin-top: 10px; border-left: 4px solid #3498db; }
        .lesson-item { padding: 10px 15px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
        .lesson-icon { margin-right: 10px; color: #555; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div style="font-size:24px; font-weight:bold;">ThanhTrung <span>CourseShare</span></div>
            <div class="nav">
                <a href="Home.aspx">Trang chủ</a>
                <a href="CourseList.aspx">Khóa học</a>
                <asp:LoginView runat="server">
                    <AnonymousTemplate><a href="Login.aspx">Đăng nhập</a></AnonymousTemplate>
                    <LoggedInTemplate>Chào, <asp:LoginName runat="server" /></LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>

        <div class="container">
            <div class="main-content">
                <h1 class="course-title"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
                <div class="instructor">Giảng viên: <asp:Literal ID="litInstructor" runat="server"></asp:Literal></div>
                
                <asp:Image ID="imgThumbnail" runat="server" CssClass="course-img" />

                <div class="section-box">
                    <div class="section-head">📖 Giới thiệu khóa học</div>
                    <div style="line-height: 1.6; color: #444;">
                        <asp:Literal ID="litDesc" runat="server"></asp:Literal>
                    </div>
                </div>

                <div class="section-box">
                    <div class="section-head">📚 Đề cương bài học</div>
                    <asp:Repeater ID="rptChapters" runat="server" OnItemDataBound="rptChapters_ItemDataBound">
                        <ItemTemplate>
                            <div class="chapter-title">Chương: <%# Eval("Title") %></div>
                            <asp:Repeater ID="rptLessons" runat="server">
                                <ItemTemplate>
                                    <div class="lesson-item">
                                        <span>▶ <%# Eval("Title") %></span>
                                        <span style="color:#999; font-size:13px;">Video</span>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="sidebar">
                <div class="buy-card">
                    <span class="price"><asp:Literal ID="litPrice" runat="server"></asp:Literal></span>
                    
                    <asp:Button ID="btnEnroll" runat="server" Text="Đăng ký học ngay" CssClass="btn-buy" OnClick="btnEnroll_Click" />
                    
                    <asp:Label ID="lblMsg" runat="server" ForeColor="Red" style="display:block; margin-top:10px;"></asp:Label>
                    <span class="guarantee">🔒 Truy cập trọn đời • Học mọi lúc mọi nơi</span>
                </div>
            </div>
        </div>
    </form>
</body>
</html>