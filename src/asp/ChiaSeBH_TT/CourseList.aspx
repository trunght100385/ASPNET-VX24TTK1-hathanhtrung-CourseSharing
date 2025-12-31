<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CourseList.aspx.cs" Inherits="ChiaSeBH_TT.CourseList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Thư viện khóa học - ThanhTrung CourseShare</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; background-color: #f4f6f9; }
        
        /* --- Header (Giữ nguyên cho đồng bộ) --- */
        .header { background-color: #2c3e50; color: white; padding: 15px 50px; display: flex; justify-content: space-between; align-items: center; }
        .brand { font-size: 24px; font-weight: bold; }
        .brand span { color: #e74c3c; }
        .nav a { color: white; text-decoration: none; margin-left: 20px; font-weight: 500; transition: color 0.3s; }
        .nav a:hover { color: #e74c3c; }

        /* --- Layout chính: Sidebar + Main Content --- */
        .container { max-width: 1200px; margin: 30px auto; padding: 0 15px; display: flex; gap: 30px; }
        
        /* Sidebar (Bộ lọc) */
        .sidebar { width: 260px; flex-shrink: 0; }
        .filter-box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; }
        .filter-header { font-size: 16px; font-weight: bold; margin-bottom: 15px; border-bottom: 2px solid #3498db; padding-bottom: 8px; color: #2c3e50; }
        
        /* Search Box */
        .search-group { display: flex; gap: 5px; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; outline: none; }
        .btn-search { background: #3498db; color: white; border: none; padding: 0 15px; border-radius: 4px; cursor: pointer; }
        .btn-search:hover { background: #2980b9; }

        /* Danh mục List */
        .cat-list { list-style: none; padding: 0; margin: 0; }
        .cat-list li { margin-bottom: 8px; }
        .cat-list a { text-decoration: none; color: #555; display: flex; align-items: center; padding: 8px; border-radius: 4px; transition: 0.2s; }
        .cat-list a:hover { background-color: #f1f1f1; color: #3498db; }
        .cat-list a.active { background-color: #eaf6ff; color: #3498db; font-weight: bold; border-left: 3px solid #3498db; }
        .cat-icon { width: 20px; height: 20px; margin-right: 10px; object-fit: contain; }

        /* Main Content (Danh sách khóa học) */
        .main-content { flex-grow: 1; }
        
        /* Toolbar (Sắp xếp) */
        .toolbar { background: white; padding: 10px 20px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .result-count { color: #777; font-size: 14px; }
        .sort-select { padding: 6px; border: 1px solid #ddd; border-radius: 4px; color: #555; }

        /* GRID SYSTEM (Lưới thẻ bài) */
        .course-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 25px; }
        
        /* Card Design */
        .card { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); transition: all 0.3s ease; border: 1px solid #eee; display: flex; flex-direction: column; }
        .card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.12); }
        
        .card-img-top { width: 100%; height: 160px; object-fit: cover; background: #eee; }
        .card-body { padding: 15px; flex-grow: 1; display: flex; flex-direction: column; }
        
        .card-title { font-size: 17px; font-weight: bold; margin: 0 0 10px; color: #2c3e50; line-height: 1.4; 
                      display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 46px; }
        
        .card-instructor { font-size: 13px; color: #7f8c8d; margin-bottom: 15px; display: flex; align-items: center; }
        .instructor-avatar { width: 24px; height: 24px; border-radius: 50%; background: #ccc; margin-right: 8px; }

        .card-footer-custom { margin-top: auto; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f1f1f1; padding-top: 15px; }
        .price { font-size: 18px; color: #e74c3c; font-weight: bold; }
        .btn-view { background: white; border: 1px solid #3498db; color: #3498db; padding: 5px 15px; border-radius: 20px; text-decoration: none; font-size: 13px; font-weight: 600; transition: 0.2s; }
        .btn-view:hover { background: #3498db; color: white; }

        .footer { background-color: #2c3e50; color: white; text-align: center; padding: 20px; margin-top: 50px; }
        .no-result { text-align: center; padding: 50px; color: #888; width: 100%; font-size: 18px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="brand">ThanhTrung <span>CourseShare</span></div>
            <div class="nav">
                <a href="Home.aspx">Trang chủ</a>
                <a href="CourseList.aspx">Khóa học</a>
                <asp:LoginView runat="server">
                    <AnonymousTemplate><a href="Login.aspx">Đăng nhập</a></AnonymousTemplate>
                    <LoggedInTemplate>
                        <a href="#">Chào, <asp:LoginName runat="server" /></a>
                        <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="margin-left:15px;">Thoát</asp:LinkButton>
                    </LoggedInTemplate>
                </asp:LoginView>
            </div>
        </div>

        <div class="container">
            <div class="sidebar">
                <div class="filter-box">
                    <div class="filter-header">🔍 Tìm kiếm</div>
                    <div class="search-group">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Nhập tên khóa học..."></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Tìm" CssClass="btn-search" OnClick="btnSearch_Click" />
                    </div>
                </div>

                <div class="filter-box">
                    <div class="filter-header">📂 Danh mục</div>
                    <ul class="cat-list">
                        <li>
                            <a href="CourseList.aspx" class='<%= Request.QueryString["cat"] == null ? "active" : "" %>'>
                                Tất cả khóa học
                            </a>
                        </li>
                        <asp:Repeater ID="rptCategories" runat="server">
                            <ItemTemplate>
                                <li>
                                    <a href='CourseList.aspx?cat=<%# Eval("CategoryId") %>' class='<%# IsActive(Eval("CategoryId")) %>'>
                                        <img src='<%# ResolveUrl(Eval("IconUrl").ToString()) %>' class="cat-icon" onerror="this.style.display='none'" />
                                        <%# Eval("CategoryName") %>
                                    </a>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                </div>
            </div>

            <div class="main-content">
                <div class="toolbar">
                    <div class="result-count">
                        <asp:Label ID="lblResultInfo" runat="server" Text="Hiển thị tất cả khóa học"></asp:Label>
                    </div>
                    <div>
                        Sắp xếp: 
                        <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                            <asp:ListItem Value="new">Mới nhất</asp:ListItem>
                            <asp:ListItem Value="popular">Xem nhiều nhất</asp:ListItem>
                            <asp:ListItem Value="price_asc">Giá: Thấp -> Cao</asp:ListItem>
                            <asp:ListItem Value="price_desc">Giá: Cao -> Thấp</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="course-grid">
                    <asp:Repeater ID="rptCourses" runat="server">
                        <ItemTemplate>
                            <div class="card">
                                <img src='<%# ResolveUrl(Eval("ThumbnailUrl").ToString()) %>' class="card-img-top" onerror="this.src='image/default.jpg'" />
                                
                                <div class="card-body">
                                    <h3 class="card-title" title='<%# Eval("Title") %>'><%# Eval("Title") %></h3>
                                    
                                    <div class="card-instructor">
                                        <div class="instructor-avatar"></div>
                                        <span>GV: <%# Eval("InstructorName") %></span>
                                    </div>
                                    
                                    <div class="card-footer-custom">
                                        <div class="price"><%# Eval("Price", "{0:N0} đ") %></div>
                                        <a href='CourseDetail.aspx?id=<%# Eval("CourseId") %>' class="btn-view">Chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="no-result">
                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486754.png" width="100" style="opacity:0.5" /><br /><br />
                    Không tìm thấy khóa học nào phù hợp với yêu cầu của bạn.
                </asp:Panel>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2025 ThanhTrung CourseShare. Học là phải chất!</p>
        </div>
    </form>
</body>
</html>