SET check_function_bodies = false;
CREATE TABLE public."Pumps" (
    "ID" uuid DEFAULT gen_random_uuid() NOT NULL,
    "ProductName" text NOT NULL,
    "Power" double precision NOT NULL,
    "FlowRate" double precision NOT NULL,
    "Weight" double precision NOT NULL
);
ALTER TABLE ONLY public."Pumps"
    ADD CONSTRAINT "Pumps_pkey" PRIMARY KEY ("ID");
