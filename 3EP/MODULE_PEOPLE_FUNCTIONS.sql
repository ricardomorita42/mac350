\c modulo_pessoa
CREATE EXTENSION IF NOT EXISTS dblink;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
SET ROLE dba;
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
	user_email	email
)
	SERVER acesso_server
	OPTIONS (schema_name 'public',table_name 'usuario');

-- Config para intermod_ace_pes
CREATE SERVER ace_pes_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'inter_mod_ace_pes');

CREATE USER MAPPING FOR dba
	SERVER ace_pes_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE pe_us (
	pe_us_nusp		SERIAL,
	pe_us_user_login 	TEXT
)
	SERVER ace_pes_server
	OPTIONS (schema_name 'public',table_name 'pe_us');

-------- VIEWS  ------------
/* Teoricamente estou dando um select em fez de envelopar numa 
funcao quando uso esta view. Entretanto, não tenho a intenção
de permitir que o usuário use esta view livremente portanto
esta não estaria exposta para todos. */
CREATE OR REPLACE VIEW remote_ace_pes AS
 	SELECT * FROM dblink
		('dbname = inter_mod_ace_pes options =-csearch_path=',
		'select pe_us_nusp, pe_us_user_login from public.pe_us')
       	as t1(ace_pes_nusp int, ace_pes_login text);

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
perfil como estudante.
 O único requisito para esta função é que haja uma conta de usuário, 
