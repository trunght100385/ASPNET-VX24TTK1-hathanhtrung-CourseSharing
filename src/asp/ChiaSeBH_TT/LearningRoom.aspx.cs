using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChiaSeBH_TT
{
    public partial class LearningRoom : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;
        int courseId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (Request.QueryString["courseId"] != null)
            {
                courseId = int.Parse(Request.QueryString["courseId"]);
            }
            else
            {
                Response.Redirect("MyCourses.aspx");
            }

            if (!IsPostBack)
            {
                if (!CheckAccess(courseId))
                {
                    Response.Write("<script>alert('Bạn chưa đăng ký khóa học này!'); window.location='CourseDetail.aspx?id=" + courseId + "';</script>");
                    return;
                }
                LoadCourseContent();
            }
        }

        private bool CheckAccess(int cid)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) FROM Enrollments WHERE UserId = @uid AND CourseId = @cid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@cid", cid);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                if (Session["RoleId"]?.ToString() == "1" || Session["RoleId"]?.ToString() == "2") return true;
                return count > 0;
            }
        }

        private void LoadCourseContent()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Lấy thông tin khóa học (Tiêu đề, Phương thức, Link Zoom)
                // Lưu ý: Đã fix lỗi SQL tại đây bằng cách thêm cột MeetingUrl ở Bước 1
                string sqlInfo = "SELECT Title, LearningMethod, MeetingUrl FROM Courses WHERE CourseId = @cid";
                SqlCommand cmd = new SqlCommand(sqlInfo, conn);
                cmd.Parameters.AddWithValue("@cid", courseId);

                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    litCourseTitle.Text = r["Title"].ToString();

                    // --- HIỂN THỊ PHƯƠNG THỨC HỌC ---
                    string method = r["LearningMethod"] != DBNull.Value ? r["LearningMethod"].ToString() : "";
                    if (string.IsNullOrEmpty(method))
                    {
                        litMethod.Text = "Giảng viên chưa cập nhật hướng dẫn.";
                    }
                    else
                    {
                        litMethod.Text = method.Replace("\n", "<br/>");
                    }

                    // --- HIỂN THỊ NÚT ZOOM ---
                    string meetUrl = r["MeetingUrl"] != DBNull.Value ? r["MeetingUrl"].ToString() : "";

                    if (!string.IsNullOrEmpty(meetUrl))
                    {
                        pnlZoom.Visible = true;
                        hlJoinZoom.NavigateUrl = meetUrl;
                    }
                    else
                    {
                        pnlZoom.Visible = false;
                    }
                }
                r.Close();

                // 2. Load danh sách bài học
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Chapters WHERE CourseId = @cid ORDER BY SortOrder", conn);
                da.SelectCommand.Parameters.AddWithValue("@cid", courseId);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptChapters.DataSource = dt;
                    rptChapters.DataBind();
                }
                else
                {
                    lblMsg.Text = "Khóa học này chưa có nội dung bài giảng nào.";
                }
            }
        }

        protected void rptChapters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int chapterId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ChapterId"));
                Repeater rptLessons = (Repeater)e.Item.FindControl("rptLessons");

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT Title, ContentUrl FROM Lessons WHERE ChapterId = @chapId ORDER BY SortOrder", conn);
                    da.SelectCommand.Parameters.AddWithValue("@chapId", chapterId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptLessons.DataSource = dt;
                    rptLessons.DataBind();
                }
            }
        }
    }
}