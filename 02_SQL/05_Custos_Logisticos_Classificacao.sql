	WITH custos_transporte AS (
    SELECT *
    FROM (
        VALUES
            ('guarulhos', 2181235.93, 6785418.69),
            ('sao paulo', 2165584.69, 6811758.26),
            ('santo andre', 2219789.50, 6860972.13),
            ('campinas', 2227810.75, 6885329.15)
    ) AS t(
        cidade,
        custo_entrada,
        custo_saida
    )
),

custos_fixos AS (
    SELECT *
    FROM (
        VALUES
            ('sao paulo', 350000.00),
            ('guarulhos', 300000.00),
            ('campinas', 250000.00),
            ('santo andre', 280000.00)
    ) AS t(cidade, custo_fixo)
),

custos_totais AS (
    SELECT
        t.cidade,
        t.custo_entrada,
        t.custo_saida,
        f.custo_fixo,

        (
            t.custo_entrada
            + t.custo_saida
            + f.custo_fixo
        ) AS custo_total

    FROM custos_transporte t

    INNER JOIN custos_fixos f
        ON t.cidade = f.cidade
)

SELECT
    cidade AS centro_candidato,

    ROUND(
        (custo_entrada + custo_saida)::numeric, 2
    ) AS custo_transporte_rs,

    ROUND(
        custo_fixo::numeric, 2
    ) AS custo_fixo_rs,

    ROUND(
        custo_total::numeric, 2
    ) AS custo_total_rs,

    RANK() OVER (
        ORDER BY custo_total ASC
    ) AS classificacao

FROM custos_totais

ORDER BY classificacao;