\c inter_ace_pes
CREATE EXTENSION IF NOT EXISTS dblink;
SET ROLE dba;

-------- VIEWS  ------------
CREATE OR REPLACE VIEW remote_acesso AS
 	SELECT * FROM dblink
		('dbname = acesso options =-csearch_path=',
		'select user_login, user_email from public.usuario')
       	as t1(user_login text, user_email text);

CREATE OR REPLACE VIEW remote_pessoa AS
 	SELECT * FROM dblink
		('dbname = pessoa options =-csearch_path=',
		'select nusp, cpf, pnome from public.pessoa')
       	as t1(pes_nusp int, pes_cpf text, pes_pnome text);

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--Cria um pe_us. Checa se existem entradas em pessoa.pessoa e acesso.usuario antes de criar.
CREATE OR REPLACE FUNCTION insert_pe_us
(nusp INTEGER, login text)
RETURNS INTEGER AS $$
DECLARE
	acesso_ok INTEGER := (	SELECT count(*) FROM remote_acesso
				WHERE login = user_login);
	pessoa_ok INTEGER := (	SELECT count(*) FROM remote_pessoa
				WHERE nusp = pes_nusp);
BEGIN
	IF (acesso_ok =1 AND pessoa_ok = 1) THEN
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
	acesso_ok INTEGER := (	SELECT count(*) FROM remote_acesso
				WHERE new_login = user_login);
	pessoa_ok INTEGER := (	SELECT count(*) FROM remote_pessoa
				WHERE new_nusp = pes_nusp);
BEGIN
	IF (acesso_ok =1 AND pessoa_ok = 1) THEN
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
