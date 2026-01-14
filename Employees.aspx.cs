using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using SSASA.Web.EmployeesService;

namespace SSASA.WebApi
{
    public partial class Employees : System.Web.UI.Page
    {
        private EmployeeServiceSoapClient Soap() => new EmployeeServiceSoapClient();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SetActionButtonsEnabled(false);
                hfSelectedId.Value = "";
                BindEmployees();
                AutoSelectFirstRowAndShowDetails();
            }
        }

        private void BindEmployees(string filter = "")
        {
            // 1) Traer data desde SOAP
            List<Employee> employees;
            using (var client = Soap())
            {
                employees = client.GetAllEmployees()?.ToList() ?? new List<Employee>();
            }

            // 2) Filtrar en memoria
            if (!string.IsNullOrWhiteSpace(filter))
            {
                string f = filter.Trim();

                employees = employees
                    .Where(x =>
                        (!string.IsNullOrEmpty(x.FullNames) && x.FullNames.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (!string.IsNullOrEmpty(x.DPI) && x.DPI.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (!string.IsNullOrEmpty(x.DepartmentName) && x.DepartmentName.IndexOf(f, StringComparison.OrdinalIgnoreCase) >= 0) ||
                        (x.EmployeeId.ToString().Contains(f))
                    )
                    .ToList();
            }

            // 3) Bind
            gvEmployees.DataSource = employees;
            gvEmployees.DataBind();

            // 4) Limpia selección (para evitar 2 filas resaltadas/estado raro)
            gvEmployees.SelectedIndex = 0;
            hfSelectedId.Value = "";
            SetActionButtonsEnabled(false);

            if (employees.Count > 0)
            {
                // Opcional: auto-seleccionar el primero
                gvEmployees.SelectedIndex = 0;
                int firstId = employees[0].EmployeeId;
                hfSelectedId.Value = firstId.ToString();
                SetActionButtonsEnabled(true);

                using (var client = Soap())
                {
                    var emp = client.GetEmployeeById(firstId);
                    ShowDetails(emp);
                }
            }
            else
            {
                ClearDetails();
            }
        }

        private void AutoSelectFirstRowAndShowDetails()
        {
            var employees = ViewState["Employees"] as List<Employee>;
            if (employees == null || employees.Count == 0) return;

            gvEmployees.SelectedIndex = 0;

            int firstId = employees[0].EmployeeId;
            hfSelectedId.Value = firstId.ToString();

            ShowDetails(firstId, employees[0]);
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            gvEmployees.PageIndex = 0;
            BindEmployees(txtSearch.Text);

            gvEmployees.SelectedIndex = -1;
            hfSelectedId.Value = "";
            SetActionButtonsEnabled(false);
            ClearDetails();
        }

        protected void gvEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;

            e.Row.Style["cursor"] = "pointer";

            // En lugar de escribir el string manual, usamos el método del Framework
            e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackEventReference(gvEmployees, "Select$" + e.Row.RowIndex);
        }

        protected override void Render(HtmlTextWriter writer)
        {
            foreach (GridViewRow row in gvEmployees.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    Page.ClientScript.RegisterForEventValidation(gvEmployees.UniqueID, "Select$" + row.RowIndex);
                }
            }
            base.Render(writer);
        }




        protected void gvEmployees_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (gvEmployees.SelectedDataKey == null) return;

            int id = Convert.ToInt32(gvEmployees.SelectedDataKey.Value);
            hfSelectedId.Value = id.ToString();

            SetActionButtonsEnabled(true);

            using (var client = Soap())
            {
                var emp = client.GetEmployeeById(id);
                ShowDetails(emp);
            }
        }

        private void ShowDetails(Employee emp)
        {
            if (emp == null)
            {
                ClearDetails();
                return;
            }

            lblNombre.Text = emp.FullNames ?? "-";
            lblDepto.Text = string.IsNullOrWhiteSpace(emp.DepartmentName) ? "-" : emp.DepartmentName;
            lblNit.Text = string.IsNullOrWhiteSpace(emp.NIT) ? "-" : emp.NIT;

            // Gender puede venir como string o char dependiendo del proxy
            var g = (emp.Gender).ToString();
            lblGender.Text = g == "M" ? "Masculino" : g == "F" ? "Femenino" : "-";

            // BirthDate puede venir DateTime o string; normalmente DateTime
            lblBirthday.Text = emp.BirthDate.ToString("dd/MM/yyyy");

            // Age si no viene del servicio, puedes calcularlo aquí
            lblAge.Text = CalculateAge(emp.BirthDate).ToString();

            lblActive.Text = emp.IsActive ? "Sí" : "No";
        }

        private int CalculateAge(DateTime birth)
        {
            if (birth == DateTime.MinValue) return 0;
            var today = DateTime.Today;
            int age = today.Year - birth.Year;
            if (birth.Date > today.AddYears(-age)) age--;
            return age;
        }



        private void ShowDetails(int id, Employee rowEmp = null)
        {
            // Si ya te pasaron el Employee (por ejemplo desde el listado), úsalo
            var emp = rowEmp;

            // Si no vino, lo pides al SOAP
            if (emp == null)
            {
                using (var client = new EmployeeServiceSoapClient())
                {
                    emp = client.GetEmployeeById(id);
                }
            }

            if (emp == null)
            {
                ClearDetails();
                return;
            }

            lblNombre.Text = emp.FullNames ?? "-";
            lblDepto.Text = string.IsNullOrWhiteSpace(emp.DepartmentName) ? "-" : emp.DepartmentName;
            lblNit.Text = string.IsNullOrWhiteSpace(emp.NIT) ? "-" : emp.NIT;

            var g = (emp.Gender).ToString();
            lblGender.Text = g == "M" ? "Masculino" : g == "F" ? "Femenino" : "-";

            lblBirthday.Text = emp.BirthDate.ToString("dd/MM/yyyy");
        }


        private void SetActionButtonsEnabled(bool enabled)
        {
            btnEdit.Enabled = enabled;
            btnDelete.Enabled = enabled;


            btnEdit.CssClass = enabled ? "btn btn-outline-secondary pill-btn" : "btn btn-outline-secondary pill-btn disabled";
            btnDelete.CssClass = enabled ? "btn btn-outline-danger pill-btn" : "btn btn-outline-danger pill-btn disabled";
        }


        private void ClearDetails()
        {
            lblNombre.Text = "-";
            lblDepto.Text = "-";
            // lblPuesto.Text = "-";
            // lblEmail.Text = "-";
            // lblTelefono.Text = "-";
            // imgEmployee.Src = "Content/avatar.png";
        }



        protected void btnAdd_Click(object sender, EventArgs e)
        {
            Response.Redirect("EmployeeRegistration.aspx");
        }

        protected void btnEdit_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfSelectedId.Value, out int id) || id <= 0) return;
            Response.Redirect("EmployeeRegistration.aspx?id=" + id);
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfSelectedId.Value, out int id) || id <= 0) return;

            var client = Soap();
            try
            {
                // Opcional: timeout por operación
                client.InnerChannel.OperationTimeout = TimeSpan.FromSeconds(20);

                bool ok = client.DeleteEmployee(id);

                client.Close(); // cerrar OK

                hfSelectedId.Value = "";
                gvEmployees.SelectedIndex = -1;
                SetActionButtonsEnabled(false);
                ClearDetails();

                 BindEmployees(txtSearch.Text);
                 ShowAlert("Empleado eliminado correctamente.");

                
            }
            catch (TimeoutException ex)
            {
                client.Abort();
                ShowAlert("Timeout al eliminar. " + ex.Message);
            }
            catch (System.ServiceModel.CommunicationException ex)
            {
                client.Abort();
                ShowAlert("Error de comunicación con el servicio. " + ex.Message);
            }
            catch (Exception ex)
            {
                client.Abort();
                ShowAlert("Ocurrió un error al intentar eliminar: " + ex.Message);
            }
        }


        private void ShowAlert(string message)
        {
            string script = $"alert('{message}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerControlScript", script, true);
        }

        protected void gvEmployees_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvEmployees.PageIndex = e.NewPageIndex;

            BindEmployees(txtSearch.Text);

            gvEmployees.SelectedIndex = -1;
            hfSelectedId.Value = "";
            SetActionButtonsEnabled(false);
            ClearDetails();
        }

        protected void gvEmployees_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.Pager) return;

            var lbPrev = e.Row.FindControl("lbPrev") as LinkButton;
            var lbNext = e.Row.FindControl("lbNext") as LinkButton;

            if (lbPrev != null && gvEmployees.PageIndex == 0)
            {
                lbPrev.CssClass += " disabled";
                lbPrev.Enabled = false;
            }

            if (lbNext != null && gvEmployees.PageIndex >= gvEmployees.PageCount - 1)
            {
                lbNext.CssClass += " disabled";
                lbNext.Enabled = false;
            }
        }


    }
}
