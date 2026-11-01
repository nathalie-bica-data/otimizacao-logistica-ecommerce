-- Table: raw.geo_cep

-- DROP TABLE IF EXISTS "raw".geo_cep;

CREATE TABLE IF NOT EXISTS "raw".geo_cep
(
    cep character varying(10) COLLATE pg_catalog."default",
    latitude double precision,
    longitude double precision
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS "raw".geo_cep
    OWNER to postgres;