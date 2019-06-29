\c inter_mod_ace_pes
SET ROLE dba;

CREATE EXTENSION IF NOT EXISTS citext;

-------- DDL  ------------
CREATE TABLE pe_us (
	pe_us_nusp		SERIAL UNIQUE NOT NULL,
	pe_us_user_login 	TEXT UNIQUE NOT NULL,

	CONSTRAINT pk_pe_us PRIMARY KEY (pe_us_nusp,pe_us_user_login)
);

