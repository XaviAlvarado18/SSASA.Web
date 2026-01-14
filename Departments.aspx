<%@ Page Title="Departamentos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Departments.aspx.cs" Inherits="SSASA.WebApi.Departments" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="mb-3">Departamentos</h2>

    <div class="cardx">
        <div class="cardx-body">

            <asp:GridView ID="gvDepartments" runat="server"
                CssClass="table align-middle"
                AutoGenerateColumns="false"
                DataKeyNames="DepartmentId">

                <Columns>
                    <asp:BoundField DataField="DepartmentId" HeaderText="ID" />
                    <asp:BoundField DataField="Name" HeaderText="Nombre" />

                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <%# (Convert.ToBoolean(Eval("IsActive")) ? "Activo" : "Inactivo") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

        </div>
    </div>

</asp:Content>
