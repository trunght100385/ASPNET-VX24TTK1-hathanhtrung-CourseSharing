<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="ChiaSeBH_TT.MyCourses" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Góc học tập của tôi</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f4f4; padding: 30px; }
        .container { max-width: 1000px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .course-item { display: flex; border-bottom: 1px solid #eee; padding: 20px 0; align-items: center; }
        .course-img { width: 120px; height: 80px; object-fit: cover; border-radius: 6px; margin-right: 20px; background: #ddd; }
        .course-info { flex: 1; }
        .progress-bar { width: 100%; height: 10px; background: #eee; border-radius: 5px; margin-top: 10px; overflow: hidden; }
        .progress-fill { height: 100%; background: #2ecc71; }
        .btn-learn { background: #3498db; color: white; text-decoration: none; padding: 10px 20px; border-radius: 5px; font-weight: bold; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <h2>🎓 Khóa học của tôi</h2>
                <a href="Home.aspx" style="text-decoration:none;">← Quay lại trang chủ</a>
            </div>
            
            <asp:Repeater ID="rptMyCourses" runat="server">
                <ItemTemplate>
                    <div class="course-item">
                        <img src='<%# ResolveUrl(Eval("ThumbnailUrl").ToString()) %>' class="course-img" />
                        <div class="course-info">
                            <h3 style="margin:0 0 5px 0"><%# Eval("Title") %></h3>
                            <div style="color:#777; font-size:14px;">Giảng viên: <%# Eval("InstructorName") %></div>
                            
                            <div style="display:flex; align-items:center; margin-top:10px;">
                                <div class="progress-bar" style="width:200px; margin-right:10px; margin-top:0;">
                                    <div class="progress-fill" style='width: <%# Eval("Progress") %>%'></div>
                                </div>
                                <span><%# Eval("Progress") %>% hoàn thành</span>
                            </div>
                        </div>
                        <a href='LearningRoom.aspx?courseId=<%# Eval("CourseId") %>' class="btn-learn">Vào học ngay</a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Label ID="lblEmpty" runat="server" Visible="false" Text="Bạn chưa đăng ký khóa học nào."></asp:Label>
        </div>
    </form>
</body>
</html>