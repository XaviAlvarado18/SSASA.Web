using System;
using System.Linq;
using System.Collections.Generic;
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
        }
    }
}
