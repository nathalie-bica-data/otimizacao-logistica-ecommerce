WITH custos_base AS (
    SELECT *
    FROM (
        VALUES
            ('guarulhos', 2181235.93, 6785418.69),
            ('sao paulo', 2165584.69, 6811758.26),
            ('santo andre', 2219789.50, 6860972.13),
            ('campinas', 2227810.75, 6885329.15)
    ) AS t(cidade, custo_entrada, custo_saida)
),

cenarios AS (
    SELECT *
    FROM (
        VALUES
            ('Atual', 0.08, 0.12),
            ('Entrada mais cara', 0.12, 0.08),
            ('Saida mais cara', 0.06, 0.14)
    ) AS t(cenario, tarifa_entrada, tarifa_saida)
),

simulacao AS (
    SELECT
        c.cenario,
        b.cidade,

        b.custo_entrada
            * (c.tarifa_entrada / 0.08)
            AS novo_custo_entrada,

        b.custo_saida
            * (c.tarifa_saida / 0.12)
            AS novo_custo_saida

    FROM custos_base b
    CROSS JOIN cenarios c
)

SELECT
    cenario,
    cidade AS centro_candidato,

    ROUND(
        novo_custo_entrada, 2
    ) AS custo_entrada_rs,

    ROUND(
        novo_custo_saida, 2
    ) AS custo_saida_rs,

    ROUND(
        novo_custo_entrada
        + novo_custo_saida, 2
    ) AS custo_total_rs,

    RANK() OVER (
        PARTITION BY cenario
        ORDER BY
            novo_custo_entrada
            + novo_custo_saida
    ) AS classificacao

FROM simulacao

ORDER BY
    cenario,
    classificacao;