\c inter_ace_pes
CREATE EXTENSION IF NOT EXISTS dblink;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
SET ROLE dba;

-- DDL
CREATE TABLE pe_us (
	pe_us_nusp		SERIAL NOT NULL,
	pe_us_user_login 	TEXT NOT NULL,

	CONSTRAINT pk_pe_us PRIMARY KEY (pe_us_nusp,pe_us_user_login)
);

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--Cria um pe_us
CREATE OR REPLACE FUNCTION insert_pe_us
(INOUT nusp INTEGER, INOUT user_login text)
AS
$$
	INSERT INTO pe_us
	VALUES ($1,$2)
	RETURNING pe_us_nusp, pe_us_user_login 
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_pe_us(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_pe_us(int,text)
	TO dba;
COMMIT;

-------- UPDATE TYPE FUNCTIONS ------------
BEGIN;
--Atualiza uma determinada relação pe_us.
--Esta funcao me parece bem perigosa.
CREATE OR REPLACE FUNCTION update_pe_us
(IN old_nusp int, IN old_login text,
 INOUT new_nusp int, INOUT new_login text)
AS $$
	UPDATE pe_us 
	SET	pe_us_nusp = new_nusp,
		pe_us_user_login = new_login
	WHERE	pe_us_nusp = old_nusp AND
		pe_us_user_login = old_login
	RETURNING pe_us_nusp,pe_us_user_login 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_pe_us(int,text,int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pe_us(int,text,int,text)
	TO dba;
COMMIT;

-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
-- apaga pe_us, isto nao tem efeitos colaterais
CREATE OR REPLACE FUNCTION delete_pe_us_with_nusp
(nusp int)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM pe_us
	WHERE pe_us_nusp = nusp;	

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_pe_us_with_nusp(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_pe_us_with_nusp(int)
	TO dba;
COMMIT;

BEGIN;
-- apaga pe_us, isto nao tem efeitos colaterais
CREATE OR REPLACE FUNCTION delete_pe_us_with_login
(login text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM pe_us
	WHERE pe_us_user_login = login;	

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_pe_us_with_login(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_pe_us_with_login(text)
	TO dba;
COMMIT;

-------- RETRIEVAL TYPE FUNCTIONS ------------
BEGIN;
-- retorna todos os servicos do db 
CREATE OR REPLACE FUNCTION return_all_pe_us()
RETURNS TABLE(NUSPs int, user_logins text) AS $$
BEGIN
	RETURN QUERY
	SELECT pe_us_nusp, pe_us_user_login FROM pe_us;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_pe_us()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_pe_us()
	TO dba;
COMMIT;

-- DML
SELECT * FROM insert_pe_us(227705861,'tonya'	);
SELECT * FROM insert_pe_us(386930905,'felipe'	);
SELECT * FROM insert_pe_us(859852130,'danny'	);
SELECT * FROM insert_pe_us(310554114,'lauryn'	);
SELECT * FROM insert_pe_us(613923368,'lillian'	);
SELECT * FROM insert_pe_us(311285463,'jessica'	);
SELECT * FROM insert_pe_us(991002548,'joann'	);
SELECT * FROM insert_pe_us(158298846,'robert'	);
SELECT * FROM insert_pe_us(761213416,'rodney'	);
SELECT * FROM insert_pe_us(702391605,'james'	);
SELECT * FROM insert_pe_us(559853740,'jeana'	);
SELECT * FROM insert_pe_us(994567006,'heather'	);
SELECT * FROM insert_pe_us(230057892,'otis'	);
SELECT * FROM insert_pe_us(961065297,'gregory'	);
SELECT * FROM insert_pe_us(162109146,'kelly'	);
SELECT * FROM insert_pe_us(939847659,'marie'	);
SELECT * FROM insert_pe_us(489997003,'elliott'	);
SELECT * FROM insert_pe_us(365513041,'david'	);
SELECT * FROM insert_pe_us(300606205,'chester'	);
SELECT * FROM insert_pe_us(815705605,'dave'	);
