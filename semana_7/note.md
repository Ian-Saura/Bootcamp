cd week7_data_quality/duckdb
chmod +x show_kpi.sh duck_test_runner.sh run_with_tests.sh

# 1) Ver KPI roto por datos sucios
./show_kpi.sh

# 2) Correr tests (deberían fallar)
./duck_test_runner.sh || echo "FALLÓ (como esperábamos)"

# 3) Pipeline que corta si hay errores
./run_with_tests.sh || echo "Cortó en tests (ok)"

# 4) Arreglá seed_week7.sql (quitá negativos/fecha futura/duplicados)
#    y volvé a correr para ver que pasa TODO OK
