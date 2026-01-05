using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.Security;

namespace ChiaSeBH_TT
{
    public partial class Home : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHomeData();
            }
        }

        private void LoadHomeData()
        {
            rptNewCourses.DataSource = GetCourses("c.CourseId DESC", 4);
            rptNewCourses.DataBind();

            rptTopViewCourses.DataSource = GetCourses("c.ViewCount DESC", 4);
            rptTopViewCourses.DataBind();
        }

        private DataTable GetCourses(string orderBy, int top)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = $@"SELECT TOP {top} c.CourseId, c.Title, c.Price, c.ThumbnailUrl, c.ViewCount, u.FullName AS InstructorName 
                                FROM Courses c 
                                JOIN Users u ON c.InstructorId = u.UserId 
                                WHERE c.Status = 1 
                                ORDER BY {orderBy}";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                }
                catch { }
                return dt;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");
        }
    }
}