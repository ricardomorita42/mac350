\c pessoa
CREATE EXTENSION IF NOT EXISTS dblink;
SET ROLE dba;

-------- VIEWS  ------------
CREATE VIEW remote_ace_pes AS
 	SELECT * FROM dblink
		('dbname = inter_ace_pes options =-csearch_path=',
		'select pe_us_nusp, pe_us_user_login from public.pe_us')
       	as t1(nusp int, login text);

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--adicionado por um superadmin ou alguém da graduacao
--pessoa = t(NUSP,CPF,PNome,SNome,DataNasc,Sexo)
CREATE OR REPLACE FUNCTION insert_person 
(INOUT nusp int, INOUT cpf text, INOUT pnome text,
 INOUT snome text, INOUT datanasc date, INOUT sexo VARCHAR(1))
AS
$$
	INSERT INTO pessoa
	VALUES ($1,$2,$3,$4,$5,$6)
	RETURNING nusp, cpf, pnome, snome, datanasc, sexo
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_person(int,text,text,text,date,varchar(1))
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_person(int,text,text,text,date,varchar(1))
	TO dba;
COMMIT;

BEGIN;
/*Insere uma pessoa na entidade aluno. Para que isto ocorra, ela deve
ter uma conta de usuário já criada. Ou seja, deve haver um elo entre
usuário e pessoa em pe_us. Depois add o usuario desta pessoa na tabela
perfil como estudante. */
CREATE OR REPLACE FUNCTION insert_into_role_student
(nusp int, curso text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO aluno
	VALUES (nusp,curso);
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_into_role_student(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_role_student(int,text)
	TO dba,aluno;
COMMIT;

BEGIN;
/*Insere uma pessoa na entidade professor. Para que isto ocorra, ela deve
ter uma conta de usuário já criada. Ou seja, deve haver um elo entre
usuário e pessoa em pe_us. Depois add o usuario desta pessoa na tabela
perfil como professor. */
CREATE OR REPLACE FUNCTION insert_into_role_teacher
(nusp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO professor
	VALUES (nusp,unidade);
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_into_role_teacher(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_role_teacher(int,text)
	TO dba,professor;
COMMIT;

BEGIN;
/*Insere uma pessoa na entidade admin. Para que isto ocorra, ela deve
ter uma conta de usuário já criada. Ou seja, deve haver um elo entre
usuário e pessoa em pe_us. Depois add o usuario desta pessoa na tabela
perfil como admin. */
CREATE OR REPLACE FUNCTION insert_into_role_admin
(nusp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO admnistrador
	VALUES (nusp,unidade);
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_into_role_admin(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_role_admin(int,text)
	TO dba,admin;
COMMIT;

BEGIN;
/* Cria um oferecimento de uma disciplina por um professor. Caso uma data não seja
 adicionada, usa-se a data atual como ministra_data. */
CREATE OR REPLACE FUNCTION insert_oferecimento
(ofer_prof_nusp int, ofer_disciplina_sigla text, ofer_ministra_data date default NULL)
RETURNS INTEGER AS $$
BEGIN
	IF $3 IS NULL THEN
		INSERT INTO oferecimento VALUES ($1,$2,current_date);
	ELSE
		INSERT INTO oferecimento VALUES ($1,$2,$3);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_oferecimento(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_oferecimento(int,text,date)
	TO dba,professor;
COMMIT;

BEGIN;
/* Cria um oferecimento de uma disciplina por um professor. Caso uma data não seja
 adicionada, usa-se a data atual como ministra_data. */
CREATE OR REPLACE FUNCTION insert_planeja
(planeja_aluno_nusp int, planeja_disciplina_sigla text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO planeja VALUES ($1,$2);
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_planeja(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_planeja(int,text)
	TO dba;
COMMIT;

BEGIN;
/* Insere uma entrada para um aluno que vai cursar uma disciplina oferecida.
Primeiro verifica-se se o aluno tem esta matéria no planejamento. Depois
é necessária uma checagem para ver se a disciplina está sendo oferecida 
(i.e. o curso está em oferecimento). */
CREATE OR REPLACE FUNCTION insert_cursa
(cursa_aluno_nusp int, cursa_prof_nusp int, cursa_disciplina_sigla text,
cursa_nota numeric, cursa_presenca numeric)
RETURNS INTEGER AS $$
BEGIN
	IF (SELECT count(*) from oferecimento WHERE
		ofer_prof_nusp = cursa_prof_nusp AND
		ofer_disciplina_sigla = cursa_disciplina_sigla) = 1
	THEN
		IF (SELECT count(*) from planeja WHERE
			planeja_aluno_nusp = cursa_aluno_nusp AND
			planeja_disciplina_sigla = cursa_disciplina_sigla) = 1
		THEN
			INSERT INTO cursa VALUES ($1,$2,$3,$4,$5);
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
	ELSE
		RETURN 0;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_cursa(int,int,text,numeric,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_cursa(int,int,text,numeric,numeric)
	TO dba;
COMMIT;
