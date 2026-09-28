# Sistema de auditoria OCR CUD

Sistema local para comparar certificados CUD escaneados en PDF contra un archivo Excel de entrada.

## Estructura de trabajo

```text
Etapa 1/
|-- Entrada/
|   |-- Excel_SECLYT/
|   |   |-- DGINC-DA-SECLYT_*.xlsx
|   |-- PDFs/
|       |-- Tanda 1/
|           |-- *.pdf
|-- Salida/
|   |-- auditoria_equipo_consolidado.xlsx
|-- Cache/
|-- Insumos/
|-- .venv/
|-- auditar_todos_pendientes.bat
|-- instalar_auditoria_ocr.bat
|-- preparar_cache_ocr.bat
|-- verificar_estructura_auditoria.bat
```

Los datos reales no forman parte del repositorio. La carpeta `Entrada`, la carpeta `Salida`, la cache y `.venv` estan excluidas mediante `.gitignore`.

## Primera instalacion

1. Instalar Python 3.12.
2. Copiar los datos de trabajo respetando la estructura anterior.
3. Ejecutar `instalar_auditoria_ocr.bat`.
4. Ejecutar `verificar_estructura_auditoria.bat`.

El instalador crea el entorno virtual `.venv` e instala las dependencias OCR localmente.

## Configuracion

Editar solamente `Insumos/config_auditoria.json` para indicar las rutas relativas al repositorio:

```json
{
  "pdf_dir": "Entrada\\PDFs\\Tanda 1",
  "excel_file": "Entrada\\Excel_SECLYT\\DGINC-DA-SECLYT_20260722_162156.xlsx"
}
```

`excel_file` identifica el archivo exacto que se procesara. No es necesario modificar los scripts cuando cambia el nombre de la carpeta PDF o del Excel.

## Ejecucion

Para auditar una tanda de registros pendientes:

```text
auditar_todos_pendientes.bat
```

El sistema consulta la hoja `Auditoria` de `Salida/auditoria_equipo_consolidado.xlsx` y omite los casos ya procesados. Tambien omite filas con `Auditoria - DATOS` informada.

Para precargar OCR sin generar una auditoria:

```text
preparar_cache_ocr.bat
```

## Privacidad

El OCR se ejecuta localmente. No subir PDFs, Excel, cache, salidas ni documentacion interna al repositorio. Verificar siempre `git status` antes de hacer `git push`.
