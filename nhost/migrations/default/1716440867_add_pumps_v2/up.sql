CREATE TABLE IF NOT EXISTS public."Pumps_v2" (
    "ID" uuid DEFAULT gen_random_uuid () NOT NULL,
    "PUMP SERIES" text NULL,
    model text NULL,
    "PRESSURE BAR" float8 NULL,
    "FLOW L/H" double precision NULL,
    "CC/  STROKE" double precision NULL,
    "TUBE SIZE         ID X OD" text NULL,
    "STROKE LENGTH ADJ" text NULL,
    "STROKE SPEED ADJ" text NULL,
    "FLOAT SWITCH" text NULL,
    "INPUT" text NULL,
    "INPUT TYPE" text NULL,
    "PUMP HEAD CODE" text NULL,
    "HEAD PVDF SEAL EP" text NULL,
    "HEAD PVDF SEAL FP" text NULL,
    "HEAD PP SEAL EP" text NULL,
    diaphragm text NULL,
    "HEAD O RING EP" text NULL,
    "HEAD O RING FP" text NULL,
    CONSTRAINT "Pumps_v2_pkey" PRIMARY KEY ("ID")
);

