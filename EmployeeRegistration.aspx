<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeRegistration.aspx.cs" Inherits="SSASA.WebApi.EmployeeRegistration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Employee Registration</title>

    <!-- Fuente + Iconos -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        :root{
            --bg1:#dff3ff;
            --bg2:#ece7ff;
            --card:#eef7ffcc;
            --border:#d6e6f3;
            --text:#1f2a37;
            --muted:#6b7280;
            --primary:#1780ff;
            --primary2:#0e67d6;
            --input:#ffffff;
        }

        *{ box-sizing:border-box; }
        html,body{ height:100%; }
        body{
            margin:0;
            font-family:'Poppins', sans-serif;
            color:var(--text);
            background: linear-gradient(120deg, var(--bg1), var(--bg2));
            position:relative;
            overflow-x:hidden;
        }

        /* ondas suaves tipo la imagen (aproximación sin imagen) */
        body:before, body:after{
            content:"";
            position:absolute;
            inset:auto;
            pointer-events:none;
            opacity:.35;
        }
        body:before{
            left:-120px;
            top:110px;
            width:520px;
            height:260px;
            background:
                radial-gradient(closest-side, transparent 74%, rgba(120,170,210,.35) 76%, transparent 78%) 0 0/70px 70px;
            filter: blur(.2px);
            transform: rotate(-8deg);
        }
        body:after{
            right:-160px;
            top:150px;
            width:620px;
            height:320px;
            background:
                radial-gradient(closest-side, transparent 73%, rgba(140,160,220,.35) 75%, transparent 77%) 0 0/78px 78px;
            filter: blur(.2px);
            transform: rotate(8deg);
        }

        .page{
            min-height:100%;
            display:flex;
            align-items:center;
            justify-content:center;
            padding:36px 18px;
            position:relative;
            z-index:1;
        }

        .card{
            width:min(760px, 96vw);
            background: linear-gradient(180deg, rgba(245,252,255,.85), rgba(237,246,255,.78));
            border:1px solid rgba(214,230,243,.9);
            border-radius:12px;
            box-shadow: 0 18px 40px rgba(31,42,55,.18);
            padding:22px 22px 18px;
            backdrop-filter: blur(6px);
        }

        .title{
            margin:0 0 14px 0;
            font-size:22px;
            font-weight:600;
            color:#1d5f85;
        }

        .grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:14px 22px;
            align-items:start;
        }

        .field label{
            display:block;
            font-size:12.5px;
            font-weight:500;
            color:#2b3a4a;
            margin:0 0 6px 0;
        }

        .control{
            position:relative;
        }

        .icon-left, .icon-right{
            position:absolute;
            top:50%;
            transform:translateY(-50%);
            color:#8aa1b2;
            font-size:14px;
            pointer-events:none;
        }
        .icon-left{ left:10px; }
        .icon-right{ right:10px; }

        .form-control{
            width:100%;
            height:34px;
            border-radius:8px;
            border:1px solid rgba(190,210,225,.85);
            background: var(--input);
            padding:8px 10px;
            outline:none;
            font-size:12.5px;
            transition: box-shadow .15s ease, border-color .15s ease;
        }

        .has-left .form-control{ padding-left:32px; }
        .has-right .form-control{ padding-right:32px; }

        .form-control:focus{
            border-color: rgba(23,128,255,.55);
            box-shadow: 0 0 0 4px rgba(23,128,255,.12);
        }

        /* Dropdown parecido */
        select.form-control{
            appearance:none;
            -webkit-appearance:none;
            -moz-appearance:none;
            background-image:
                linear-gradient(45deg, transparent 50%, #8aa1b2 50%),
                linear-gradient(135deg, #8aa1b2 50%, transparent 50%),
                linear-gradient(to right, transparent, transparent);
            background-position:
                calc(100% - 16px) 14px,
                calc(100% - 11px) 14px,
                calc(100% - 2.2em) 0.5em;
            background-size: 5px 5px, 5px 5px, 1px 1.8em;
            background-repeat:no-repeat;
            padding-right:32px;
        }

        .actions{
            display:flex;
            justify-content:center;
            margin-top:14px;
        }

        .btn-primary{
            border:none;
            height:34px;
            padding:0 26px;
            border-radius:9px;
            color:#fff;
            cursor:pointer;
            font-size:12.5px;
            font-weight:500;
            background: linear-gradient(180deg, var(--primary), var(--primary2));
            box-shadow: 0 10px 18px rgba(23,128,255,.25);
            transition: transform .08s ease, box-shadow .15s ease, filter .15s ease;
        }
        .btn-primary:hover{
            filter: brightness(1.02);
            box-shadow: 0 12px 22px rgba(23,128,255,.28);
        }
        .btn-primary:active{ transform: translateY(1px); }

        /* Responsive */
        @media (max-width: 680px){
            .grid{ grid-template-columns: 1fr; }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
    <asp:HiddenField ID="hfEmployeeId" runat="server" Value="0" />
    <div class="page">
        <div class="card">
            <h2 class="title"><asp:Label ID="lblFormTitle" runat="server" Text="Employee Registration" /></h2>


            <!-- ✅ Resumen de errores (opcional pero recomendado) -->
            <asp:ValidationSummary ID="vs" runat="server"
                DisplayMode="BulletList"
                CssClass="text-danger"
                HeaderText="Revisa lo siguiente:" />

            <!-- ✅ Error de servidor (para try/catch) -->
            <asp:Label ID="lblServerError" runat="server" CssClass="text-danger" />

            <div class="grid">
                <!-- Full Name (Obligatorio) -->
                <div class="field">
                    <label>Nombre completo:</label>
                    <div class="control has-left">
                        <i class="fa-regular fa-user icon-left"></i>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter full names"></asp:TextBox>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="El nombre completo es obligatorio."
                        Display="Dynamic" CssClass="text-danger" />
                </div>

                <div class="field">
                  <label>Departamento:</label>
                  <div class="control">
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-control">
                      <asp:ListItem Text="-- Selecciona un departamento --" Value=""></asp:ListItem>
                      <asp:ListItem Text="Information Technology" Value="2"></asp:ListItem>
                      <asp:ListItem Text="Human Resources" Value="1"></asp:ListItem>
                      <asp:ListItem Text="Finance" Value="3"></asp:ListItem>
                      <asp:ListItem Text="Sales" Value="4"></asp:ListItem>
                      <asp:ListItem Text="Operations" Value="5"></asp:ListItem>
                    </asp:DropDownList>
                  </div>

                  <asp:RequiredFieldValidator ID="rfvDept" runat="server"
                      ControlToValidate="ddlDepartment"
                      InitialValue=""
                      ErrorMessage="Debe seleccionar un departamento."
                      Display="Dynamic" CssClass="text-danger" />
                </div>


                <!-- DPI (Obligatorio + 13 dígitos) -->
                <div class="field">
                    <label>DPI (13 digits):</label>
                    <div class="control has-left">
                        <i class="fa-regular fa-id-card icon-left"></i>
                        <asp:TextBox ID="txtDPI" runat="server" CssClass="form-control" MaxLength="13"
                            placeholder="Enter (13 digits):" onkeypress="return isNumberKey(event)"></asp:TextBox>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvDPI" runat="server"
                        ControlToValidate="txtDPI"
                        ErrorMessage="DPI es obligatorio."
                        Display="Dynamic" CssClass="text-danger" />

                    <asp:RegularExpressionValidator ID="revDPI" runat="server"
                        ControlToValidate="txtDPI"
                        ValidationExpression="^\d{13}$"
                        ErrorMessage="DPI debe contener exactamente 13 dígitos."
                        Display="Dynamic" CssClass="text-danger" />
                </div>

                <!-- Hire Date (Obligatorio + Fecha válida) -->
                <div class="field">
                    <label>Fecha de contratación:</label>
                    <div class="control has-right">
                        <i class="fa-regular fa-calendar icon-right"></i>
                        <asp:TextBox ID="txtHireDate" runat="server" CssClass="form-control" placeholder="dd/mm/aaaa"></asp:TextBox>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvHireDate" runat="server"
                        ControlToValidate="txtHireDate"
                        ErrorMessage="La fecha de contratación es obligatorio."
                        Display="Dynamic" CssClass="text-danger" />

                    <asp:CompareValidator ID="cvHireDate" runat="server"
                        ControlToValidate="txtHireDate"
                        Operator="DataTypeCheck" Type="Date"
                        ErrorMessage="La fecha de contratación no es una fecha válida."
                        Display="Dynamic" CssClass="text-danger" />
                </div>

                <!-- Birth Date (Obligatorio + Fecha válida) -->
                <div class="field">
                    <label>Fecha de nacimiento:</label>
                    <div class="control has-right">
                        <i class="fa-regular fa-calendar icon-right"></i>
                        <asp:TextBox ID="txtBirthDate" runat="server" CssClass="form-control" placeholder="dd/mm/aaaa"
                            onchange="calculateAge(this.value)"></asp:TextBox>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvBirthDate" runat="server"
                        ControlToValidate="txtBirthDate"
                        ErrorMessage="La fecha de nacimiento es obligatorio."
                        Display="Dynamic" CssClass="text-danger" />

                    <asp:CompareValidator ID="cvBirthDate" runat="server"
                        ControlToValidate="txtBirthDate"
                        Operator="DataTypeCheck" Type="Date"
                        ErrorMessage="La fecha de nacimiento no es una fecha válida."
                        Display="Dynamic" CssClass="text-danger" />
                </div>

                <!-- Address (Opcional, sin validar) -->
                <div class="field">
                    <label>Dirección (Opcional):</label>
                    <div class="control">
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                    </div>
                </div>

                <!-- Gender (Obligatorio) -->
                <div class="field">
                    <label>Genero:</label>
                    <div class="control">
                        <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                            <asp:ListItem Text="-- Elige una opción --" Value=""></asp:ListItem>
                            <asp:ListItem Text="Masculino" Value="M"></asp:ListItem>
                            <asp:ListItem Text="Femenino" Value="F"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <asp:RequiredFieldValidator ID="rfvGender" runat="server"
                        ControlToValidate="ddlGender"
                        InitialValue=""
                        ErrorMessage="El genero es obligatorio."
                        Display="Dynamic" CssClass="text-danger" />
                </div>

                <!-- NIT (Opcional) -->
                <div class="field">
                    <label>NIT (Opcional):</label>
                    <div class="control">
                        <asp:TextBox ID="txtNIT" runat="server" CssClass="form-control" placeholder=""></asp:TextBox>
                    </div>
                </div>
            </div>

            <div class="actions">
                <asp:Button ID="btnSave" runat="server" Text="Save Employee"
                    CssClass="btn-primary" OnClick="btnSave_Click"
                    CausesValidation="true" />
            </div>
        </div>
    </div>
</form>


<script type="text/javascript">
    // (Opcional) Para que se vea como la imagen: al enfocar, convierte a date para el picker.
    // Si prefieres SIEMPRE date, dímelo y lo ajusto.
    (function () {
        const b = document.getElementById('<%= txtBirthDate.ClientID %>');
        const h = document.getElementById('<%= txtHireDate.ClientID %>');

        function wire(el) {
            if (!el) return;
            el.addEventListener('focus', function () { this.type = 'date'; });
            el.addEventListener('blur', function () { if (!this.value) this.type = 'text'; });
            if (!el.value) el.type = 'text';
        }
        wire(b); wire(h);
    })();



    function isNumberKey(evt) {
        var charCode = (evt.which) ? evt.which : evt.keyCode;
        if (charCode > 31 && (charCode < 48 || charCode > 57)) return false;
        return true;
    }
</script>
</body>
</html>
