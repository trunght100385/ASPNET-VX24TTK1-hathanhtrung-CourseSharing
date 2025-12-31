<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearningRoom.aspx.cs" Inherits="ChiaSeBH_TT.LearningRoom" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Vào học - ThanhTrung CourseShare</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; background: #f9f9f9; padding: 20px; }
        .container { max-width: 900px; margin: 0 auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        
        .header { border-bottom: 2px solid #3498db; padding-bottom: 20px; margin-bottom: 30px; }
        .course-title { font-size: 28px; color: #2c3e50; margin: 0 0 10px 0; }
        
        /* CSS cho phần thông tin phương thức */
        .method-info { background: #eaf6ff; padding: 20px; border-left: 5px solid #3498db; color: #333; line-height: 1.6; border-radius: 4px; }
        
        /* CSS cho nút Zoom */
        .zoom-box { margin-top: 15px; padding-top: 15px; border-top: 1px dashed #bcdff1; }
        .btn-zoom {
            display: inline-block; background-color: #0b5cff; color: white; padding: 10px 20px; 
            border-radius: 30px; text-decoration: none; font-weight: bold; box-shadow: 0 4px 6px rgba(11, 92, 255, 0.3);
            transition: 0.2s;
        }
        .btn-zoom:hover { background-color: #004ad9; transform: translateY(-2px); }

        /* Danh sách bài học */
        .chapter-box { margin-bottom: 20px; }
        .chapter-title { font-size: 18px; font-weight: bold; background: #eee; padding: 10px 15px; border-radius: 5px 5px 0 0; }
        .lesson-list { list-style: none; padding: 0; margin: 0; border: 1px solid #eee; border-top: none; }
        .lesson-item { border-bottom: 1px solid #eee; padding: 15px; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; }
        .lesson-item:hover { background-color: #f9f9f9; }
        .lesson-name { font-weight: 500; color: #333; }
        .btn-link { text-decoration: none; background: #27ae60; color: white; padding: 8px 15px; border-radius: 4px; font-size: 14px; font-weight: bold; }
        .btn-link:hover { background: #219150; }
        
        .back-link { display: inline-block; margin-bottom: 20px; color: #777; text-decoration: none; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <a href="MyCourses.aspx" class="back-link">← Quay lại khóa học của tôi</a>

            <div class="header">
                <h1 class="course-title"><asp:Literal ID="litCourseTitle" runat="server"></asp:Literal></h1>
                
                <div class="method-info">
                    <strong>📌 Phương thức học & Lời nhắn từ Giảng viên:</strong><br />
                    <asp:Literal ID="litMethod" runat="server"></asp:Literal>

                    <asp:Panel ID="pnlZoom" runat="server" Visible="false" CssClass="zoom-box">
                        <p style="margin: 0 0 10px 0; font-weight:bold; color:#0b5cff;">🔴 Lớp học trực tuyến đang diễn ra:</p>
                        <asp:HyperLink ID="hlJoinZoom" runat="server" CssClass="btn-zoom" Target="_blank">
                            📹 Bấm vào đây để tham gia Zoom / Meet
                        </asp:HyperLink>
                    </asp:Panel>
                </div>
            </div>

            <h3>📚 Nội dung bài giảng (Video/Tài liệu):</h3>
            
            <asp:Repeater ID="rptChapters" runat="server" OnItemDataBound="rptChapters_ItemDataBound">
                <ItemTemplate>
                    <div class="chapter-box">
                        <div class="chapter-title">Chương: <%# Eval("Title") %></div>
                        <ul class="lesson-list">
                            <asp:Repeater ID="rptLessons" runat="server">
                                <ItemTemplate>
                                    <li class="lesson-item">
                                        <span class="lesson-name">📄 <%# Eval("Title") %></span>
                                        <a href='<%# Eval("ContentUrl") %>' target="_blank" class="btn-link">▶ Vào học</a>
                                    </li>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ul>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            
            <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>
        </div>
    </form>
</body>
</html>