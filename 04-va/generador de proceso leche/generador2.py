import random
from datetime import datetime, timedelta

# Configuración
CANTIDAD = 5000  # Cambiá este número para generar más o menos EXEC

def fecha_random(inicio, fin):
    return inicio + timedelta(days=random.randint(0, (fin - inicio).days))

def fecha_vencimiento(fecha_mov):
    return fecha_mov + timedelta(days=random.randint(30, 90))

fecha_inicio = datetime(2020, 1, 1)
fecha_hoy = datetime(2025, 6, 5)

def generar_exec():
    p = {
        "IdProveedor": random.randint(29, 40),
        "CodProdLecheCruda": 94,
        "CodProdEntera": random.choice([35, 36]),
        "CodProdDescremada": random.choice([35, 36]),
        "CodProdCrema": random.choice([35, 36]),
        "CodProdPolvo": random.choice([8, 10, 12, 14, 16]),
        "CodProdPolvoDescremada": random.choice([9, 11, 13, 15]),
        "IdDepositoRecibo": random.randint(1, 4),
        "IdDepositoSecado": random.randint(6, 8),
        "IdLinea1": 1,
        "IdLinea2": 2,
        "IdLinea3": 3,
        "IdFormula1": random.choice([35, 36]),
        "IdFormula2": random.choice([8, 10, 12, 14, 16]),
        "IdFormula3": random.choice([9, 11, 13, 15]),
        "CantidadEntera": round(random.uniform(5000, 10000), 2),
        "CantidadDescremada": round(random.uniform(4000, 9000), 2),
        "CantidadCrema": round(random.uniform(1000, 3000), 2),
        "CantidadPolvo": round(random.uniform(1000, 5000), 2),
        "CantidadPolvoDescremada": round(random.uniform(800, 4000), 2),
        "PrecioUnitario": round(random.uniform(100, 5000), 2),
        "IdEstadoOC": random.randint(1, 2),
        "IdEstadoOF1": random.randint(1, 4),
        "IdEstadoOF2": random.randint(1, 4),
        "IdEstadoOF3": random.randint(1, 4),
    }

    suma_total = sum([
        p["CantidadEntera"],
        p["CantidadDescremada"],
        p["CantidadCrema"],
        p["CantidadPolvo"],
        p["CantidadPolvoDescremada"],
    ])
    p["CantidadCruda"] = round(suma_total + random.uniform(500, 2000), 2)
    p["FechaMovimiento"] = fecha_random(fecha_inicio, fecha_hoy)
    p["FechaVencimiento"] = fecha_vencimiento(p["FechaMovimiento"])

    fmov = p["FechaMovimiento"].strftime("'%Y-%m-%d'")
    fven = p["FechaVencimiento"].strftime("'%Y-%m-%d'")

    return (
        f"exec usp_simular_proceso_leche_completo "
        f"@IdProveedor = {p['IdProveedor']}, "
        f"@CodProdLecheCruda = {p['CodProdLecheCruda']}, "
        f"@CodProdEntera = {p['CodProdEntera']}, "
        f"@CodProdDescremada = {p['CodProdDescremada']}, "
        f"@CodProdCrema = {p['CodProdCrema']}, "
        f"@CodProdPolvo = {p['CodProdPolvo']}, "
        f"@CodProdPolvoDescremada = {p['CodProdPolvoDescremada']}, "
        f"@IdDepositoRecibo = {p['IdDepositoRecibo']}, "
        f"@IdDepositoSecado = {p['IdDepositoSecado']}, "
        f"@IdLinea1 = {p['IdLinea1']}, "
        f"@IdLinea2 = {p['IdLinea2']}, "
        f"@IdLinea3 = {p['IdLinea3']}, "
        f"@IdFormula1 = {p['IdFormula1']}, "
        f"@IdFormula2 = {p['IdFormula2']}, "
        f"@IdFormula3 = {p['IdFormula3']}, "
        f"@CantidadCruda = {p['CantidadCruda']}, "
        f"@CantidadEntera = {p['CantidadEntera']}, "
        f"@CantidadDescremada = {p['CantidadDescremada']}, "
        f"@CantidadCrema = {p['CantidadCrema']}, "
        f"@CantidadPolvo = {p['CantidadPolvo']}, "
        f"@CantidadPolvoDescremada = {p['CantidadPolvoDescremada']}, "
        f"@PrecioUnitario = {p['PrecioUnitario']}, "
        f"@FechaMovimiento = {fmov}, "
        f"@FechaVencimiento = {fven}, "
        f"@IdEstadoOC = {p['IdEstadoOC']}, "
        f"@IdEstadoOF1 = {p['IdEstadoOF1']}, "
        f"@IdEstadoOF2 = {p['IdEstadoOF2']}, "
        f"@IdEstadoOF3 = {p['IdEstadoOF3']};"
    )

# Guardar en archivo .sql
with open("simular_proceso_leche.sql", "w", encoding="utf-8") as f:
    for _ in range(CANTIDAD):
        f.write(generar_exec() + "\n")

print(f"Generado archivo con {CANTIDAD} instrucciones exec.")
