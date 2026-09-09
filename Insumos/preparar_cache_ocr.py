from pathlib import Path
import json
import subprocess
import sys


BASE = Path(__file__).resolve().parents[1]
SCRIPT = BASE / "Insumos" / "ocr_validar_pdf_vs_archivo.py"
CONFIG = BASE / "Insumos" / "config_auditoria.json"
CACHE_CONFIG = json.loads(CONFIG.read_text(encoding="utf-8"))
PDF_DIR = BASE / CACHE_CONFIG["pdf_dir"]
CACHE_DIR = BASE / "Cache" / ".ocr_cache"


def main():
    print("Precarga OCR")
    print(f"PDFs: {PDF_DIR}")
    print(f"Cache: {CACHE_DIR}")
    print(f"Base local: {CACHE_DIR / 'ocr_cache.sqlite'}")
    print("")

    limit_input = input("Cuantos OCR nuevos queres precargar? Enter = todos los pendientes: ").strip()

    command = [
        sys.executable,
        str(SCRIPT),
        "--pdf-dir",
        str(PDF_DIR),
        "--cache-dir",
        str(CACHE_DIR),
        "--solo-cache-ocr",
        "--dpi",
        "400",
        "--ocr-engine",
        "rapidocr_layout_fast",
    ]
    if limit_input:
        command.extend(["--max-pdfs", limit_input])

    print("")
    subprocess.run(command, check=False)
    print("")
    input("Proceso finalizado. Presiona Enter para cerrar...")


if __name__ == "__main__":
    main()
