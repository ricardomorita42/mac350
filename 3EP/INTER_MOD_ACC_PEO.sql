\c inter_ace_pes
SET ROLE dba;

CREATE TABLE pe_us (
	id		SERIAL NOT NULL,
	nusp		SERIAL NOT NULL,
	user_login 	TEXT NOT NULL,

	CONSTRAINT pk_pe_us PRIMARY KEY (id)
);
