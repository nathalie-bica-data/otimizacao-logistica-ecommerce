-- PROJETO: Expansão Logística do E-commerce
-- ETAPA: Preparação dos dados geográficos
--
-- Objetivo:
-- Consolidar as coordenadas geográficas por prefixo de CEP.
--
-- Método reconstruído:
-- Mediana da latitude e da longitude.
--
-- Validação:
-- 18.998 de 19.011 registros correspondem à tabela
-- raw.geo_cep, com tolerância de 0.000001.
--
-- Observação:
-- A transformação original não foi recuperada.
-- Este script reproduz aproximadamente 99,93% dos resultados.
--
-- IMPORTANTE:
-- Consulta somente de leitura.
-- Não modifica a tabela existente.

SELECT
    geolocation_zip_code_prefix AS cep,

    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY geolocation_lat)
        AS latitude,

    PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY geolocation_lng)
        AS longitude

FROM raw.geolocalizacao

WHERE geolocation_zip_code_prefix IS NOT NULL
  AND geolocation_lat IS NOT NULL
  AND geolocation_lng IS NOT NULL

GROUP BY geolocation_zip_code_prefix

ORDER BY cep;