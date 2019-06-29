\c inter_mod_ace_pes
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
CREATE EXTENSION IF NOT EXISTS citext;
SET ROLE dba;

DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

-------- fdw config ------------
-- Config para modulo_acesso
CREATE SERVER acesso_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_acesso');

CREATE USER MAPPING FOR dba
	SERVER acesso_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE usuario (
	user_login	TEXT,
	user_email	email,
	user_password	TEXT
)
	SERVER acesso_server
	OPTIONS (schema_name 'public',table_name 'usuario');

-- Config para modulo_pessoa
CREATE SERVER pessoa_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_pessoa');

CREATE USER MAPPING FOR dba
	SERVER pessoa_server 
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE pessoa (
	nusp				SERIAL,
	cpf				VARCHAR(14),
	pnome				TEXT,
	snome				TEXT,
	datanasc			date,
	sexo				VARCHAR(1)
)
	SERVER pessoa_server
	OPTIONS (schema_name 'public',table_name 'pessoa');

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--Cria um pe_us. Checa se existem entradas em pessoa.pessoa e acesso.usuario antes de criar.
CREATE OR REPLACE FUNCTION insert_pe_us
(num_usp INTEGER, login text)
RETURNS INTEGER AS $$
DECLARE
	usuario_ok INTEGER := (	SELECT count(*) FROM usuario 
				WHERE login = user_login);
	pessoa_ok INTEGER := (	SELECT count(*) FROM pessoa
				WHERE num_usp = nusp);
BEGIN
	IF (usuario_ok =1 AND pessoa_ok = 1) THEN
		INSERT INTO pe_us
		VALUES ($1,$2);
	ELSE RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
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
(old_nusp int, old_login text,
 new_nusp int, new_login text)
RETURNS INTEGER AS $$
DECLARE
	-- Checa se os novos dados estao certos
	-- antigos dados ja foram checados quando colocados na tabela 
	usuario_ok INTEGER := (	SELECT count(*) FROM usuario 
				WHERE new_login = user_login);
	pessoa_ok INTEGER := (	SELECT count(*) FROM pessoa
				WHERE new_nusp = nusp);
BEGIN
	IF (usuario_ok =1 AND pessoa_ok = 1) THEN
		UPDATE  pe_us 
		SET	pe_us_nusp = new_nusp,
			pe_us_user_login = new_login
		WHERE	pe_us_nusp = old_nusp OR
			pe_us_user_login = old_login;
	ELSE
		RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
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