portanto. Tendo uma conta de usuário, esta ganha perfil de estudante.*/
CREATE OR REPLACE FUNCTION insert_into_role_student
(nusp int, curso text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM remote_ace_pes
				WHERE nusp = ace_pes_nusp);
	var_login text;
	request text;
	result INTEGER;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN
		--insere em aluno 
		INSERT INTO aluno
		VALUES (nusp,curso);

		--descobre o login deste usuário
		SELECT  ace_pes_login 
			FROM remote_ace_pes
			WHERE ace_pes_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil student para o usuário deste nusp
		SELECT FORMAT(E'SELECT * from insert_user_into_role(%L,''student'')',var_login) INTO request;

		--raise notice 'var_login: %',var_login;
		--raise notice 'request: %', request;

		--guardando em result caso seja necessário debugar
		SELECT * from dblink('dbname=modulo_acesso',request) AS t(x int) into result;

	ELSE RETURN -1;
	END IF;
	RETURN 1;
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
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM remote_ace_pes
				WHERE nusp = ace_pes_nusp);
	var_login text;
	request text;
	result INTEGER;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN
		--insere em professor
		INSERT INTO professor 
		VALUES (nusp, unidade);

		--descobre o login deste usuário
		SELECT  ace_pes_login 
			FROM remote_ace_pes
			WHERE ace_pes_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil teacher para o usuário deste nusp
		select FORMAT(E'SELECT * from insert_user_into_role(%L,''teacher'')',var_login) INTO request;

		--raise notice 'var_login: %',var_login;
		--raise notice 'request: %', request;

		--guardando em result caso seja necessário debugar
		SELECT * from dblink('dbname=modulo_acesso',request) AS t(x int) into result;

	ELSE RETURN -1;
	END IF;
	RETURN 1;
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
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM remote_ace_pes
				WHERE nusp = ace_pes_nusp);
	var_login text;
	request text;
	result INTEGER;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN
		--insere em administrador
		INSERT INTO administrador
		VALUES (nusp, unidade);

		--descobre o login deste usuário
		SELECT  ace_pes_login 
			FROM remote_ace_pes
			WHERE ace_pes_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil admin para o usuário deste nusp
		select FORMAT(E'SELECT * from insert_user_into_role(%L,''admin'')',var_login) INTO request;

		--raise notice 'var_login: %',var_login;
		--raise notice 'request: %', request;

		--guardando em result caso seja necessário debugar
		SELECT * from dblink('dbname=modulo_acesso',request) AS t(x int) into result;

	ELSE RETURN -1;
	END IF;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_into_role_teacher(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_role_teacher(int,text)
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
		INSERT INTO cursa VALUES ($1,$2,$3,$4,$5);
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_cursa(int,int,text,numeric,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_cursa(int,int,text,numeric,numeric)
	TO dba;
COMMIT;

-------- UPDATE TYPE FUNCTIONS ------------
BEGIN;
--Dado um numero usp, atualiza pnome e snome.
CREATE OR REPLACE FUNCTION update_pessoa_nome
(IN num_usp int, INOUT new_pnome text, INOUT new_snome text)
AS 
$$
	UPDATE pessoa 
	SET pnome = new_pnome, snome = new_snome
	WHERE nusp = num_usp
	RETURNING pnome,snome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_pessoa_nome(int,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pessoa_nome(int,text,text)
	TO dba,guest;
COMMIT;

BEGIN;
--Dado um numero usp, atualiza a data de nascimento.
CREATE OR REPLACE FUNCTION update_pessoa_datanasc
(IN num_usp int, INOUT new_datanasc date)
AS 
$$
	UPDATE pessoa 
	SET datanasc = new_datanasc
	WHERE nusp = num_usp
	RETURNING new_datanasc
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_pessoa_datanasc(int,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pessoa_datanasc(int,date)
	TO dba,guest;
COMMIT;

BEGIN;
--Dado um numero usp, atualiza o sexo de uma pessoa.
CREATE OR REPLACE FUNCTION update_pessoa_sexo
(IN num_usp int, INOUT new_sexo varchar(1))
AS $$
	UPDATE pessoa 
	SET sexo = new_sexo
	WHERE nusp = num_usp
	RETURNING new_sexo
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_pessoa_sexo(int,varchar(1))
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pessoa_sexo(int,varchar(1))
	TO dba,guest;
COMMIT;

BEGIN;
--Atualiza o curso ligado a um aluno
CREATE OR REPLACE FUNCTION update_aluno_curso
(INOUT nusp int, INOUT new_curso text)
AS $$
	UPDATE aluno
	SET aluno_curso= new_curso
	WHERE aluno_nusp = nusp
	RETURNING aluno_nusp, aluno_curso
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_aluno_curso(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_aluno_curso(int,text)
	TO dba,aluno;
COMMIT;

BEGIN;
--Atualiza a unidade ligada à um professor
CREATE OR REPLACE FUNCTION update_prof_unidade
(INOUT nusp int, INOUT new_unidade text)
AS $$
	UPDATE professor
	SET prof_unidade = new_unidade
	WHERE prof_nusp = nusp
	RETURNING prof_nusp, prof_unidade 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_prof_unidade(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_prof_unidade(int,text)
	TO dba,professor;
COMMIT;

BEGIN;
--Atualiza a unidade ligada à um admin 
CREATE OR REPLACE FUNCTION update_admin_unidade
(INOUT nusp int, INOUT new_unidade text)
AS $$
	UPDATE administrador
	SET admin_unidade = new_unidade
	WHERE admin_nusp = nusp
	RETURNING admin_nusp, admin_unidade 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_admin_unidade(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_admin_unidade(int,text)
	TO dba,admin;
COMMIT;

BEGIN;
/* Atualiza data do oferecimento de uma disciplina.
Caso se deseje atualizar nusp do professor ou codigo da
disciplina, deve-se inserir uma nova disciplina. */
CREATE OR REPLACE FUNCTION update_ofer_data
(INOUT nusp int, INOUT disc_sigla text, INOUT new_data date)
AS $$
	UPDATE oferecimento
	SET ofer_ministra_data = new_data
	WHERE 	ofer_prof_nusp = nusp AND
		ofer_disciplina_sigla = disc_sigla
	RETURNING ofer_prof_nusp,ofer_disciplina_sigla,new_data
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_ofer_data(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_ofer_data(int,text,date)
	TO dba,professor;
COMMIT;

BEGIN;
-- Atualiza uma nota em cursa. 
CREATE OR REPLACE FUNCTION update_cursa_nota
(INOUT al_nusp int, INOUT prof_nusp int, INOUT disc_sigla text,
INOUT new_nota NUMERIC)
AS $$
	UPDATE cursa 
	SET cursa_nota = new_nota
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_prof_nusp = prof_nusp AND
	       	cursa_disciplina_sigla = disc_sigla	
	RETURNING cursa_aluno_nusp,cursa_prof_nusp,
		cursa_disciplina_sigla, new_nota
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_cursa_nota(int,int,text,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_cursa_nota(int,int,text,numeric)
	TO dba,professor;
COMMIT;

BEGIN;
-- Atualiza uma presença em cursa. 
CREATE OR REPLACE FUNCTION update_cursa_presenca
(INOUT al_nusp int, INOUT prof_nusp int, INOUT disc_sigla text,
INOUT new_presenca NUMERIC)
AS $$
	UPDATE cursa 
	SET cursa_presenca = new_presenca
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_prof_nusp = prof_nusp AND
	       	cursa_disciplina_sigla = disc_sigla	
	RETURNING cursa_aluno_nusp,cursa_prof_nusp,
		cursa_disciplina_sigla, new_presenca
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_cursa_presenca(int,int,text,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_cursa_presenca(int,int,text,numeric)
	TO dba,professor;
COMMIT;

-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
/*Apaga uma pessoa. A ligação entre pessoa e usuário 
também vai para o vazio, além de reverter o usuário
para que ela tenha só o perfil de guest.*/
CREATE OR REPLACE FUNCTION delete_from_pessoa
(num_usp int)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM remote_ace_pes
				WHERE num_usp = ace_pes_nusp);
	var_login text;
	request text;
	result INTEGER;
BEGIN
	--Checa se pessoa tem conta de usuario
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  ace_pes_login 
			FROM remote_ace_pes
			WHERE ace_pes_nusp = num_usp
			INTO var_login;

		-- apaga na tabela pe_us a entrada com o login do usuário deste nusp
		--SELECT FORMAT(E'SELECT * from delete_pe_us_with_login(%L)',var_login) INTO request;
		--SELECT * from dblink('dbname=acesso',request) AS t(x int) into result;

		-- apaga na tabela us_pf todas as entradas deste usuario que pertencam a (aluno,prof,admin) 
		SELECT FORMAT(E'SELECT * from delete_rel_pe_us(%L,''student'')',var_login) INTO request;
		SELECT * from dblink(   'dbname=modulo_acesso',
					FORMAT(E'SELECT * from delete_rel_pe_us_with_login(%L,''student'')',var_login))
			       		AS t(x int) into result;

		SELECT FORMAT(E'SELECT * from delete_rel_pe_us(%L,''teacher'')',var_login) INTO request;
		SELECT * from dblink(   'dbname=modulo_acesso',
					FORMAT(E'SELECT * from delete_rel_pe_us_with_login(%L,''teacher'')',var_login))
			       		AS t(x int) into result;

		SELECT FORMAT(E'SELECT * from delete_rel_pe_us(%L,''admin'')',var_login) INTO request;
		SELECT * from dblink(   'dbname=modulo_acesso',
					FORMAT(E'SELECT * from delete_rel_pe_us_with_login(%L,''admin'')',var_login))
			       		AS t(x int) into result;
	END IF;
	-- cascade nas outras tabelas de pessoa
	DELETE FROM pessoa WHERE nusp = num_usp;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_from_pessoa(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_from_pessoa(int)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em aluno ligado à uma pessoa. As relações em
cursa e planeja também se vão.*/
CREATE OR REPLACE FUNCTION delete_from_aluno
(num_usp int, curso text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM aluno
		WHERE 	aluno_nusp = num_usp AND
			aluno_curso = curso;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_from_aluno(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_from_aluno(int,text)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em professor ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_from_professor
(num_usp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM professor
		WHERE 	prof_nusp = num_usp AND
			prof_unidade = unidade;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_from_professor(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_from_professor(int,text)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em adminstrador ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_from_administrador
(num_usp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM administrador
		WHERE 	admin_nusp = num_usp AND
			admin_unidade = unidade;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_from_administrador(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_from_administrador(int,text)
	TO dba;
COMMIT;
