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
CREATE OR REPLACE FUNCTION insert_into_administra
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
REVOKE ALL ON FUNCTION insert_into_administra(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_administra(int,text,date)
	TO dba,admin;
COMMIT;

BEGIN;
/* Cria-se uma ligação entre disciplina e professor. Mostra quais disciplinas
 cada professor dá.*/
CREATE OR REPLACE FUNCTION insert_into_ministra
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
REVOKE ALL ON FUNCTION insert_into_ministra(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_ministra(int,text)
	TO dba,professor;
COMMIT;

BEGIN;
/* Cria um oferecimento de uma disciplina por um professor. Caso uma data não seja
 adicionada, usa-se a data atual como ministra_data. */
CREATE OR REPLACE FUNCTION insert_into_planeja
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
REVOKE ALL ON FUNCTION insert_into_planeja(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_planeja(int,text)
	TO dba,aluno;
COMMIT;
