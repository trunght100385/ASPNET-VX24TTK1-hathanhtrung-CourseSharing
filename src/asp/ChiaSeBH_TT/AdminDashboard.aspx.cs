using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.IO;

namespace ChiaSeBH_TT
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"]?.ToString() != "1") Response.Redirect("Login.aspx");

            if (!IsPostBack)
            {
                lblAdminName.Text = Session["FullName"]?.ToString();
                LoadData("Users"); // Mặc định load Users
            }
        }

        // --- 1. CHUYỂN TAB QUẢN LÝ ---
        protected void ddlTables_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadData(ddlTables.SelectedValue);
        }

        private void LoadData(string table)
        {
            // Reset hiển thị
            pnlAddUser.Visible = false; pnlAddCat.Visible = false; pnlAddCourse.Visible = false;
            gvUsers.Visible = false; gvCategories.Visible = false; gvCourses.Visible = false;
            lblMsgSide.Text = ""; lblMsgMain.Text = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da;
                DataTable dt = new DataTable();

                if (table == "Users")
                {
                    pnlAddUser.Visible = true; gvUsers.Visible = true;
                    da = new SqlDataAdapter("SELECT UserId, Username, FullName, RoleId, IsActive FROM Users", conn);
                    da.Fill(dt);
                    gvUsers.DataSource = dt; gvUsers.DataBind();
                }
                else if (table == "Categories")
                {
                    pnlAddCat.Visible = true; gvCategories.Visible = true;
                    da = new SqlDataAdapter("SELECT * FROM Categories", conn);
                    da.Fill(dt);
                    gvCategories.DataSource = dt; gvCategories.DataBind();
                }
                else if (table == "Courses")
                {
                    pnlAddCourse.Visible = true; gvCourses.Visible = true;
                    da = new SqlDataAdapter("SELECT CourseId, Title, Price, Status, InstructorId FROM Courses", conn);
                    da.Fill(dt);
                    gvCourses.DataSource = dt; gvCourses.DataBind();
                }
            }
        }

        // ==========================================
        // KHU VỰC 1: QUẢN LÝ USER (Users)
        // ==========================================
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO Users (Username, PasswordHash, FullName, Email, RoleId, IsActive) VALUES (@u, @p, @n, @e, @r, 1)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@u", txtU_User.Text);
                cmd.Parameters.AddWithValue("@p", txtU_Pass.Text); // Lưu ý: Demo nên chưa mã hóa
                cmd.Parameters.AddWithValue("@n", txtU_Name.Text);
                cmd.Parameters.AddWithValue("@e", txtU_Email.Text);
                cmd.Parameters.AddWithValue("@r", ddlU_Role.SelectedValue);
                conn.Open();
                try { cmd.ExecuteNonQuery(); lblMsgSide.Text = "Thêm User thành công!"; LoadData("Users"); }
                catch (Exception ex) { lblMsgSide.Text = "Lỗi: " + ex.Message; lblMsgSide.ForeColor = System.Drawing.Color.Red; }
            }
        }

        protected void gvUsers_RowEditing(object sender, GridViewEditEventArgs e) { gvUsers.EditIndex = e.NewEditIndex; LoadData("Users"); }
        protected void gvUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) { gvUsers.EditIndex = -1; LoadData("Users"); }

        protected void gvUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
            string name = (gvUsers.Rows[e.RowIndex].Cells[2].Controls[0] as TextBox).Text;
            // Lấy Role từ TemplateField
            string role = (gvUsers.Rows[e.RowIndex].FindControl("txtEditRole") as TextBox).Text;
            bool active = (gvUsers.Rows[e.RowIndex].Cells[4].Controls[0] as CheckBox).Checked;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Users SET FullName=@n, RoleId=@r, IsActive=@a WHERE UserId=@id", conn);
                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@r", role);
                cmd.Parameters.AddWithValue("@a", active);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open(); cmd.ExecuteNonQuery();
            }
            gvUsers.EditIndex = -1; LoadData("Users");
        }

        protected void gvUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Xóa ràng buộc trước (Logs, Reviews, Enrollments...) - Demo xóa nhanh
                try
                {
                    new SqlCommand("DELETE FROM Users WHERE UserId=" + id, conn).ExecuteNonQuery();
                    LoadData("Users");
                }
                catch { lblMsgMain.Text = "Không thể xóa User này do dính dữ liệu khóa học/đơn hàng!"; }
            }
        }

        // ==========================================
        // KHU VỰC 2: QUẢN LÝ DANH MỤC (Categories)
        // ==========================================
        protected void btnAddCat_Click(object sender, EventArgs e)
        {
            string icon = "~/image/default.png";
            if (fuC_Icon.HasFile)
            {
                string fn = DateTime.Now.Ticks + "_" + Path.GetFileName(fuC_Icon.FileName);
                fuC_Icon.SaveAs(Server.MapPath("~/image/") + fn);
                icon = "~/image/" + fn;
            }
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Categories (CategoryName, IconUrl) VALUES (@n, @i)", conn);
                cmd.Parameters.AddWithValue("@n", txtC_Name.Text);
                cmd.Parameters.AddWithValue("@i", icon);
                conn.Open(); cmd.ExecuteNonQuery();
            }
            LoadData("Categories");
        }
        // (Logic Sửa/Xóa Category giống bài trước, đã tích hợp trong Grid)
        protected void gvCategories_RowEditing(object sender, GridViewEditEventArgs e) { gvCategories.EditIndex = e.NewEditIndex; LoadData("Categories"); }
        protected void gvCategories_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) { gvCategories.EditIndex = -1; LoadData("Categories"); }
        protected void gvCategories_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);
            string name = (gvCategories.Rows[e.RowIndex].Cells[2].Controls[0] as TextBox).Text;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open(); new SqlCommand($"UPDATE Categories SET CategoryName=N'{name}' WHERE CategoryId={id}", conn).ExecuteNonQuery();
            }
            gvCategories.EditIndex = -1; LoadData("Categories");
        }
        protected void gvCategories_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            try
            {
                int id = Convert.ToInt32(gvCategories.DataKeys[e.RowIndex].Value);
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open(); new SqlCommand($"DELETE FROM Categories WHERE CategoryId={id}", conn).ExecuteNonQuery();
                }
                LoadData("Categories");
            }
            catch { lblMsgMain.Text = "Không thể xóa danh mục đang có khóa học!"; }
        }

        // ==========================================
        // KHU VỰC 3: QUẢN LÝ KHÓA HỌC (Courses)
        // ==========================================
        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO Courses (Title, Slug, Price, InstructorId, CategoryId, Status, ThumbnailUrl, CreatedAt) VALUES (@t, @s, @p, @i, @c, 1, '~/image/default.jpg', GETDATE())";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@t", txtCo_Title.Text);
                cmd.Parameters.AddWithValue("@s", "course-" + DateTime.Now.Ticks);
                cmd.Parameters.AddWithValue("@p", txtCo_Price.Text);
                cmd.Parameters.AddWithValue("@i", txtCo_InstructorId.Text); // ID Giảng viên
                cmd.Parameters.AddWithValue("@c", txtCo_CatId.Text); // ID Danh mục
                conn.Open();
                try { cmd.ExecuteNonQuery(); lblMsgSide.Text = "Đã tạo khóa học!"; LoadData("Courses"); }
                catch (Exception ex) { lblMsgSide.Text = "Lỗi (Check ID GV/Cate): " + ex.Message; }
            }
        }

        protected void gvCourses_RowEditing(object sender, GridViewEditEventArgs e) { gvCourses.EditIndex = e.NewEditIndex; LoadData("Courses"); }
        protected void gvCourses_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e) { gvCourses.EditIndex = -1; LoadData("Courses"); }

        protected void gvCourses_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);
            string title = (gvCourses.Rows[e.RowIndex].Cells[1].Controls[0] as TextBox).Text;
            string price = (gvCourses.Rows[e.RowIndex].Cells[2].Controls[0] as TextBox).Text;
            string status = (gvCourses.Rows[e.RowIndex].Cells[3].Controls[0] as TextBox).Text;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Courses SET Title=@t, Price=@p, Status=@s WHERE CourseId=@id", conn);
                cmd.Parameters.AddWithValue("@t", title);
                cmd.Parameters.AddWithValue("@p", price);
                cmd.Parameters.AddWithValue("@s", status);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open(); cmd.ExecuteNonQuery();
            }
            gvCourses.EditIndex = -1; LoadData("Courses");
        }

        protected void gvCourses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvCourses.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                try
                {
                    new SqlCommand("DELETE FROM Courses WHERE CourseId=" + id, conn).ExecuteNonQuery();
                    LoadData("Courses");
                }
                catch { lblMsgMain.Text = "Không thể xóa khóa học đã có người mua!"; }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon(); Response.Redirect("Login.aspx");
        }
    }
}