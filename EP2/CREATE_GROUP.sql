--b01_pessoa = t(NUSP,CPF,PNome,SNome,DataNasc,Sexo)
CREATE OR REPLACE FUNCTION insert_guest
(INOUT NUSP int, INOUT CPF text, INOUT PNome text,
 INOUT SNome text, INOUT DataNasc date, INOUT Sexo VARCHAR(1))
AS
BEGIN
	INSERT INTO b01_pessoa
	VALUES ($1,$2,$3,$4,$5,$6)
	RETURNING NUSP, CPF, PNome, SNome, DataNasc, Sexo
END;
LANGUAGE sql;

select * from insert_guest(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
