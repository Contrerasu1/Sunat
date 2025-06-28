from fastapi import FastAPI, Query
from playwright.sync_api import sync_playwright
import uvicorn

app = FastAPI()


def consultar_deuda(ruc: str):
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        try:
            page.goto("https://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias")
            page.fill("input[name='search1']", ruc)
            page.click("#btnAceptar")
            page.wait_for_timeout(3000)
            page.click("text=Deuda Coactiva")
            page.wait_for_timeout(3000)
            contenido = page.inner_text("body")
        except Exception as e:
            return None, f"Error durante la consulta: {str(e)}"
        finally:
            browser.close()

        if "No se ha remitido deuda en cobranza coactiva" in contenido:
            return False, "sin deuda coactiva"
        elif "deuda en cobranza coactiva" in contenido.lower():
            return True, "con deuda coactiva"
        else:
            return None, "no se pudo determinar"


@app.get("/verificar-ruc")
def verificar_ruc(ruc: str = Query(..., description="RUC a consultar")):
    resultado, mensaje = consultar_deuda(ruc)
    return {
        "ruc": ruc,
        "resultado": mensaje,
        "ok": resultado is not None
    }


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=10000, reload=True)
