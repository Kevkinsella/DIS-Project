-- Slet og genopret brugeren 'testuser'
DO $$
BEGIN
    IF EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'testuser') THEN
        REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM testuser;
        REVOKE ALL PRIVILEGES ON SCHEMA public FROM testuser;
        REVOKE ALL PRIVILEGES ON DATABASE "TINProject" FROM testuser;
        DROP ROLE testuser;
    END IF;
END $$;

-- Opret brugeren
CREATE ROLE testuser WITH LOGIN PASSWORD '123';

-- Giv adgang til databasen
GRANT ALL PRIVILEGES ON DATABASE "TINProject" TO testuser;

-- Skift til databasen (hvis du kører dette manuelt)
\c "TINProject"

-- Opret tabeller
DROP TABLE IF EXISTS public."People";
DROP TABLE IF EXISTS public."Employers";
DROP TABLE IF EXISTS public."Countries";

CREATE TABLE public."Countries" (
    code VARCHAR PRIMARY KEY,
    name VARCHAR,
    example VARCHAR
);

CREATE TABLE public."Employers" (
    "EmployerID" INTEGER PRIMARY KEY,
    "Name" VARCHAR,
    "Country_ID" VARCHAR REFERENCES public."Countries"(code)
);

CREATE TABLE public."People" (
    "CPR_nr" VARCHAR PRIMARY KEY,
    "F_name" VARCHAR,
    "Surname" VARCHAR,
    "EmployerID" INTEGER REFERENCES public."Employers"("EmployerID"),
    "Country_ID" VARCHAR REFERENCES public."Countries"(code),
    "TIN_value" VARCHAR,
    "TIN_type" VARCHAR,
    "Start_Date" DATE,
    "End_Date" DATE,
    "TIN_status" VARCHAR
);

-- Giv privilegier
GRANT SELECT, INSERT, UPDATE, DELETE ON public."People" TO testuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON public."Employers" TO testuser;
GRANT SELECT, INSERT, UPDATE, DELETE ON public."Countries" TO testuser;

-- Indlæs data fra CSV
COPY public."Countries" FROM '/Users/kevinkinsella/Desktop/DIS/Project /Data/Countries.csv' DELIMITER ',' CSV HEADER;
COPY public."Employers" FROM '/Users/kevinkinsella/Desktop/DIS/Project/Data/Employers.csv' DELIMITER ',' CSV HEADER;
COPY public."People" FROM '/Users/kevinkinsella/Desktop/DIS/Project/Data/People.csv' DELIMITER ',' CSV HEADER;
