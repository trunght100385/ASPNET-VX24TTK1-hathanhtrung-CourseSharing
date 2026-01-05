<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InstructorDashboard.aspx.cs" Inherits="ChiaSeBH_TT.InstructorDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Kênh Giảng Viên</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 20px; background: #f5f6fa; }
        .header { background: #2c3e50; color: white; padding: 20px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; }
        .section { background: white; padding: 25px; margin-top: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h3 { border-bottom: 2px solid #3498db; padding-bottom: 10px; color: #2c3e50; margin-top: 0; }
        
        .my-grid { width: 100%; border-collapse: collapse; margin-top: 15px; }
        .my-grid th { background: #34495e; color: white; padding: 12px; text-align: left; }
        .my-grid td { padding: 12px; border-bottom: 1px solid #eee; color: #333; }
        
        .create-form { background: #ecf0f1; padding: 20px; border-radius: 5px; margin-bottom: 20px; display: flex; flex-direction: column; gap: 15px; }
        .form-row { display: flex; gap: 20px; flex-wrap: wrap; }
        .form-group { display: flex; flex-direction: column; flex: 1; }
        .form-group label { font-size: 13px; font-weight: bold; margin-bottom: 5px; }
        .input-text { padding: 8px; border: 1px solid #ccc; border-radius: 4px; }
        .input-area { padding: 8px; border: 1px solid #ccc; border-radius: 4px; height: 80px; font-family: inherit; }
        
        .btn-action { padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; color: white; font-weight: bold; width: fit-content; margin-right: 10px; }
        .btn-save { background-color: #27ae60; }
        .btn-cancel { background-color: #95a5a6; }
        
        .course-thumb { width: 80px; height: 50px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; }
        .btn-grid { margin-right: 10px; text-decoration: none; font-weight: bold; cursor: pointer; border: none; background: none; color: #2980b9; font-size: 14px; }
        .btn-grid.delete { color: #e74c3c; }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="header">
            <div>
                <h1>KÊNH GIẢNG VIÊN</h1>
                <span>Xin chào: <asp:Label ID="lblTeacherName" runat="server" Font-Bold="true" ForeColor="#f1c40f"></asp:Label></span>
            </div>
            <div>
                <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" ForeColor="white" Font-Bold="true">Đăng xuất ➜</asp:LinkButton>
            </div>
        </div>

        <div class="section">
            <h3>1. Thông tin Khóa học</h3>
            <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
            
            <asp:HiddenField ID="hfCourseId" runat="server" />

            <div class="create-form">
                <div class="form-row">
                    <div class="form-group">
                        <label>Tên khóa học:</label>
                        <asp:TextBox ID="txtNewTitle" runat="server" CssClass="input-text"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Giá (VNĐ):</label>
                        <asp:TextBox ID="txtNewPrice" runat="server" CssClass="input-text" TextMode="Number"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Danh mục:</label>
                        <asp:DropDownList ID="ddlCategories" runat="server" CssClass="input-text"></asp:DropDownList>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group" style="flex: 0.5;">
                        <label>Ảnh bìa (Nếu không đổi thì để trống):</label>
                        <asp:FileUpload ID="fuThumbnail" runat="server" CssClass="input-text" />
                        <asp:Image ID="imgCurrentThumb" runat="server" Visible="false" Width="100" style="margin-top:5px;" />
                    </div>
                    
                    <div class="form-group" style="flex: 1.5;">
                        <label>Phương thức học (Hướng dẫn):</label>
                        <asp:TextBox ID="txtMethod" runat="server" CssClass="input-area" TextMode="MultiLine"></asp:TextBox>
                    </div>
                </div>

                <div>
                    <asp:Button ID="btnSave" runat="server" Text="+ Thêm mới" CssClass="btn-action btn-save" OnClick="btnSave_Click" />
                    
                    <asp:Button ID="btnCancel" runat="server" Text="Hủy bỏ" CssClass="btn-action btn-cancel" OnClick="btnCancel_Click" Visible="false" />
                </div>
            </div>

            <h3>Danh sách khóa học của tôi</h3>
            <asp:GridView ID="gvMyCourses" runat="server" CssClass="my-grid" AutoGenerateColumns="False" 
                DataKeyNames="CourseId" OnRowCommand="gvMyCourses_RowCommand" OnRowDeleting="gvMyCourses_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="CourseId" HeaderText="ID" />
                    <asp:TemplateField HeaderText="Ảnh">
                        <ItemTemplate><img src='<%# ResolveUrl(Eval("ThumbnailUrl").ToString()) %>' class="course-thumb" /></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Tên khóa học" />
                    <asp:BoundField DataField="Price" HeaderText="Giá bán" DataFormatString="{0:N0}" />
                    <asp:BoundField DataField="Status" HeaderText="Trạng thái" />
                    
                    <asp:TemplateField HeaderText="Chức năng">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCourse" CommandArgument='<%# Eval("CourseId") %>' CssClass="btn-grid">✎ Sửa</asp:LinkButton>
                            
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("CourseId") %>' CssClass="btn-grid delete" OnClientClick="return confirm('Bạn chắc chắn muốn xóa?');">🗑 Xóa</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>