using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SSASA.Web
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ej: "/Employees.aspx" o "/Carpeta/Employees.aspx"
            string path = Request.Url.AbsolutePath.ToLowerInvariant();

            // Reset
            SetActive(lnkEmployees, false);
            SetActive(lnkDepartments, false);
            SetActive(lnkReports, false);

            if (path.EndsWith("/employees"))
                SetActive(lnkEmployees, true);
            else if (path.EndsWith("/departments"))
                SetActive(lnkDepartments, true);
            else if (path.EndsWith("/reports"))
                SetActive(lnkReports, true);
        }

        private void SetActive(System.Web.UI.HtmlControls.HtmlAnchor a, bool active)
        {
            // conserva clases existentes
            var cls = (a.Attributes["class"] ?? "").Trim();

            // quita "active" si ya estaba
            cls = System.Text.RegularExpressions.Regex.Replace(cls, @"\bactive\b", "").Trim();

            // agrega active si toca
            if (active) cls = (cls + " active").Trim();

            a.Attributes["class"] = string.IsNullOrWhiteSpace(cls) ? "side-item" : cls;
        }

    }
}