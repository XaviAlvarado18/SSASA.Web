using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Services.Description;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using SSASA.Web.EmployeesService;

namespace SSASA.WebApi
{
    public partial class EmployeeRegistration : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (int.TryParse(Request.QueryString["id"], out int id) && id > 0)
                {
                    LoadEmployeeForEdit(id);
                }
                else
                {
                    hfEmployeeId.Value = "0";
                    lblFormTitle.Text = "Employee Registration";
                }
            }
        }

        private void LoadEmployeeForEdit(int id)
        {
            // Si tu formulario usa el servicio SOAP, necesitas un método GetEmployeeById en el servicio.
            // Si NO lo tienes en el servicio, puedes llamar directo a tu DB (DatabaseLogic) o agregarlo al servicio.

            var client = new EmployeeServiceSoapClient();


            var emp = client.GetEmployeeById(id);

            if (emp == null)
            {
                lblServerError.Text = "Empleado no encontrado.";
                return;
            }

            hfEmployeeId.Value = emp.EmployeeId.ToString();
            lblFormTitle.Text = "Editar Empleado";

            txtFullName.Text = emp.FullNames ?? "";
            txtDPI.Text = emp.DPI ?? "";
            txtBirthDate.Text = emp.BirthDate.ToString("yyyy-MM-dd"); // para input type=date
            txtHireDate.Text = emp.HireDate.ToString("yyyy-MM-dd");
            txtAddress.Text = emp.Address ?? "";
            txtNIT.Text = emp.NIT ?? "";

            ddlGender.SelectedValue = emp.Gender.ToString();

            // si agregaste ddlDepartment:
            // ddlDepartment.SelectedValue = emp.DepartmentId.ToString();

            // Opcional: no permitir editar DPI si quieres
            // txtDPI.ReadOnly = true;
        }


        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                Page.Validate();
                if (!Page.IsValid) return;



                ValidateEmployeeInput();

                if (txtDPI.Text.Trim().Length != 13)
                    throw new Exception("El DPI debe tener 13 dígitos.");

                // ✅ Si tus inputs ya son type=date, mejor parsear con invariant "yyyy-MM-dd"
                if (!DateTime.TryParse(txtBirthDate.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime birth))
                    throw new Exception("Fecha de nacimiento inválida.");

                if (!DateTime.TryParse(txtHireDate.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime hire))
                    throw new Exception("Fecha de ingreso inválida.");

                int employeeId = 0;
                int.TryParse(hfEmployeeId.Value, out employeeId);

                var client = new EmployeeServiceSoapClient();

                var emp = new Employee
                {
                    EmployeeId = employeeId,
                    FullNames = txtFullName.Text.Trim(),
                    DPI = txtDPI.Text.Trim(),
                    BirthDate = birth,
                    Gender = ddlGender.SelectedValue[0],
                    HireDate = hire,
                    Address = string.IsNullOrWhiteSpace(txtAddress.Text) ? null : txtAddress.Text.Trim(),
                    NIT = string.IsNullOrWhiteSpace(txtNIT.Text) ? null : txtNIT.Text.Trim(),
                    IsActive = true,
                    DepartmentId = 1
                };

                bool ok = client.SaveEmployee(emp);


                Response.Redirect("EmployeeSaved.aspx?mode=" + (employeeId > 0 ? "edit" : "new"), false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SoapException ex)
            {
                if (ex.Detail.InnerText.Contains("UNIQUE KEY"))
                {
                    ShowAlert("Error: El DPI ingresado ya pertenece a otro empleado registrado.");
                }
                else
                {
                    ShowAlert("Ocurrió un error inesperado en el servidor.");
                }
            }
            catch (Exception ex)
            {
                lblServerError.Text = ex.Message;
            }
        }

        private void ShowAlert(string message)
        {
            string script = $"alert('{message}');";
            ScriptManager.RegisterStartupScript(this, GetType(), "ServerControlScript", script, true);
        }


        private void ClearForm()
        {
            txtFullName.Text = "";
            txtDPI.Text = "";
            txtBirthDate.Text = "";
            ddlDepartment.SelectedIndex = 0;
            txtHireDate.Text = "";
            txtAddress.Text = "";
            txtNIT.Text = "";
            ddlGender.SelectedIndex = 0;
        }

        private void ValidateEmployeeInput()
        {
            if (string.IsNullOrWhiteSpace(txtFullName.Text))
                throw new Exception("El nombre es obligatorio.");

            if (string.IsNullOrWhiteSpace(txtDPI.Text) || txtDPI.Text.Length != 13)
                throw new Exception("El DPI debe tener 13 dígitos.");

            if (!DateTime.TryParse(txtBirthDate.Text, out _))
                throw new Exception("Fecha de nacimiento inválida.");

            if (!DateTime.TryParse(txtHireDate.Text, out _))
                throw new Exception("Fecha de ingreso inválida.");

            if (ddlGender.SelectedIndex < 0)
                throw new Exception("Debe seleccionar género.");
        }


    }
}