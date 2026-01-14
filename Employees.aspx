<%@ Page Title="Empleados" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="Employees.aspx.cs" Inherits="SSASA.WebApi.Employees" EnableEventValidation="false" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2 class="mb-3">Empleados</h2>

    <div class="row g-3">
        <!-- Tabla -->
        <div class="col-lg-8">
            <div class="cardx">
                <div class="cardx-body">

                    <div class="d-flex flex-wrap gap-2 align-items-center mb-3">
                        <asp:Button ID="btnAdd" runat="server" CssClass="btn btn-primary pill-btn"
                            Text="➕ Agregar Empleado" OnClick="btnAdd_Click" />
                        <asp:Button ID="btnEdit" runat="server" CssClass="btn btn-outline-secondary pill-btn"
                            Text="✏️ Editar" OnClick="btnEdit_Click" Enabled="false" />

                        <asp:Button ID="btnDelete" runat="server"
                                CssClass="btn btn-outline-danger pill-btn"
                                Text="🗑️ Eliminar"
                                OnClick="btnDelete_Click"
                                Enabled="false"
                                CausesValidation="false"
                                OnClientClick="
                                    if(!confirm('¿Eliminar empleado?')) return false;
                                    this.value='Eliminando...';
                                    var b=this; setTimeout(function(){ b.disabled=true; }, 0);
                                    return true;"
                            />



                        <div class="ms-auto d-flex align-items-center gap-2">
                            <span class="text-muted">Buscar:</span>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Width="260"
                                AutoPostBack="true" OnTextChanged="txtSearch_TextChanged" />
                        </div>
                    </div>

                    <asp:HiddenField ID="hfSelectedId" runat="server" />

                    <asp:GridView ID="gvEmployees" runat="server"
                        CssClass="table align-middle"
                        AutoGenerateColumns="false"
                        DataKeyNames="EmployeeId"
                        AllowPaging="true"
                        PageSize="8"
                        OnPageIndexChanging="gvEmployees_PageIndexChanging"
                        OnSelectedIndexChanged="gvEmployees_SelectedIndexChanged"
                        OnRowDataBound="gvEmployees_RowDataBound"
                        OnRowCreated="gvEmployees_RowCreated"
                        >

                        <SelectedRowStyle CssClass="table-primary" />

                        <PagerTemplate>
                            <div class="d-flex justify-content-end align-items-center gap-2 py-2">

                                <!-- Previous -->
                                <asp:LinkButton ID="lbPrev" runat="server"
                                    CommandName="Page" CommandArgument="Prev"
                                    CssClass="pager-btn"
                                    CausesValidation="false"
                                    Text="◀" />

                                <!-- Info opcional -->
                                <span class="text-muted small">
                                    Página <%= gvEmployees.PageIndex + 1 %> de <%= gvEmployees.PageCount %>
                                </span>

                                <!-- Next -->
                                <asp:LinkButton ID="lbNext" runat="server"
                                    CommandName="Page" CommandArgument="Next"
                                    CssClass="pager-btn"
                                    CausesValidation="false"
                                    Text="▶" />

                            </div>
                        </PagerTemplate>

                        <Columns>
                            <asp:CommandField ShowSelectButton="true" SelectText="▸" />
                            <asp:BoundField DataField="EmployeeId" HeaderText="ID" />
                            <asp:BoundField DataField="FullNames" HeaderText="Nombre" />
                            <asp:BoundField DataField="DepartmentName" HeaderText="Departamento" />
                            <asp:BoundField DataField="HireDate" HeaderText="Fecha de Ingreso" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField DataField="Tenure" HeaderText="Antigüedad" />
                        </Columns>
                    </asp:GridView>



                </div>
            </div>
        </div>

        <!-- Detalles -->
        <div class="col-lg-4">
            <div class="cardx h-100">
                <div class="cardx-header">Detalles del Empleado</div>
                <div class="cardx-body">
                    <div class="d-flex gap-3">
                        <img id="imgEmployee" runat="server" src="Content/avatar.png"
                             style="width:90px;height:80px;border-radius:12px;border:1px solid #e6e9f2;" />
                        <div>
                            <h5 class="mb-1"><asp:Label ID="lblNombre" runat="server" Text="-" /></h5>
                            <div class="text-muted mb-2">
                                Departamento: <asp:Label ID="lblDepto" runat="server" Text="-" />
                                <br />NIT: <asp:Label ID="lblNit" runat="server" Text="-" /><br />
                            </div>
                        </div>
                    </div>

                    <hr />

                    <div class="small">
                        <div class="mb-1">Edad: <asp:Label ID ="lblAge" runat="server" Text="-" /></div>
                        <div class="mb-2">Genero: <asp:Label ID="lblGender" runat="server" Text="-" /></div>
                        <div>Fecha de nacimiento: <asp:Label ID="lblBirthday" runat="server" Text="-" /></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Abajo: Donut + tarjetas -->
    <div class="row g-3 mt-1">
        <div class="col-lg-6">
            <div class="cardx">
                <div class="cardx-header">Departamentos</div>
                <div class="cardx-body">
                    <canvas id="deptChart" height="140"></canvas>
                    <asp:HiddenField ID="hfDeptLabels" runat="server" />
                    <asp:HiddenField ID="hfDeptValues" runat="server" />
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="cardx">
                <div class="cardx-header">Reportes Rápidos</div>
                <div class="cardx-body">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="p-3 rounded-4 text-white" style="background:#2f66d5;">
                                <div class="fw-bold">Empleados Activos</div>
                                <div class="display-6"><asp:Label ID="lblActivos" runat="server" Text="0" /></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 rounded-4 text-white" style="background:#ef4444;">
                                <div class="fw-bold">Nuevos Ingresos</div>
                                <div class="display-6"><asp:Label ID="lblNuevos" runat="server" Text="0" /></div>
                                <div class="small">Este mes</div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="p-3 rounded-4 text-white" style="background:#7c3aed;">
                                <div class="fw-bold">Vacantes Abiertas</div>
                                <div class="display-6"><asp:Label ID="lblVacantes" runat="server" Text="0" /></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ScriptsContent" runat="server">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    <script>
        (function () {
            const labels = (document.getElementById('<%= hfDeptLabels.ClientID %>').value || "").split('|').filter(Boolean);
            const values = (document.getElementById('<%= hfDeptValues.ClientID %>').value || "").split('|').filter(Boolean).map(v => parseInt(v, 10));

            const ctx = document.getElementById('deptChart');
            if (!ctx || labels.length === 0) return;

            new Chart(ctx, {
                type: 'doughnut',
                data: { labels, datasets: [{ data: values }] },
                options: { plugins: { legend: { position: 'right' } } }
            });
        })();
    </script>
</asp:Content>
