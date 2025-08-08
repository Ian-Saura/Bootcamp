import pandas as pd

# Cargar datos originales y finales
df_original = pd.read_csv("ventas_raw.csv")
df_final = pd.read_csv("ventas_limpias.csv")

# Validación 1: cantidad de filas
print("Filas originales:", len(df_original))
print("Filas finales:", len(df_final))

# Validación 2: valores nulos
nulos = df_final.isnull().sum()
print("\nValores nulos por columna:")
print(nulos)

# Validación 3: tipos de datos
print("\nTipos de datos:")
print(df_final.dtypes)

# Validación 4: total de ventas
total_original = df_original["monto"].sum()
total_final = df_final["monto"].sum()
print(f"\nTotal original: {total_original}")
print(f"Total final: {total_final}")

# Guardar log
with open("validacion_log.txt", "w") as f:
    f.write(f"Filas originales: {len(df_original)}\n")
    f.write(f"Filas finales: {len(df_final)}\n")
    f.write(f"Total original: {total_original}\n")
    f.write(f"Total final: {total_final}\n")
