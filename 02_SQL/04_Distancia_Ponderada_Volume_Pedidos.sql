WITH volume_pedidos AS (
    SELECT
        i.order_id,
        COUNT(*) AS total_itens
    FROM raw.itens_pedidos i
    INNER JOIN raw.pedidos p
        ON i.order_id = p.order_id
    WHERE p.order_status = 'delivered'
    GROUP BY i.order_id
),
distancias AS (
    SELECT
        cc.cidade AS centro_candidato,
        p.order_id,
        vp.total_itens,

        6371 * 2 * ASIN(
            LEAST(1.0, SQRT(
                POWER(
                    SIN(RADIANS(
                        cc.latitude - g.latitude
                    ) / 2),
                    2
                )
                +
                COS(RADIANS(g.latitude))
                * COS(RADIANS(cc.latitude))
                * POWER(
                    SIN(RADIANS(
                        cc.longitude - g.longitude
                    ) / 2),
                    2
                )
            ))
        ) AS distancia_km

    FROM raw.pedidos p

    INNER JOIN raw.clientes c
        ON p.customer_id = c.customer_id

    INNER JOIN volume_pedidos vp
        ON p.order_id = vp.order_id

    INNER JOIN raw.geo_cep g
        ON c.customer_zip_code_prefix = g.cep

    CROSS JOIN raw.centros_candidatos cc

    WHERE p.order_status = 'delivered'
)

SELECT
    centro_candidato,

    COUNT(*) AS pedidos_analisados,

    SUM(total_itens) AS itens_analisados,

    ROUND(
        (
            SUM(distancia_km * total_itens)
            / NULLIF(SUM(total_itens), 0)
        )::numeric,
        2
    ) AS distancia_ponderada_km

FROM distancias

GROUP BY centro_candidato

ORDER BY distancia_ponderada_km ASC;