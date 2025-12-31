<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="ChiaSeBH_TT.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Super Admin Dashboard</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f0f2f5; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; }
        .container { display: flex; gap: 20px; margin-top: 20px; }
        
        /* Sidebar Styles */
        .sidebar { width: 30%; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); height: fit-content; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; font-size: 13px; }
        .form-control { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-action { width: 100%; padding: 10px; background: #2980b9; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-top: 10px; }
        .btn-action:hover { background: #2471a3; }
        .section-title { border-bottom: 2px solid #2980b9; padding-bottom: 10px; color: #2980b9; margin-top: 0; }

        /* Main Content Styles */
        .main-content { width: 70%; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .grid-view { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .grid-view th { background: #34495e; color: white; padding: 10px; text-align: left; }
        .grid-view td { padding: 10px; border-bottom: 1px solid #ddd; vertical-align: middle; }
        .link-btn { text-decoration: none; font-weight: bold; margin-right: 10px; }
        .alert { color: green; font-weight: bold; margin-bottom: 10px; display: block; }
        .badge { padding: 3px 8px; border-radius: 4px; font-size: 11px; color: white; }
        .bg-admin { background: #e74c3c; } .bg-teacher { background: #27ae60; } .bg-student { background: #f39c12; }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="header">
            <h2>QUẢN TRỊ VIÊN (SUPER ADMIN)</h2>
            <div>
                Xin chào: <asp:Label ID="lblAdminName" runat="server" Font-Bold="true"></asp:Label> | 
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="White">Đăng xuất</asp:LinkButton>
            </div>
        </div>

        <div class="container">
            <div class="sidebar">
                <div class="form-group">
                    <label>CHỌN BẢNG QUẢN LÝ:</label>
                    <asp:DropDownList ID="ddlTables" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlTables_SelectedIndexChanged">
                        <asp:ListItem Value="Users">1. Quản lý Người dùng (Users)</asp:ListItem>
                        <asp:ListItem Value="Categories">2. Quản lý Danh mục (Categories)</asp:ListItem>
                        <asp:ListItem Value="Courses">3. Quản lý Khóa học (Courses)</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <hr />
                <asp:Label ID="lblMsgSide" runat="server" CssClass="alert"></asp:Label>

                <asp:Panel ID="pnlAddUser" runat="server">
                    <h3 class="section-title">+ Thêm User Mới</h3>
                    <div class="form-group"><label>Username:</label><asp:TextBox ID="txtU_User" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group"><label>Password:</label><asp:TextBox ID="txtU_Pass" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox></div>
                    <div class="form-group"><label>Họ tên:</label><asp:TextBox ID="txtU_Name" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group"><label>Email:</label><asp:TextBox ID="txtU_Email" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group">
                        <label>Quyền hạn:</label>
                        <asp:DropDownList ID="ddlU_Role" runat="server" CssClass="form-control">
                            <asp:ListItem Value="3">Học viên (Student)</asp:ListItem>
                            <asp:ListItem Value="2">Giảng viên (Instructor)</asp:ListItem>
                            <asp:ListItem Value="1">Admin</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="btnAddUser" runat="server" Text="Tạo User" CssClass="btn-action" OnClick="btnAddUser_Click" />
                </asp:Panel>

                <asp:Panel ID="pnlAddCat" runat="server" Visible="false">
                    <h3 class="section-title">+ Thêm Danh Mục</h3>
                    <div class="form-group"><label>Tên danh mục:</label><asp:TextBox ID="txtC_Name" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group"><label>Icon (Upload):</label><asp:FileUpload ID="fuC_Icon" runat="server" CssClass="form-control" /></div>
                    <asp:Button ID="btnAddCat" runat="server" Text="Tạo Danh Mục" CssClass="btn-action" OnClick="btnAddCat_Click" />
                </asp:Panel>

                <asp:Panel ID="pnlAddCourse" runat="server" Visible="false">
                    <h3 class="section-title">+ Tạo Khóa Học (Admin)</h3>
                    <div class="form-group"><label>Tên khóa học:</label><asp:TextBox ID="txtCo_Title" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group"><label>Giá tiền:</label><asp:TextBox ID="txtCo_Price" runat="server" CssClass="form-control"></asp:TextBox></div>
                    <div class="form-group"><label>Giảng viên (ID):</label><asp:TextBox ID="txtCo_InstructorId" runat="server" CssClass="form-control" placeholder="Nhập ID User GV"></asp:TextBox></div>
                    <div class="form-group"><label>Danh mục (ID):</label><asp:TextBox ID="txtCo_CatId" runat="server" CssClass="form-control" placeholder="Nhập ID Danh mục"></asp:TextBox></div>
                    <asp:Button ID="btnAddCourse" runat="server" Text="Tạo Khóa Học" CssClass="btn-action" OnClick="btnAddCourse_Click" />
                </asp:Panel>
            </div>

            <div class="main-content">
                <asp:Label ID="lblMsgMain" runat="server" ForeColor="Red"></asp:Label>

                <asp:GridView ID="gvUsers" runat="server" CssClass="grid-view" AutoGenerateColumns="False" DataKeyNames="UserId"
                    OnRowEditing="gvUsers_RowEditing" OnRowCancelingEdit="gvUsers_RowCancelingEdit" 
                    OnRowUpdating="gvUsers_RowUpdating" OnRowDeleting="gvUsers_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="UserId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="Username" HeaderText="Username" ReadOnly="True" />
                        <asp:BoundField DataField="FullName" HeaderText="Họ tên" />
                        <asp:TemplateField HeaderText="Quyền (1=Admin, 2=GV, 3=HV)">
                            <ItemTemplate><%# Eval("RoleId") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditRole" runat="server" Text='<%# Bind("RoleId") %>' Width="30"></asp:TextBox>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="IsActive" HeaderText="Active?" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ControlStyle-CssClass="link-btn" HeaderText="Chức năng" />
                    </Columns>
                </asp:GridView>

                <asp:GridView ID="gvCategories" runat="server" CssClass="grid-view" AutoGenerateColumns="False" DataKeyNames="CategoryId" Visible="false"
                    OnRowEditing="gvCategories_RowEditing" OnRowCancelingEdit="gvCategories_RowCancelingEdit" 
                    OnRowUpdating="gvCategories_RowUpdating" OnRowDeleting="gvCategories_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="CategoryId" HeaderText="ID" ReadOnly="True" />
                        <asp:ImageField DataImageUrlField="IconUrl" HeaderText="Icon" ControlStyle-Width="30px" ReadOnly="True"></asp:ImageField>
                        <asp:BoundField DataField="CategoryName" HeaderText="Tên Danh Mục" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ControlStyle-CssClass="link-btn" HeaderText="Chức năng" />
                    </Columns>
                </asp:GridView>

                <asp:GridView ID="gvCourses" runat="server" CssClass="grid-view" AutoGenerateColumns="False" DataKeyNames="CourseId" Visible="false"
                    OnRowEditing="gvCourses_RowEditing" OnRowCancelingEdit="gvCourses_RowCancelingEdit" 
                    OnRowUpdating="gvCourses_RowUpdating" OnRowDeleting="gvCourses_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="CourseId" HeaderText="ID" ReadOnly="True" />
                        <asp:BoundField DataField="Title" HeaderText="Tên Khóa Học" />
                        <asp:BoundField DataField="Price" HeaderText="Giá" DataFormatString="{0:N0}" />
                        <asp:BoundField DataField="Status" HeaderText="Trạng Thái" />
                        <asp:BoundField DataField="InstructorId" HeaderText="GV ID" ReadOnly="True" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" ControlStyle-CssClass="link-btn" HeaderText="Chức năng" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>