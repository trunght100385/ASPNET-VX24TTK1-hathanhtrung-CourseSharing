<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="ChiaSeBH_TT.Home" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ThanhTrung CourseShare - Trang chủ</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; background-color: #f8f9fa; }
        .header { background-color: #2c3e50; color: white; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; }
        .brand { font-size: 24px; font-weight: bold; }
        .brand span { color: #e74c3c; }
        .nav a { color: white; text-decoration: none; margin-left: 20px; font-weight: 500; transition: color 0.3s; }
        .nav a:hover { color: #e74c3c; }
        
        .hero { 
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('image/banner.jpg'); 
            background-size: cover; background-position: center;
            height: 350px; display: flex; align-items: center; justify-content: center; text-align: center; color: white; 
        }
        .hero h1 { font-size: 42px; margin: 0; font-weight: 700; }
        .hero p { font-size: 18px; margin-top: 15px; opacity: 0.9; }

        .container { max-width: 1200px; margin: 0 auto; padding: 40px 15px; }
        
        /* Section Header Style */
        .section-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px; border-bottom: 1px solid #ddd; padding-bottom: 10px; }
        .section-title { font-size: 26px; color: #2c3e50; margin: 0; font-weight: 700; }
        .section-link { color: #3498db; text-decoration: none; font-weight: 600; }
        .section-link:hover { text-decoration: underline; }

        /* Grid Layout */
        .course-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(270px, 1fr)); gap: 25px; margin-bottom: 50px; }
        
        /* Course Card */
        .course-card { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: transform 0.3s, box-shadow 0.3s; border: 1px solid #eee; }
        .course-card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
        .course-img { width: 100%; height: 160px; object-fit: cover; background-color: #eee; }
        .course-body { padding: 15px; }
        .course-title { font-size: 17px; font-weight: bold; margin: 0 0 8px; color: #2c3e50; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 42px; }
        .course-instructor { font-size: 13px; color: #7f8c8d; margin-bottom: 10px; }
        .course-meta { display: flex; justify-content: space-between; align-items: center; margin-top: 15px; }
        .price { color: #c0392b; font-weight: bold; font-size: 16px; }
        .btn-detail { background-color: #3498db; color: white; padding: 6px 12px; border-radius: 4px; text-decoration: none; font-size: 13px; }
        .btn-detail:hover { background-color: #2980b9; }

        .footer { background-color: #2c3e50; color: white; text-align: center; padding: 30px; margin-top: 20px; }
        
        /* Badge Mới */
        .badge-new { position: absolute; top: 10px; left: 10px; background: #e74c3c; color: white; padding: 3px 8px; font-size: 11px; border-radius: 4px; font-weight: bold; }
        .card-wrapper { position: relative; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="brand">ThanhTrung <span>CourseShare</span></div>
            <div class="nav">
                <a href="Home.aspx">Trang chủ</a>
                <a href="CourseList.aspx">Tất cả khóa học</a> <asp:LoginView runat="server">
                    <AnonymousTemplate>
                        <a href="Login.aspx">Đăng nhập</a>
                    </AnonymousTemplate>
                    <LoggedInTemplate>
                        <a href="#">Chào, <asp:LoginName runat="server" /></a>
                        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="margin-left:20px;">Thoát</asp:LinkButton>
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>

        <div class="hero">
            <div>
                <h1>Học kỹ năng mới mỗi ngày</h1>
                <p>Khám phá kho tàng kiến thức từ các chuyên gia hàng đầu.</p>
            </div>
        </div>

        <div class="container">
            <div class="section-header">
                <h2 class="section-title">🚀 Khóa học mới phát hành</h2>
                <a href="CourseList.aspx?sort=new" class="section-link">Xem tất cả ></a>
            </div>
            
            <div class="course-grid">
                <asp:Repeater ID="rptNewCourses" runat="server">
                    <ItemTemplate>
                        <div class="course-card card-wrapper">
                            <span class="badge-new">Mới</span>
                            <img src='<%# ResolveUrl(Eval("ThumbnailUrl").ToString()) %>' class="course-img" onerror="this.src='image/default.jpg'" />
                            <div class="course-body">
                                <h3 class="course-title" title='<%# Eval("Title") %>'><%# Eval("Title") %></h3>
                                <div class="course-instructor">GV: <%# Eval("InstructorName") %></div>
                                <div class="course-meta">
                                    <span class="price"><%# Eval("Price", "{0:N0} đ") %></span>
                                    <a href='CourseDetail.aspx?id=<%# Eval("CourseId") %>' class="btn-detail">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="section-header">
                <h2 class="section-title">🔥 Được quan tâm nhiều nhất</h2>
                <a href="CourseList.aspx?sort=popular" class="section-link">Xem tất cả ></a>
            </div>

            <div class="course-grid">
                <asp:Repeater ID="rptTopViewCourses" runat="server">
                    <ItemTemplate>
                        <div class="course-card">
                            <img src='<%# ResolveUrl(Eval("ThumbnailUrl").ToString()) %>' class="course-img" onerror="this.src='image/default.jpg'" />
                            <div class="course-body">
                                <h3 class="course-title" title='<%# Eval("Title") %>'><%# Eval("Title") %></h3>
                                <div class="course-instructor">
                                    👀 <%# Eval("ViewCount") %> lượt xem
                                </div>
                                <div class="course-meta">
                                    <span class="price"><%# Eval("Price", "{0:N0} đ") %></span>
                                    <a href='CourseDetail.aspx?id=<%# Eval("CourseId") %>' class="btn-detail">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2025 ThanhTrung CourseShare. Nền tảng học trực tuyến uy tín.</p>
        </div>
    </form>
</body>
</html>