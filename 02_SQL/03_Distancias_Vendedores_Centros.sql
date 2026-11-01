WITH distancias AS (
    SELECT
        cc.cidade AS centro_candidato,
        v.seller_id,
        6371 * 2 * ASIN(
            SQRT(
                POWER(
                    SIN(RADIANS(cc.latitude - g.latitude) / 2),
                    2
                )
                +
                COS(RADIANS(g.latitude))
                * COS(RADIANS(cc.latitude))
                * POWER(
                    SIN(RADIANS(cc.longitude - g.longitude) / 2),
                    2
                )
            )
        ) AS distancia_km
    FROM raw.vendedores v

    INNER JOIN raw.geo_cep g
        ON v.seller_zip_code_prefix = g.cep

    CROSS JOIN raw.centros_candidatos cc
)

SELECT
    centro_candidato,
    COUNT(*) AS vendedores_localizados,
    ROUND(AVG(distancia_km)::numeric, 2)
        AS distancia_media_km
FROM distancias
GROUP BY centro_candidato
ORDER BY distancia_media_km ASC;