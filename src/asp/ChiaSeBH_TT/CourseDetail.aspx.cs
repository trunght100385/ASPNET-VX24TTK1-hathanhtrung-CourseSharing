using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChiaSeBH_TT
{
    public partial class CourseDetail : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;
        int courseId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                courseId = int.Parse(Request.QueryString["id"]);
            }
            else
            {
                Response.Redirect("Home.aspx");
            }

            if (!IsPostBack)
            {
                LoadCourseInfo();
                LoadSyllabus();
                CheckEnrollmentStatus(); // Kiểm tra xem đã mua chưa để đổi nút bấm
            }
        }

        // 1. Hiển thị thông tin cơ bản
        private void LoadCourseInfo()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT c.Title, c.Description, c.Price, c.ThumbnailUrl, u.FullName 
                               FROM Courses c 
                               JOIN Users u ON c.InstructorId = u.UserId 
                               WHERE c.CourseId = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", courseId);

                conn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    litTitle.Text = r["Title"].ToString();
                    litInstructor.Text = r["FullName"].ToString();
                    litPrice.Text = string.Format("{0:N0} đ", r["Price"]);
                    imgThumbnail.ImageUrl = ResolveUrl(r["ThumbnailUrl"].ToString());

                    // Xử lý mô tả (nếu null thì hiện mặc định)
                    string desc = r["Description"].ToString();
                    litDesc.Text = string.IsNullOrEmpty(desc) ? "Chưa có mô tả cho khóa học này." : desc.Replace("\n", "<br/>");
                }
            }
        }

        // 2. Hiển thị đề cương (Chương + Bài học)
        private void LoadSyllabus()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Chapters WHERE CourseId = @cid ORDER BY SortOrder", conn);
                da.SelectCommand.Parameters.AddWithValue("@cid", courseId);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptChapters.DataSource = dt;
                rptChapters.DataBind();
            }
        }

        // Sự kiện: Khi mỗi Chương được load -> Load tiếp Bài học bên trong
        protected void rptChapters_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                int chapterId = Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ChapterId"));
                Repeater rptLessons = (Repeater)e.Item.FindControl("rptLessons");

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Lessons WHERE ChapterId = @chapId ORDER BY SortOrder", conn);
                    da.SelectCommand.Parameters.AddWithValue("@chapId", chapterId);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptLessons.DataSource = dt;
                    rptLessons.DataBind();
                }
            }
        }

        // 3. Kiểm tra xem user đã mua khóa này chưa
        private void CheckEnrollmentStatus()
        {
            if (Session["UserId"] != null)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT COUNT(*) FROM Enrollments WHERE UserId = @uid AND CourseId = @cid";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@uid", Session["UserId"]);
                    cmd.Parameters.AddWithValue("@cid", courseId);
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count > 0)
                    {
                        btnEnroll.Text = "Vào học ngay";
                        btnEnroll.CssClass = "btn-buy"; // Có thể đổi màu khác nếu muốn
                        // Nếu muốn, đổi hành động click luôn
                    }
                }
            }
        }

        // 4. Xử lý ĐĂNG KÝ HỌC
        protected void btnEnroll_Click(object sender, EventArgs e)
        {
            // A. Chưa đăng nhập
            if (Session["UserId"] == null)
            {
                // Chuyển sang trang Login, kèm tham số ReturnUrl để đăng nhập xong quay lại đây
                Response.Redirect("Login.aspx?ReturnUrl=CourseDetail.aspx?id=" + courseId);
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);

            // B. Kiểm tra lại lần nữa xem đã mua chưa (để tránh F5 mua 2 lần)
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Check tồn tại
                SqlCommand cmdCheck = new SqlCommand("SELECT COUNT(*) FROM Enrollments WHERE UserId=@u AND CourseId=@c", conn);
                cmdCheck.Parameters.AddWithValue("@u", userId);
                cmdCheck.Parameters.AddWithValue("@c", courseId);

                if ((int)cmdCheck.ExecuteScalar() > 0)
                {
                    // Đã mua rồi -> Chuyển sang trang học
                    Response.Redirect("MyCourses.aspx");
                    return;
                }

                // C. Thực hiện Đăng ký (Insert DB)
                // Lấy giá tiền hiện tại để lưu vào lịch sử giao dịch
                string priceStr = litPrice.Text.Replace(" đ", "").Replace(",", "").Replace(".", "");
                decimal price = decimal.Parse(priceStr);

                string sqlInsert = @"INSERT INTO Enrollments (UserId, CourseId, EnrollmentDate, PricePaid, Progress, IsCompleted) 
                                     VALUES (@uid, @cid, GETDATE(), @price, 0, 0)";

                SqlCommand cmd = new SqlCommand(sqlInsert, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@cid", courseId);
                cmd.Parameters.AddWithValue("@price", price);

                cmd.ExecuteNonQuery();

                // D. Thành công -> Chuyển sang Góc học tập
                Response.Redirect("MyCourses.aspx");
            }
        }
    }
}