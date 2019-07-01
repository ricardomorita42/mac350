\c inter_mod_pes_cur;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
SET ROLE dba;

-------- fdw config ------------
-- Config para modulo_pessoa
CREATE SERVER pessoa_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_pessoa');

CREATE USER MAPPING FOR dba
	SERVER pessoa_server 
	OPTIONS (user 'dba', password 'dba1234');

CREATE USER MAPPING FOR aluno 
	SERVER pessoa_server 
	OPTIONS (user 'aluno', password 'aluno');

CREATE USER MAPPING FOR professor 
	SERVER pessoa_server 
	OPTIONS (user 'prof', password 'prof');

CREATE USER MAPPING FOR admin
	SERVER pessoa_server 
	OPTIONS (user 'admin', password 'admin');

CREATE FOREIGN TABLE aluno (
	aluno_nusp		INTEGER,
	aluno_curso		TEXT
)
	SERVER pessoa_server
	OPTIONS (schema_name 'public',table_name 'aluno');

CREATE FOREIGN TABLE professor (
	prof_nusp		INTEGER,
	prof_unidade		TEXT
)
	SERVER pessoa_server
	OPTIONS (schema_name 'public',table_name 'professor');

CREATE FOREIGN TABLE administrador (
	admin_nusp		INTEGER,
	admin_unidade		TEXT
)
	SERVER pessoa_server
	OPTIONS (schema_name 'public',table_name 'administrador');

-- Config para modulo_curriculo
CREATE SERVER curriculo_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_curriculo');

CREATE USER MAPPING FOR dba
	SERVER curriculo_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE disciplina(
	disciplina_sigla		TEXT,
	disciplina_unidade		TEXT,
	disciplina_nome			TEXT
)
	SERVER curriculo_server
	OPTIONS (schema_name 'public',table_name 'disciplina');

CREATE FOREIGN TABLE curriculo(
	curriculo_sigla			TEXT,
	curriculo_unidade		TEXT,
	curriculo_nome			TEXT
)
	SERVER curriculo_server
	OPTIONS (schema_name 'public',table_name 'curriculo');

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--Insere elo entre administrador e curriculo
CREATE OR REPLACE FUNCTION insert_administra
(nusp int, cur_sigla text, data_inicio date DEFAULT NULL)
RETURNS INTEGER AS $$
DECLARE
	admin_ok INTEGER := (	SELECT count(*) FROM administrador
				WHERE nusp = admin_nusp);
	cur_ok INTEGER := ( 	SELECT count(*) FROM curriculo
				WHERE cur_sigla = curriculo_sigla);
