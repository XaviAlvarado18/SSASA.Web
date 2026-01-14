<%@ Page Title="Reportes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Reports.aspx.cs" Inherits="SSASA.Web.Reports" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

  <h2 class="mb-3">Reporte de Empleados</h2>

  <div class="cardx mb-3">
    <div class="cardx-body">
      <div class="row g-2 align-items-end">

        <div class="col-md-3">
          <label class="form-label">Departamento</label>
          <asp:DropDownList ID="ddlDept" runat="server" CssClass="form-select" />
        </div>

        <div class="col-md-2">
          <label class="form-label">Estatus</label>
          <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
            <asp:ListItem Text="Todos" Value="" />
            <asp:ListItem Text="Activos" Value="1" />
            <asp:ListItem Text="Inactivos" Value="0" />
          </asp:DropDownList>
        </div>

        <div class="col-md-2">
          <label class="form-label">Ingreso desde</label>
          <asp:TextBox ID="txtStart" runat="server" CssClass="form-control" TextMode="Date" />
        </div>

        <div class="col-md-2">
          <label class="form-label">Ingreso hasta</label>
          <asp:TextBox ID="txtEnd" runat="server" CssClass="form-control" TextMode="Date" />
        </div>

        <div class="col-md-3 d-flex gap-2">
          <asp:Button ID="btnFilter" runat="server" Text="Filtrar" CssClass="btn btn-primary"
              OnClick="btnFilter_Click" />
          <asp:Button ID="btnClear" runat="server" Text="Limpiar" CssClass="btn btn-outline-secondary"
              OnClick="btnClear_Click" CausesValidation="false" />
        </div>

      </div>
    </div>
  </div>

  <div class="cardx">
    <div class="cardx-body">
      <asp:GridView ID="gvReport" runat="server"
          CssClass="table align-middle"
          AutoGenerateColumns="false"
          AllowPaging="true"
          PageSize="10"
          OnPageIndexChanging="gvReport_PageIndexChanging">

        <Columns>
          <asp:BoundField DataField="EmployeeId" HeaderText="ID" />
          <asp:BoundField DataField="FullNames" HeaderText="Nombre" />
          <asp:BoundField DataField="DepartmentName" HeaderText="Departamento" />

          <asp:TemplateField HeaderText="Estatus">
            <ItemTemplate>
              <%# Convert.ToBoolean(Eval("IsActive")) ? "Activo" : "Inactivo" %>
            </ItemTemplate>
          </asp:TemplateField>

          <asp:BoundField DataField="Age" HeaderText="Edad" />

          <asp:BoundField DataField="HireDate" HeaderText="Ingreso" DataFormatString="{0:dd/MM/yyyy}" />
          <asp:BoundField DataField="Tenure" HeaderText="Antigüedad" />
        </Columns>

      </asp:GridView>
    </div>
  </div>

</asp:Content>
