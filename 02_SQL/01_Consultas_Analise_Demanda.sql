CREATE TABLE IF NOT EXISTS raw.demanda_treino_teste (
    estado VARCHAR(2),
    mes DATE,
    total_pedidos INTEGER,
    periodo VARCHAR(10),
    indice_mes INTEGER,
    PRIMARY KEY (estado, mes)
);

INSERT INTO raw.demanda_treino_teste (
    estado,
    mes,
    total_pedidos,
    periodo,
    indice_mes
)
SELECT
    estado,
    mes,
    total_pedidos,

    CASE
        WHEN mes < DATE '2018-05-01'
            THEN 'treino'
        ELSE 'teste'
    END AS periodo,

    (
        (EXTRACT(YEAR FROM mes)::integer - 2017) * 12
        + EXTRACT(MONTH FROM mes)::integer
    ) AS indice_mes

FROM raw.demanda_mensal_estados

WHERE mes BETWEEN
    DATE '2017-01-01'
    AND DATE '2018-08-01'

ON CONFLICT (estado, mes)
DO UPDATE SET
    total_pedidos = EXCLUDED.total_pedidos,
    periodo = EXCLUDED.periodo,
    indice_mes = EXCLUDED.indice_mes;

SELECT
    estado,
    periodo,
    COUNT(*) AS quantidade_meses,
    MIN(mes) AS primeiro_mes,
    MAX(mes) AS ultimo_mes
FROM raw.demanda_treino_teste
GROUP BY estado, periodo
ORDER BY estado, periodo;