BEGIN
	IF (admin_ok = 1 AND cur_ok =1) THEN
		IF $3 IS NULL THEN
			INSERT INTO administra VALUES ($1,$2,current_date);
		ELSE
			INSERT INTO administra VALUES ($1,$2,$3);
		END IF;

	ELSE RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_administra(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_administra(int,text,date)
	TO dba,admin;
COMMIT;

BEGIN;
/* Cria-se uma ligação entre disciplina e professor. Mostra quais disciplinas
 cada professor dá.*/
CREATE OR REPLACE FUNCTION insert_ministra
(min_prof_nusp int, min_disc_sigla text)
RETURNS INTEGER AS $$
DECLARE
	prof_ok INTEGER := (	SELECT count(*) FROM professor
				WHERE min_prof_nusp = prof_nusp);
	disc_ok INTEGER := ( 	SELECT count(*) FROM disciplina
				WHERE min_disc_sigla = disciplina_sigla);
BEGIN
	IF (prof_ok = 1 AND disc_ok =1) THEN
		INSERT INTO ministra VALUES ($1,$2);
	ELSE RETURN -1;
	END IF;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_ministra(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_ministra(int,text)
	TO dba,professor;
COMMIT;

BEGIN;
/* Cria um oferecimento de uma disciplina por um professor. Caso uma data não seja
 adicionada, usa-se a data atual como ministra_data. */
CREATE OR REPLACE FUNCTION insert_planeja
(planeja_aluno_nusp int, planeja_disc_sigla text)
RETURNS INTEGER AS $$
DECLARE
	aluno_ok INTEGER := (	SELECT count(*) FROM aluno 
				WHERE planeja_aluno_nusp = aluno_nusp);
	disc_ok INTEGER := ( 	SELECT count(*) FROM disciplina
				WHERE planeja_disc_sigla = disciplina_sigla);
BEGIN
	IF (aluno_ok = 1 AND disc_ok = 1) THEN
		INSERT INTO planeja VALUES ($1,$2);
	ELSE RETURN -1;
	END IF;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_planeja(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_planeja(int,text)
	TO dba,aluno;
COMMIT;

-------- UPDATE TYPE FUNCTIONS ------------
BEGIN;
-- Mudando os dados de um administra
CREATE OR REPLACE FUNCTION update_administra
(old_nusp int, old_curriculo text,
 new_nusp int, new_curriculo text)
RETURNS INTEGER AS $$
DECLARE
	admin_ok INTEGER := (	SELECT count(*) FROM administrador
				WHERE new_nusp = admin_nusp);
	cur_ok INTEGER := (	SELECT count(*) FROM curriculo
				WHERE new_curriculo = curriculo_sigla);
BEGIN
	IF (admin_ok = 1 AND cur_ok = 1) THEN
		UPDATE  administra
		SET 	administra_nusp= new_nusp,
			administra_curriculo_sigla = new_curriculo
		WHERE	administra_nusp = old_nusp AND
			administra_curriculo_sigla = old_curriculo;
	ELSE RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_administra(int,text,int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_administra(int,text,int,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda a data de inicio de uma relacao administra
CREATE OR REPLACE FUNCTION update_administra_data_inicio
(INOUT nusp int, INOUT curriculo_sigla text, INOUT new_data date)
AS $$
	UPDATE administra
	SET administra_inicio = new_data
	WHERE	administra_nusp = nusp AND
		administra_curriculo_sigla = curriculo_sigla 
	RETURNING administra_nusp, administra_curriculo_sigla, administra_inicio
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_administra_data_inicio(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_administra_data_inicio(int,text,date)
	TO dba,admin;
COMMIT;

BEGIN;
-- Mudando um ministra
CREATE OR REPLACE FUNCTION update_ministra
(old_nusp int, old_disciplina text,
 new_nusp int, new_disciplina text)
RETURNS INTEGER AS $$
DECLARE
	prof_ok INTEGER := (	SELECT count(*) FROM professor
				WHERE new_nusp = prof_nusp);
	disc_ok INTEGER := (	SELECT count(*) FROM disciplina
				WHERE new_disciplina = disciplina_sigla);
BEGIN
	IF (prof_ok = 1 AND disc_ok = 1) THEN
		UPDATE  ministra
		SET 	ministra_prof_nusp = new_nusp,
			ministra_disciplina_sigla = new_disciplina
		WHERE	ministra_prof_nusp = old_nusp AND
			ministra_disciplina_sigla = old_disciplina;
	ELSE RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_ministra(int,text,int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_ministra(int,text,int,text)
	TO dba,professor;
COMMIT;

BEGIN;
-- Mudando um planeja 
CREATE OR REPLACE FUNCTION update_planeja
(old_nusp int, old_disciplina text,
 new_nusp int, new_disciplina text)
RETURNS INTEGER AS $$
DECLARE
	aluno_ok INTEGER := (	SELECT count(*) FROM aluno
				WHERE new_nusp = aluno_nusp);
	disc_ok INTEGER := (	SELECT count(*) FROM disciplina
				WHERE new_disciplina = disciplina_sigla);
BEGIN
	IF (aluno_ok = 1 AND disc_ok = 1) THEN
		UPDATE  planeja 
		SET 	planeja_aluno_nusp = new_nusp,
			planeja_disciplina_sigla = new_disciplina
		WHERE	planeja_aluno_nusp = old_nusp AND
			planeja_disciplina_sigla = old_disciplina;
	ELSE RETURN -1;
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_planeja(int,text,int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_planeja(int,text,int,text)
	TO dba,aluno;
COMMIT;

-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
-- apagando um administra
CREATE OR REPLACE FUNCTION delete_administra
(nusp int, curriculo text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM administra
	WHERE	administra_nusp = nusp AND
		administra_curriculo_sigla = curriculo;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_administra(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_administra(int,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- apagando um ministra
CREATE OR REPLACE FUNCTION delete_ministra
(nusp int, disciplina text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM  ministra
	WHERE	ministra_prof_nusp = nusp AND
		ministra_disciplina_sigla = disciplina;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_ministra(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_ministra(int,text)
	TO dba,professor;
COMMIT;

BEGIN;
-- Apagando um planeja 
CREATE OR REPLACE FUNCTION delete_planeja
(nusp int, disciplina text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM  planeja 
	WHERE	planeja_aluno_nusp = nusp AND
		planeja_disciplina_sigla = disciplina;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_planeja(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_planeja(int,text)
	TO dba,aluno;
COMMIT;

-------- RETRIEVAL TYPE FUNCTIONS ------------
BEGIN;
-- retorna todas os administra
CREATE OR REPLACE FUNCTION return_all_administra()
RETURNS TABLE(	
	admin_nusp		INTEGER,
	curriculo_sigla		TEXT,
	inicio			date
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	administra_nusp,administra_curriculo_sigla,
       		administra_inicio
		FROM administra;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_administra()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_administra()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas os planeja
CREATE OR REPLACE FUNCTION return_all_planeja()
RETURNS TABLE(	
	aluno_nusp		INTEGER,
	disciplina_sigla	TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	planeja_aluno_nusp, planeja_disciplina_sigla
		FROM planeja;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_planeja()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_planeja()
	TO dba;
COMMIT;

BEGIN;
-- retorna todas os planeja
CREATE OR REPLACE FUNCTION return_all_ministra()
RETURNS TABLE(	
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	ministra_prof_nusp, ministra_disciplina_sigla
		FROM ministra;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_ministra()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_ministra()
	TO dba, professor;
COMMIT;

BEGIN;
-- retorna todos os administra de um admin
CREATE OR REPLACE FUNCTION return_administra_of_admin(nusp int)
RETURNS TABLE(	
	curriculo_sigla		TEXT,
	inicio			date
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	administra_curriculo_sigla,
       		administra_inicio
	FROM 	administra
	WHERE	administra_nusp = nusp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_administra_of_admin(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_administra_of_admin(int)
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas os planeja
CREATE OR REPLACE FUNCTION return_planeja_of_aluno(nusp int)
RETURNS TABLE(	
	disciplina_sigla	TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	planeja_disciplina_sigla
	FROM	planeja
	WHERE	planeja_aluno_nusp = nusp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_planeja_of_aluno(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_planeja_of_aluno(int)
	TO dba,aluno;
COMMIT;

BEGIN;
-- retorna todas os planeja
CREATE OR REPLACE FUNCTION return_ministra_of_prof(nusp int)
RETURNS TABLE(	
	disciplina_sigla	TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	ministra_disciplina_sigla
		FROM ministra
		WHERE ministra_prof_nusp = nusp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_ministra_of_prof(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_ministra_of_prof(int)
	TO dba, professor;
COMMIT;
