using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ChiaSeBH_TT
{
    public partial class MyCourses : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                LoadEnrolledCourses(userId);
            }
        }

        private void LoadEnrolledCourses(int userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Join bảng Courses và Users (để lấy tên GV) thông qua Enrollments
                string sql = @"
                    SELECT c.CourseId, c.Title, c.ThumbnailUrl, 
                           u.FullName AS InstructorName, 
                           e.Progress 
                    FROM Enrollments e
                    JOIN Courses c ON e.CourseId = c.CourseId
                    JOIN Users u ON c.InstructorId = u.UserId
                    WHERE e.UserId = @uid";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                da.SelectCommand.Parameters.AddWithValue("@uid", userId);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptMyCourses.DataSource = dt;
                    rptMyCourses.DataBind();
                }
                else
                {
                    lblEmpty.Visible = true;
                }
            }
        }
    }
}