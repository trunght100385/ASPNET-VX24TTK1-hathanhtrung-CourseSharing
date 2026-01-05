using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration; // Cần thiết để đọc Web.config

namespace ChiaSeBH_TT
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nếu đã đăng nhập rồi thì đẩy về Home
            if (Session["UserId"] != null)
            {
                Response.Redirect("Home.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 1. Kiểm tra nhập liệu
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Vui lòng nhập đầy đủ thông tin!";
                lblMessage.Visible = true;
                return;
            }

            // 2. Kết nối CSDL để kiểm tra
            string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Câu lệnh SQL kiểm tra user và pass (lấy thêm RoleId để phân quyền)
                // Lưu ý: PasswordHash ở đây đang lưu text thường để demo
                string query = "SELECT UserId, FullName, RoleId FROM Users WHERE Username = @u AND PasswordHash = @p";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@u", username);
                cmd.Parameters.AddWithValue("@p", password);

                try
                {
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        // Lưu Session
                        Session["UserId"] = reader["UserId"];
                        Session["FullName"] = reader["FullName"];
                        Session["RoleId"] = reader["RoleId"];

                        int roleId = Convert.ToInt32(reader["RoleId"]);

                        // PHÂN QUYỀN ĐIỀU HƯỚNG (ĐÃ CẬP NHẬT)
                        switch (roleId)
                        {
                            case 1: // Admin
                                Response.Redirect("AdminDashboard.aspx");
                                break;
                            case 2: // Giáo viên (Instructor)
                                Response.Redirect("InstructorDashboard.aspx");
                                break;
                            case 3: // Học viên (Student)
                                    // Học viên thì về trang chủ để xem khóa học
                                Response.Redirect("Home.aspx");
                                break;
                            default:
                                Response.Redirect("Home.aspx");
                                break;
                        }
                    }
                    else
                    {
                        // Đăng nhập thất bại
                        lblMessage.Text = "Sai tên đăng nhập hoặc mật khẩu!";
                        lblMessage.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Lỗi hệ thống: " + ex.Message;
                    lblMessage.Visible = true;
                }
            }
        }
    }
}