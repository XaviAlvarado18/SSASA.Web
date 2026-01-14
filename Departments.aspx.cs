using System;
using System.Linq;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using SSASA.Web.EmployeesService;

namespace SSASA.WebApi
{
    public partial class Departments : System.Web.UI.Page
    {
        private EmployeeServiceSoapClient Soap() => new EmployeeServiceSoapClient();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetDeptEditEnabled(false);
                hfDeptSelectedId.Value = "";
                BindDepartments();
            }
        }

        private void BindDepartments()
        {
            List<Department> depts;
            using (var client = Soap())
            {
                depts = client.GetAllDepartments()?.ToList() ?? new List<Department>();
            }

            gvDepartments.DataSource = depts;
            gvDepartments.DataBind();

            // limpiar selección
            gvDepartments.SelectedIndex = -1;
        }

        protected void gvDepartments_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            e.Row.Style["cursor"] = "pointer";
            e.Row.Attributes["onclick"] =
                Page.ClientScript.GetPostBackEventReference(gvDepartments, "Select$" + e.Row.RowIndex);
        }

        protected void gvDepartments_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvDepartments.SelectedDataKey == null) return;

            int id = Convert.ToInt32(gvDepartments.SelectedDataKey.Value);
            hfDeptSelectedId.Value = id.ToString();

            SetDeptEditEnabled(true);
        }

        private void SetDeptEditEnabled(bool enabled)
        {
            btnEditDept.Enabled = enabled;
            btnEditDept.CssClass = enabled
                ? "btn btn-outline-secondary pill-btn"
                : "btn btn-outline-secondary pill-btn disabled";
        }

        // NUEVO
        protected void btnAddDept_Click(object sender, EventArgs e)
        {
            hfDeptSelectedId.Value = "0";
            txtDeptName.Text = "";
            ddlDeptActive.SelectedValue = "1";
            OpenDeptModal();
        }


        protected void btnEditDept_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfDeptSelectedId.Value, out int id) || id <= 0) return;

            using (var client = Soap())
            {
                var dept = client.GetDepartmentById(id);

                if (dept == null)
                {
                    ShowAlert("No se encontró el departamento.");
                    return;
                }

                txtDeptName.Text = dept.Name ?? "";
                ddlDeptActive.SelectedValue = dept.IsActive ? "1" : "0";
            }

            OpenDeptModal();
        }

        private void OpenDeptModal()
        {
            string script = "var m=new bootstrap.Modal(document.getElementById('deptModal')); m.show();";
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenDeptModal", script, true);
        }

        protected void btnSaveDept_Click(object sender, EventArgs e)
        {
            int.TryParse(hfDeptSelectedId.Value, out int id);

            string name = (txtDeptName.Text ?? "").Trim();
            bool isActive = ddlDeptActive.SelectedValue == "1";

            if (string.IsNullOrWhiteSpace(name))
            {
                ShowAlert("El nombre es requerido.");
                OpenDeptModal();
                return;
            }

            try
            {
                using (var client = Soap())
                {
                    var dept = new Department
                    {
                        DepartmentId = id,
                        Name = name,
                        IsActive = isActive
                    };

                    bool ok = client.SaveDepartment(dept);

                }

                BindDepartments();
                hfDeptSelectedId.Value = "";
                SetDeptEditEnabled(false);

                ShowAlert("Guardado correctamente.");
            }
            catch (Exception ex)
            {
                ShowAlert("Error al guardar: " + ex.Message);
                OpenDeptModal();
            }
        }

        private void ShowAlert(string message)
        {
            message = (message ?? "").Replace("'", "\\'");
            string script = $"alert('{message}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "DeptAlert", script, true);
        }
    }
}
