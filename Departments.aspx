<%@ Page Title="Departamentos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Departments.aspx.cs"
    Inherits="SSASA.WebApi.Departments" %>  <%-- Fíjate que diga WebApi --%>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="mb-3">Departamentos</h2>

<div class="d-flex flex-wrap gap-2 align-items-center mb-3">
    <asp:Button ID="btnEditDept" runat="server"
        CssClass="btn btn-outline-secondary pill-btn disabled"
        Text="✏️ Editar"
        Enabled="false"
        OnClick="btnEditDept_Click" />

    <!-- Opcional: botón nuevo -->
    <asp:Button ID="btnAddDept" runat="server"
        CssClass="btn btn-primary pill-btn"
        Text="➕ Nuevo"
        OnClick="btnAddDept_Click" />
</div>

<asp:HiddenField ID="hfDeptSelectedId" runat="server" />

<asp:GridView ID="gvDepartments" runat="server"
    CssClass="table align-middle"
    AutoGenerateColumns="false"
    DataKeyNames="DepartmentId"
    OnSelectedIndexChanged="gvDepartments_SelectedIndexChanged"
    OnRowDataBound="gvDepartments_RowDataBound">

    <SelectedRowStyle CssClass="table-primary" />

    <Columns>
        <asp:CommandField ShowSelectButton="true" SelectText="▸" />
        <asp:BoundField DataField="DepartmentId" HeaderText="ID" />
        <asp:BoundField DataField="Name" HeaderText="Nombre" />
        <asp:TemplateField HeaderText="Estado">
            <ItemTemplate>
                <%# Convert.ToBoolean(Eval("IsActive")) ? "Activo" : "Inactivo" %>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

<!-- MODAL Bootstrap -->
<div class="modal fade" id="deptModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">Editar Departamento</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>

      <div class="modal-body">
        <div class="mb-3">
          <label class="form-label">Nombre</label>
          <asp:TextBox ID="txtDeptName" runat="server" CssClass="form-control" />
        </div>

        <div class="mb-2">
          <label class="form-label">Estado</label>
          <asp:DropDownList ID="ddlDeptActive" runat="server" CssClass="form-select">
            <asp:ListItem Text="Activo" Value="1" />
            <asp:ListItem Text="Inactivo" Value="0" />
          </asp:DropDownList>
        </div>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
        <asp:Button ID="btnSaveDept" runat="server"
            CssClass="btn btn-primary"
            Text="Guardar"
            CausesValidation="false"
            OnClick="btnSaveDept_Click" />
      </div>

    </div>
  </div>
</div>


</asp:Content>
