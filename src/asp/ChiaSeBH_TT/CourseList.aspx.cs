using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.Security;

namespace ChiaSeBH_TT
{
    public partial class CourseList : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSidebarCategories(); // Tải danh mục bên trái

                // Giữ lại từ khóa tìm kiếm và sort nếu có
                if (Request.QueryString["search"] != null) txtSearch.Text = Request.QueryString["search"];
                if (Request.QueryString["sort"] != null) ddlSort.SelectedValue = Request.QueryString["sort"];

                LoadCourses(); // Tải danh sách khóa học
            }
        }

        // 1. Tải danh mục cho Sidebar
        private void LoadSidebarCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Lấy tất cả danh mục
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Categories", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
        }

        // 2. Tải khóa học (Có lọc và sắp xếp)
        private void LoadCourses()
        {
            string catId = Request.QueryString["cat"];
            string search = Request.QueryString["search"];
            string sort = ddlSort.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT c.CourseId, c.Title, c.Price, c.ThumbnailUrl, u.FullName as InstructorName 
                       FROM Courses c 
                       JOIN Users u ON c.InstructorId = u.UserId 
                       WHERE c.Status = 1";

                // --- SỬA LỖI HIỂN THỊ TÊN DANH MỤC ---
                if (!string.IsNullOrEmpty(catId))
                {
                    sql += " AND c.CategoryId = @catId";

                    // Query phụ để lấy tên danh mục hiển thị cho đẹp
                    string sqlCatName = "SELECT CategoryName FROM Categories WHERE CategoryId = " + catId;
                    SqlDataAdapter daCat = new SqlDataAdapter(sqlCatName, conn);
                    DataTable dtCat = new DataTable();
                    daCat.Fill(dtCat);
                    if (dtCat.Rows.Count > 0)
                    {
                        lblResultInfo.Text = "Đang xem danh mục: " + dtCat.Rows[0]["CategoryName"].ToString();
                    }
                }
                else
                {
                    lblResultInfo.Text = "Tất cả khóa học";
                }
                // ---------------------------------------

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND c.Title LIKE @search";
                    lblResultInfo.Text = $"Kết quả tìm kiếm: \"{search}\"";
                }

                switch (sort)
                {
                    case "popular": sql += " ORDER BY c.ViewCount DESC"; break;
                    case "price_asc": sql += " ORDER BY c.Price ASC"; break;
                    case "price_desc": sql += " ORDER BY c.Price DESC"; break;
                    default: sql += " ORDER BY c.CreatedAt DESC"; break;
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(catId)) cmd.Parameters.AddWithValue("@catId", catId);
                if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@search", "%" + search + "%");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                    pnlNoData.Visible = false;
                }
                else
                {
                    rptCourses.DataSource = null;
                    rptCourses.DataBind();
                    pnlNoData.Visible = true;
                }
            }
        }

        // Sự kiện: Bấm nút Tìm kiếm
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string url = "CourseList.aspx?search=" + txtSearch.Text.Trim();
            if (Request.QueryString["cat"] != null) url += "&cat=" + Request.QueryString["cat"]; // Giữ lại cat nếu đang chọn
            Response.Redirect(url);
        }

        // Sự kiện: Thay đổi Sắp xếp (Dropdown)
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            string url = "CourseList.aspx?sort=" + ddlSort.SelectedValue;
            if (Request.QueryString["cat"] != null) url += "&cat=" + Request.QueryString["cat"];
            if (Request.QueryString["search"] != null) url += "&search=" + Request.QueryString["search"];
            Response.Redirect(url);
        }

        // Hàm hỗ trợ CSS: Highlight danh mục đang chọn
        public string IsActive(object catId)
        {
            if (Request.QueryString["cat"] == catId.ToString()) return "active";
            return "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");
        }
    }
}