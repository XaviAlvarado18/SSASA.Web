# SSASA.Web - Employee Management System 🏢

![ASP.NET](https://img.shields.io/badge/Platform-.NET%20Framework%204.8-blue)
![Language](https://img.shields.io/badge/Language-C%23-green)
![UI](https://img.shields.io/badge/UI-Bootstrap%205-purple)

Este repositorio contiene la **Capa de Presentación** del ecosistema SSASA. Es una aplicación web robusta desarrollada en **ASP.NET Web Forms** que implementa una arquitectura desacoplada, consumiendo servicios de backend a través de **SOAP (Web Services)**.

## 🚀 Funcionalidades Principales

* **Gestión de Empleados**: Listado con paginación optimizada, registro de nuevos ingresos y edición de perfiles existentes.
* **Detalles Dinámicos**: Visualización de información extendida (Edad, Género, NIT, DPI) al seleccionar registros en tiempo real.
* **Gestión de Departamentos**: Administración de unidades organizativas con lógica de negocio para activaciones/desactivaciones en cascada.
* **Dashboard de Reportes**: Visualización de métricas críticas (Empleados activos, vacantes, ingresos mensuales) con gráficos dinámicos de **Chart.js**.
* **Búsqueda Avanzada**: Filtrado multidimensional (Nombre, DPI, Departamento) realizado eficientemente desde la UI.

## 🛠️ Stack Tecnológico

* **Frontend**: HTML5, CSS3, JavaScript (ES6+), Bootstrap 5.
* **Backend UI**: C# .NET Framework 4.8 (Web Forms).
* **Comunicación**: WCF / Web Service SOAP (Connected Services).
* **Gráficos**: Chart.js para la representación de datos por departamento.

## 📁 Estructura del Proyecto

* `Employees.aspx`: Vista principal con GridView avanzado y panel lateral de detalles.
* `EmployeeRegistration.aspx`: Formulario de captura de datos con validaciones estrictas de DPI (13 dígitos) y NIT.
* `Departments.aspx`: Interfaz de gestión para la estructura organizacional con soporte para Modales de Bootstrap.
* `Site.Master`: Diseño maestro que implementa el Sidebar, Topbar y la estructura responsiva del sistema.
* `Connected Services/`: Proxies de comunicación generados para el consumo de `EmployeeService.asmx`.

## ⚙️ Configuración del Entorno

1.  **Clonar repositorio**:
    ```bash
    git clone [https://github.com/XaviAlvarado18/SSASA.Web.git](https://github.com/XaviAlvarado18/SSASA.Web.git)
    ```
2.  **Sincronizar Backend**: Asegúrate de que el servicio `SSASA.Services` esté corriendo localmente o en el servidor.
3.  **Actualizar Referencias**: En el Explorador de Soluciones de Visual Studio, haz clic derecho sobre `EmployeesService` y selecciona **"Update Service Reference"**.
4.  **Endpoint**: Verifica que el archivo `Web.config` tenga la dirección correcta del servicio SOAP en la sección `client`.

## 🛡️ Lógica de Negocio y Seguridad

* **Integridad de Datos**: El sistema previene la duplicidad de registros mediante la validación de llaves únicas (DPI) antes de procesar el guardado.
* **Desactivación en Cascada**: Al desactivar un departamento, el sistema actualiza automáticamente el estado de todos los empleados vinculados para mantener la consistencia operativa.

---
**Desarrollado por [XaviAlvarado18](https://github.com/XaviAlvarado18)** *Ingeniería en Ciencias de la Computación*
