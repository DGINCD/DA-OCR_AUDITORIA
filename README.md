# Sistema de auditoria OCR CUD

Sistema local para comparar certificados CUD escaneados en PDF contra un archivo Excel de entrada. El OCR se ejecuta con RapidOCR y ONNX Runtime, sin enviar los documentos a servicios externos.

## Que contiene el repositorio

El repositorio contiene el codigo, los lanzadores, la configuracion base y las instrucciones. No contiene datos personales ni archivos operativos.

```text
Etapa 1/
|-- Entrada/                         datos de trabajo, no versionados
|   |-- Excel_SECLYT/                archivos Excel de entrada
|   |   |-- DGINC-DA-SECLYT_*.xlsx
|   |-- PDFs/                         certificados escaneados
|       |-- Tanda 1/                  o el nombre configurado
|           |-- *.pdf
|-- Salida/                           resultados, no versionados
|   |-- auditoria_equipo_consolidado.xlsx
|-- Cache/                            cache OCR, no versionada
|-- .venv/                            entorno virtual, no versionado
|-- Insumos/                          codigo y configuracion versionados
|   |-- ocr_validar_pdf_vs_archivo.py
|   |-- preparar_cache_ocr.py
|   |-- auditar_todos_pendientes.ps1
|   |-- preparar_cache_ocr.ps1
|   |-- instalar_dependencias_ocr.ps1
|   |-- verificar_python_local_ocr.ps1
|   |-- verificar_estructura_auditoria.ps1
|   |-- config_auditoria.json
|   |-- requirements_ocr_auditoria.txt
|-- auditar_todos_pendientes.bat
|-- instalar_auditoria_ocr.bat
|-- preparar_cache_ocr.bat
|-- verificar_estructura_auditoria.bat
|-- README.md
```

Las carpetas `Entrada`, `Salida`, `Cache`, `.venv` y `Documentacion` estan excluidas mediante `.gitignore`. La documentacion interna puede conservarse localmente en `Documentacion`, pero no se publica.

## Instalacion desde GitHub

Crear una carpeta de trabajo y clonar el repositorio:

```powershell
git clone https://github.com/DGINCD/DA-OCR_AUDITORIA.git
cd DA-OCR_AUDITORIA
```

Instalar Python 3.12 para Windows y luego ejecutar:

```text
instalar_auditoria_ocr.bat
```

Este BAT crea `.venv` dentro de la carpeta del proyecto e instala las dependencias de `Insumos\requirements_ocr_auditoria.txt`.

## Archivos que se deben copiar manualmente

Como contienen informacion sensible, estos archivos no se descargan desde GitHub:

1. El Excel de entrada diario en `Entrada\Excel_SECLYT\`.
2. La carpeta completa de PDFs en `Entrada\PDFs\`.
3. `auditoria_equipo_consolidado.xlsx` en `Salida\`, si se quiere continuar una auditoria existente.
4. La cache en `Cache\.ocr_cache\`, solo si se quiere evitar repetir OCR ya realizado. Es opcional y puede regenerarse.

El consolidado es necesario para mantener la secuencia. Su hoja `Auditoria` permite omitir los casos ya procesados aunque el Excel diario cambie de orden.

## Configuracion

Editar solamente `Insumos\config_auditoria.json`:

```json
{
  "pdf_dir": "Entrada\\PDFs\\Tanda 1",
  "excel_file": "Entrada\\Excel_SECLYT\\DGINC-DA-SECLYT_20260722_162156.xlsx"
}
```

`pdf_dir` es la ruta relativa de la carpeta que contiene los PDFs.

`excel_file` es la ruta relativa y el nombre exacto del Excel que se procesara. Si se recibe un archivo nuevo, copiarlo en `Entrada\Excel_SECLYT\` y actualizar esta propiedad.

No es necesario modificar los archivos `.py`, `.ps1` ni `.bat` cuando cambian los nombres de entrada.

## Verificacion previa

Antes de auditar, ejecutar:

```text
verificar_estructura_auditoria.bat
```

La verificacion confirma:

- existencia del JSON de configuracion;
- existencia del Excel configurado;
- existencia de la carpeta PDF;
- cantidad de PDFs disponibles;
- existencia de la carpeta de salida;
- existencia del entorno `.venv`.

Si falta `.venv`, ejecutar nuevamente `instalar_auditoria_ocr.bat`.

## Auditoria de pendientes

Ejecutar desde la raiz del proyecto:

```text
auditar_todos_pendientes.bat
```

El sistema:

1. Lee el Excel definido en `excel_file`.
2. Lee los PDFs de `pdf_dir`.
3. Ordena los documentos por identificador y procesa la cantidad indicada.
4. Usa la cache OCR cuando existe.
5. Omite los PDFs ya registrados en `Salida\auditoria_equipo_consolidado.xlsx`.
6. Omite filas con `Auditoria - DATOS` cuando esa columna existe en el Excel.
7. Agrega el nuevo lote al consolidado.

Cuando pregunta:

```text
Cuantos PDFs pendientes queres auditar? Limit (ej: 5, 10):
```

Ingresar `5`, `10` o la cantidad deseada. No se utiliza `skip`.

## Precarga de OCR

Para preparar cache sin generar una auditoria:

```text
preparar_cache_ocr.bat
```

La cache se guarda en `Cache\.ocr_cache`. Si se elimina, el sistema vuelve a procesar los PDFs que necesite.

## Salida y continuidad

El archivo operativo es:

```text
Salida\auditoria_equipo_consolidado.xlsx
```

La hoja `Auditoria` es el historial principal. Las hojas de detalle permiten revisar alertas, diferencias de campos, detalle CIF y DNIs duplicados.

Para continuar en otra notebook, se debe copiar el consolidado antes de ejecutar nuevas tandas. No se debe reemplazar por un Excel de entrada ni renombrarlo.

## Problemas frecuentes

**No se encuentra el Excel.** Revisar que exista en `Entrada\Excel_SECLYT\` y que `excel_file` coincida exactamente.

**No se encuentran PDFs.** Revisar `pdf_dir` y ejecutar `verificar_estructura_auditoria.bat`.

**No existe `.venv`.** Ejecutar `instalar_auditoria_ocr.bat`.

**El Excel no tiene `Auditoria - DATOS`.** El sistema puede continuar. En ese caso utiliza el consolidado para omitir los casos ya procesados y muestra una advertencia informativa.

**El archivo de salida esta bloqueado.** Cerrar Excel antes de ejecutar el BAT.

## Privacidad y Git

No subir PDFs, Excel, cache, consolidadores, respaldos ni documentacion interna. Antes de publicar cambios:

```powershell
git status
git add .
git commit -m "Descripcion del cambio"
git push
```

Si `git status` muestra archivos dentro de `Entrada`, `Salida`, `Cache` o `.venv`, detenerse y revisar el `.gitignore` antes de continuar.
