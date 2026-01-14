using SSASA.Web.EmployeesService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSASA.Web
{
    public partial class Reports : Page
    {
        private EmployeeServiceSoapClient Soap() => new EmployeeServiceSoapClient();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDepartmentsDropdown();
                LoadReport(); // sin filtros
            }
        }

        private void BindDepartmentsDropdown()
        {
            using (var client = Soap())
            {
                var depts = client.GetAllDepartments()?.ToList() ?? new List<Department>();

                ddlDept.Items.Clear();
                ddlDept.Items.Add(new ListItem("Todos", ""));

                foreach (var d in depts)
                    ddlDept.Items.Add(new ListItem(d.Name, d.DepartmentId.ToString()));
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            gvReport.PageIndex = 0;
            LoadReport();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlDept.SelectedValue = "";
            ddlStatus.SelectedValue = "";
            txtStart.Text = "";
            txtEnd.Text = "";
            gvReport.PageIndex = 0;
            LoadReport();
        }

        protected void gvReport_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvReport.PageIndex = e.NewPageIndex;
            LoadReport();
        }

        private void LoadReport()
        {
            int? deptId = int.TryParse(ddlDept.SelectedValue, out var d) ? d : (int?)null;

            bool? status = null;
            if (ddlStatus.SelectedValue == "1") status = true;
            else if (ddlStatus.SelectedValue == "0") status = false;

            DateTime? start = DateTime.TryParse(txtStart.Text, out var s) ? s.Date : (DateTime?)null;
            DateTime? end = DateTime.TryParse(txtEnd.Text, out var en) ? en.Date : (DateTime?)null;

            using (var client = Soap())
            {
                var data = client.GetEmployeeReport(deptId, status, start, end)?.ToList()
                           ?? new List<Employee>();

                gvReport.DataSource = data;
                gvReport.DataBind();
            }
        }
    }
}