using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.IO;

namespace ChiaSeBH_TT
{
    public partial class InstructorDashboard : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["CourseConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"]?.ToString() != "2") Response.Redirect("Login.aspx");
            if (!IsPostBack)
            {
                lblTeacherName.Text = Session["FullName"]?.ToString();
                LoadCategories();
                LoadData();
            }
        }

        private void LoadCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT CategoryId, CategoryName FROM Categories", conn);
                DataTable dt = new DataTable(); da.Fill(dt);
                ddlCategories.DataSource = dt; ddlCategories.DataTextField = "CategoryName"; ddlCategories.DataValueField = "CategoryId"; ddlCategories.DataBind();
                ddlCategories.Items.Insert(0, new ListItem("-- Chọn danh mục --", "0"));
            }
        }

        private void LoadData()
        {
            int iid = Convert.ToInt32(Session["UserId"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT CourseId, Title, Price, Status, ThumbnailUrl FROM Courses WHERE InstructorId=" + iid + " ORDER BY CourseId DESC", conn);
                DataTable dt = new DataTable(); da.Fill(dt);
                gvMyCourses.DataSource = dt; gvMyCourses.DataBind();
            }
        }

        // --- XỬ LÝ NÚT LƯU (INSERT HOẶC UPDATE) ---
        protected void btnSave_Click(object sender, EventArgs e)
        {
            string title = txtNewTitle.Text.Trim();
            string priceStr = txtNewPrice.Text.Trim();
            string catId = ddlCategories.SelectedValue;
            string method = txtMethod.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(priceStr))
            {
                lblMsg.Text = "Vui lòng nhập tên và giá!"; return;
            }

            // Xử lý Upload Ảnh
            string thumbUrl = "";
            if (fuThumbnail.HasFile)
            {
                string fn = DateTime.Now.Ticks + "_" + Path.GetFileName(fuThumbnail.FileName);
                fuThumbnail.SaveAs(Server.MapPath("~/image/") + fn);
                thumbUrl = "~/image/" + fn;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                // KIỂM TRA: ĐANG THÊM HAY SỬA?
                if (string.IsNullOrEmpty(hfCourseId.Value))
                {
                    // --- CASE 1: INSERT (THÊM MỚI) ---
                    if (string.IsNullOrEmpty(thumbUrl)) thumbUrl = "~/image/default.jpg"; // Ảnh mặc định

                    cmd.CommandText = @"INSERT INTO Courses (Title, Slug, Price, InstructorId, CategoryId, Status, ThumbnailUrl, CreatedAt, LearningMethod) 
                                        VALUES (@t, @s, @p, @i, @c, 0, @img, GETDATE(), @m)";

                    cmd.Parameters.AddWithValue("@s", "course-" + DateTime.Now.Ticks);
                    cmd.Parameters.AddWithValue("@i", Session["UserId"]);
                }
                else
                {
                    // --- CASE 2: UPDATE (CẬP NHẬT) ---
                    string updateSql = "UPDATE Courses SET Title=@t, Price=@p, CategoryId=@c, LearningMethod=@m";

                    // Nếu có up ảnh mới thì cập nhật, không thì giữ nguyên
                    if (!string.IsNullOrEmpty(thumbUrl))
                    {
                        updateSql += ", ThumbnailUrl=@img";
                    }

                    updateSql += " WHERE CourseId=@id";
                    cmd.CommandText = updateSql;
                    cmd.Parameters.AddWithValue("@id", hfCourseId.Value);
                }

                // Tham số chung
                cmd.Parameters.AddWithValue("@t", title);
                cmd.Parameters.AddWithValue("@p", priceStr);
                cmd.Parameters.AddWithValue("@c", catId);
                cmd.Parameters.AddWithValue("@m", method);
                if (!string.IsNullOrEmpty(thumbUrl)) cmd.Parameters.AddWithValue("@img", thumbUrl);

                cmd.ExecuteNonQuery();
            }

            ResetForm();
            LoadData();
            lblMsg.Text = "Lưu dữ liệu thành công!";
            lblMsg.ForeColor = System.Drawing.Color.Green;
        }

        // --- XỬ LÝ SỰ KIỆN GRIDVIEW (BẤM NÚT SỬA) ---
        protected void gvMyCourses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditCourse")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                hfCourseId.Value = id.ToString(); // Lưu ID vào HiddenField

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Lấy toàn bộ thông tin chi tiết để đổ lên form
                    string sql = "SELECT * FROM Courses WHERE CourseId = @id";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        txtNewTitle.Text = r["Title"].ToString();
                        txtNewPrice.Text = Convert.ToInt32(r["Price"]).ToString(); // Bỏ số lẻ
                        ddlCategories.SelectedValue = r["CategoryId"].ToString();
                        txtMethod.Text = r["LearningMethod"].ToString();

                        // Hiện ảnh hiện tại để user biết
                        imgCurrentThumb.ImageUrl = r["ThumbnailUrl"].ToString();
                        imgCurrentThumb.Visible = true;
                    }
                }

                // Đổi trạng thái giao diện sang "Sửa"
                btnSave.Text = "💾 Lưu Cập Nhật";
                btnSave.CssClass = "btn-action btn-save"; // Có thể đổi màu nếu muốn
                btnCancel.Visible = true;
                lblMsg.Text = "Đang sửa khóa học ID: " + id;
                lblMsg.ForeColor = System.Drawing.Color.Blue;
            }
        }

        // --- NÚT HỦY / RESET FORM ---
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ResetForm();
        }

        private void ResetForm()
        {
            hfCourseId.Value = ""; // Xóa ID -> Quay về chế độ Insert
            txtNewTitle.Text = "";
            txtNewPrice.Text = "";
            txtMethod.Text = "";
            ddlCategories.SelectedIndex = 0;
            imgCurrentThumb.Visible = false;

            btnSave.Text = "+ Thêm mới";
            btnCancel.Visible = false;
            lblMsg.Text = "";
        }

        // --- XÓA KHÓA HỌC ---
        protected void gvMyCourses_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            // GridView yêu cầu có hàm này dù xử lý ở RowCommand, để tránh lỗi
            int id = Convert.ToInt32(gvMyCourses.DataKeys[e.RowIndex].Value);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // Check xem có ai mua chưa trước khi xóa (Optional)
                try
                {
                    new SqlCommand("DELETE FROM Courses WHERE CourseId=" + id, conn).ExecuteNonQuery();
                    LoadData();
                    lblMsg.Text = "Đã xóa khóa học!";
                }
                catch
                {
                    lblMsg.Text = "Không thể xóa vì đã có dữ liệu liên quan!";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}