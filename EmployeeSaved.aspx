<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Empleado guardado</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            margin:0;
            height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            font-family:Poppins, sans-serif;
            background:linear-gradient(120deg,#dff3ff,#ece7ff);
        }

        .success-card {
            background:#fff;
            padding:40px 50px;
            border-radius:14px;
            text-align:center;
            box-shadow:0 20px 40px rgba(0,0,0,.15);
            animation: pop .4s ease;
        }

        .check {
            font-size:80px;
            color:#22c55e;
            margin-bottom:15px;
        }

        h2 {
            margin:0 0 10px;
            color:#14532d;
        }

        p {
            color:#475569;
            margin-bottom:25px;
        }

        a {
            display:inline-block;
            padding:10px 24px;
            border-radius:8px;
            background:#1780ff;
            color:#fff;
            text-decoration:none;
            font-size:14px;
        }

        @keyframes pop {
            from { transform:scale(.9); opacity:0; }
            to { transform:scale(1); opacity:1; }
        }
    </style>
</head>

<body>
    <div class="success-card">
        <div class="check">
            <i class="fa-solid fa-circle-check"></i>
        </div>

        <h2>Empleado guardado exitosamente</h2>
        <p>La información fue registrada correctamente.</p>

        <a href="Employees.aspx">Volver a empleados</a>
    </div>

    <!-- Redirección automática opcional -->
    <script>
        setTimeout(() => {
            window.location = 'Employees.aspx';
        }, 3500);
    </script>
</body>
</html>
