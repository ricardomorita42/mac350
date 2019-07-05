\c modulo_pessoa
SET ROLE dba;
CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP DOMAIN IF EXISTS email;
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
	user_email	email
)
	SERVER acesso_server
	OPTIONS (schema_name 'public',table_name 'usuario');

CREATE FOREIGN TABLE us_pf (
	us_pf_user_login	TEXT,
	us_pf_perfil_nome	TEXT,
	us_pf_perfil_inicio	date
)
	SERVER acesso_server
	OPTIONS (schema_name 'public',table_name 'us_pf');

-- Config para intermod_ace_pes
CREATE SERVER ace_pes_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'inter_mod_ace_pes');

CREATE USER MAPPING FOR dba
	SERVER ace_pes_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE pe_us (
	pe_us_nusp		INTEGER,
	pe_us_user_login 	TEXT
)
	SERVER ace_pes_server
	OPTIONS (schema_name 'public',table_name 'pe_us');

-- Config para modulo_curriculo
CREATE SERVER curriculo_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_curriculo');

CREATE USER MAPPING FOR dba
	SERVER curriculo_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE USER MAPPING FOR admin
	SERVER curriculo_server
	OPTIONS (user 'admin', password 'admin');

CREATE USER MAPPING FOR professor
	SERVER curriculo_server
	OPTIONS (user 'prof', password 'prof');

CREATE USER MAPPING FOR aluno
	SERVER curriculo_server
	OPTIONS (user 'aluno', password 'aluno');

CREATE FOREIGN TABLE disciplina(
	disciplina_sigla		TEXT,
	disciplina_unidade		TEXT,
	disciplina_nome			TEXT
)
	SERVER curriculo_server
	OPTIONS (schema_name 'public',table_name 'disciplina');

-- Config para inter_mod_pes_cur
CREATE SERVER pes_cur_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'inter_mod_pes_cur');

CREATE USER MAPPING FOR dba
	SERVER pes_cur_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE planeja (
	planeja_aluno_nusp		INTEGER,
	planeja_disciplina_sigla	TEXT
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'planeja');

CREATE FOREIGN TABLE ministra (
	ministra_prof_nusp		INTEGER,
	ministra_disciplina_sigla	TEXT
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'ministra');

CREATE FOREIGN TABLE administra (
	administra_nusp			INTEGER,
	administra_curriculo_sigla	TEXT
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'administra');

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
perfil como 'student'.
 O único requisito para esta função é que haja uma conta de usuário, 
portanto. Tendo uma conta de usuário, esta ganha perfil de estudante.*/
CREATE OR REPLACE FUNCTION insert_into_role_student
(nusp int, curso text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us 
				WHERE nusp = pe_us_nusp);
	var_login text;
	result INTEGER;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil student para o usuário deste nusp
		-- caso este nao seja um.
		INSERT INTO us_pf 
			VALUES (var_login,'student',current_date)
			ON CONFLICT DO NOTHING;

		--insere em aluno 
		INSERT INTO aluno
		VALUES (nusp,curso);
	END IF;


	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
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
perfil como 'teacher'.
 O único requisito para esta função é que haja uma conta de usuário, 
portanto. Tendo uma conta de usuário, esta ganha perfil de professor também.*/
CREATE OR REPLACE FUNCTION insert_into_role_teacher
(nusp int, unidade text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us 
				WHERE nusp = pe_us_nusp);
	var_login text;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil teacher para o usuário deste nusp
		-- caso este nao seja um. 

		INSERT INTO us_pf 
			VALUES (var_login,'teacher',current_date)
			ON CONFLICT DO NOTHING;

		--insere em professor
		INSERT INTO professor 
		VALUES (nusp,unidade);
	END IF;


	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
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
perfil como 'admin'.
 O único requisito para esta função é que haja uma conta de usuário, 
portanto. Tendo uma conta de usuário, esta ganha perfil de admin também.*/
CREATE OR REPLACE FUNCTION insert_into_role_admin
(nusp int, unidade text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us 
				WHERE nusp = pe_us_nusp);
	var_login text;
BEGIN
	--Existe um pe_us deste nusp?
	IF (pe_us_ok = 1) THEN

		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = nusp
			INTO var_login;

		-- insere na tabela us_pf o perfil admin para o usuário deste nusp
		-- caso este nao seja um. 

		INSERT INTO us_pf 
			VALUES (var_login,'admin',current_date)
			ON CONFLICT DO NOTHING;

		--insere em administrador
		INSERT INTO administrador
		VALUES (nusp,unidade);
	END IF;


	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_into_role_admin(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_into_role_admin(int,text)
	TO dba,admin;
COMMIT;

BEGIN;
/* Cria um oferecimento de uma disciplina por um professor.
Checamos se a este oferecimento está na tabela ministra. Também se verifica
se a disciplina existe.*/
CREATE OR REPLACE FUNCTION insert_oferecimento
(ofer_prof_nusp int, ofer_disciplina_sigla text, ofer_ministra_data date default NULL)
RETURNS INTEGER AS $$
DECLARE
	ministra_ok INTEGER := (
		SELECT count(*)
	       		FROM 	ministra
			WHERE 	ministra_prof_nusp  = ofer_prof_nusp AND
				ministra_disciplina_sigla = ofer_disciplina_sigla);
	disciplina_ok INTEGER := (
		SELECT count(*)
	       		FROM 	disciplina	
			WHERE 	disciplina_sigla = ofer_disciplina_sigla);
BEGIN
	IF (ministra_ok = 1 AND disciplina_ok = 1) THEN
		IF $3 IS NULL THEN
			INSERT INTO oferecimento VALUES ($1,$2,current_date);
		ELSE
			INSERT INTO oferecimento VALUES ($1,$2,$3);
		END IF;
	END IF;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_oferecimento(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_oferecimento(int,text,date)
	TO dba,professor;
COMMIT;

BEGIN;
/* Insere uma entrada para um aluno que vai cursar uma disciplina oferecida.
Primeiro verifica-se se a disciplina existe. Depois, se o aluno tem esta materia
no planejamento. Depois é necessária uma checagem em oferecimento se 
o professor e a disciplina estao sendo oferecidos. */
CREATE OR REPLACE FUNCTION insert_cursa
(cursa_aluno_nusp int, cursa_aluno_curso text, cursa_prof_nusp int, cursa_disciplina_sigla text,
cursa_data date, cursa_nota numeric, cursa_presenca numeric)
RETURNS INTEGER AS $$
DECLARE
	disciplina_ok INTEGER := (
		SELECT count(*) FROM disciplina 
		WHERE cursa_disciplina_sigla = disciplina_sigla);

	planeja_ok INTEGER := (
		SELECT count(*) FROM planeja 
		WHERE cursa_disciplina_sigla = planeja_disciplina_sigla);

	oferecimento_ok INTEGER := (
		SELECT count(*) FROM oferecimento
		WHERE 	cursa_disciplina_sigla = ofer_disciplina_sigla
			AND cursa_prof_nusp = ofer_prof_nusp);
BEGIN
	IF (disciplina_ok = 1 AND planeja_ok = 1 AND oferecimento_ok = 1) THEN
		INSERT INTO cursa VALUES ($1,$2,$3,$4,$5,$6,$7);
	END IF;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_cursa(int,text,int,text,date,numeric,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_cursa(int,text,int,text,date,numeric,numeric)
	TO dba;
COMMIT;

-------- UPDATE TYPE FUNCTIONS ------------
BEGIN;
-- Atualiza um numero usp
CREATE OR REPLACE FUNCTION update_pessoa_nusp
(old_nusp int, new_nusp int)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us 
				WHERE pe_us_nusp = old_nusp);
	aluno_ok INTEGER := (	SELECT count(*) FROM aluno
				WHERE aluno_nusp = old_nusp);
	prof_ok INTEGER := (	SELECT count(*) FROM professor
				WHERE prof_nusp = old_nusp);
	admin_ok INTEGER := (	SELECT count(*) FROM administrador
				WHERE admin_nusp = old_nusp);
BEGIN
	--atualiza pe_us se o nusp antigo tinha uma conta
	if (pe_us_ok = 1) THEN
		UPDATE  pe_us
		SET	pe_us_nusp = new_nusp
		WHERE 	pe_us_nusp = old_nusp;
	END IF;

	--se a pessoa é aluna, atualiza nusp em planeja
	if (aluno_ok = 1) THEN
		UPDATE  planeja
		SET 	planeja_aluno_nusp = new_nusp
		WHERE 	planeja_aluno_nusp = old_nusp;
	END IF;

	--se pessoa é professora, atualiza nusp em ministra
	if (prof_ok = 1) THEN
		UPDATE  ministra
		SET 	ministra_prof_nusp = new_nusp
		WHERE 	ministra_prof_nusp = old_nusp;
	END IF;

	--se pessoa é admin, atualiza nusp em administra
	if (admin_ok = 1) THEN
		UPDATE  administra
		SET 	administra_nusp	= new_nusp
		WHERE 	administra_nusp = old_nusp;
	END IF;

	--atualiza o nusp da pessoa
	UPDATE  pessoa 
	SET 	nusp = new_nusp
	WHERE 	nusp = old_nusp;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_pessoa_nusp(int,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pessoa_nusp(int,int)
	TO dba;
COMMIT;

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
-- Atualiza uma nota em cursa. 
CREATE OR REPLACE FUNCTION update_cursa_nota
(INOUT al_nusp int, INOUT al_curso text, INOUT prof_nusp int,
INOUT disc_sigla text,INOUT data date, INOUT new_nota NUMERIC)
AS $$
	UPDATE cursa 
	SET cursa_nota = new_nota
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_aluno_curso = al_curso AND
		cursa_prof_nusp = prof_nusp AND
		cursa_data = data AND
	       	cursa_disciplina_sigla = disc_sigla	
	RETURNING cursa_aluno_nusp,cursa_aluno_curso,cursa_prof_nusp,
		cursa_disciplina_sigla, cursa_data, cursa_nota
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_cursa_nota(int,text,int,text,date,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_cursa_nota(int,text,int,text,date,numeric)
	TO dba,professor;
COMMIT;

BEGIN;
-- Atualiza uma presença em cursa. 
CREATE OR REPLACE FUNCTION update_cursa_presenca
(INOUT al_nusp int, INOUT al_curso text, INOUT prof_nusp int,
INOUT disc_sigla text,INOUT data date, INOUT new_presenca NUMERIC)
AS $$
	UPDATE cursa 
	SET cursa_presenca = new_presenca
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_aluno_curso = al_curso AND
		cursa_prof_nusp = prof_nusp AND
		cursa_data = data AND
	       	cursa_disciplina_sigla = disc_sigla	
	RETURNING cursa_aluno_nusp,cursa_aluno_curso,cursa_prof_nusp,
		cursa_disciplina_sigla, cursa_data, cursa_presenca
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_cursa_presenca(int,text,int,text,date,numeric)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_cursa_presenca(int,text,int,text,date,numeric)
	TO dba,professor;
COMMIT;

BEGIN;
-- Atualiza um oferecimento
CREATE OR REPLACE FUNCTION update_oferecimento
(old_nusp int, old_disciplina text,
 new_nusp int, new_disciplina text)
RETURNS INTEGER AS $$
DECLARE
	/*Checando se novo nusp e disciplina esta em ministra e 
	se a disciplina é valida */
	ministra_ok INTEGER := (SELECT count(*) FROM ministra
				WHERE 	ministra_prof_nusp = new_nusp AND
					ministra_disciplina_sigla = new_disciplina);

	/* Teoricamente se existe entrada em ministra entao new_usp e new_disciplina
	 sao validos. Mas por hábito vou checar se existem pois lidando com foreign
	 tables o SGDB não consegue garantir integridade.*/
	disciplina_ok INTEGER := (
		SELECT count(*) FROM disciplina 
		WHERE disciplina_sigla = new_disciplina);

	professor_ok INTEGER := (
		SELECT count(*) FROM professor
		WHERE prof_nusp = new_nusp);
BEGIN
	IF (ministra_ok = 1 AND disciplina_ok = 1) THEN 
		UPDATE oferecimento
		SET 	ofer_prof_nusp = new_nusp,
			ofer_disciplina_sigla = new_disciplina
		WHERE 	ofer_prof_nusp = old_nusp AND
			ofer_disciplina_sigla = old_disciplina;
	END IF;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_oferecimento(int,text,int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_oferecimento(int,text,int,text)
	TO dba,professor;
COMMIT;

BEGIN;
-- Atualiza a data de um oferecimento
CREATE OR REPLACE FUNCTION update_oferecimento_data
(nusp int, disciplina text, new_data date)
RETURNS INTEGER AS $$
BEGIN
	UPDATE oferecimento
	SET 	ofer_ministra_data = new_data
	WHERE 	ofer_prof_nusp = nusp AND
		ofer_disciplina_sigla = disciplina;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION update_oferecimento_data(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_oferecimento_data(int,text,date)
	TO dba,professor;
COMMIT;

-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
/*Apaga uma pessoa. A ligação entre pessoa e usuário 
também vai para o vazio, além de reverter o usuário
para que ela tenha só o perfil de guest.*/
CREATE OR REPLACE FUNCTION delete_pessoa
(num_usp int)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us
				WHERE pe_us_nusp = num_usp);
	aluno_ok INTEGER := (	SELECT count(*) FROM aluno
				WHERE aluno_nusp = num_usp);
	prof_ok INTEGER := (	SELECT count(*) FROM professor
				WHERE prof_nusp = num_usp);
	admin_ok INTEGER := (	SELECT count(*) FROM administrador
				WHERE admin_nusp = num_usp);
	var_login text;
	request text;
BEGIN
	--Checa se pessoa tem conta de usuario
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = num_usp
			INTO var_login;
		--apagar perfis de aluno, admin ou professor do usuario
		DELETE	FROM us_pf
			WHERE us_pf_user_login = var_login AND (
			us_pf_perfil_nome = 'student' OR
			us_pf_perfil_nome = 'teacher' OR
			us_pf_perfil_nome = 'admin');
	END IF;
	--se a pessoa é aluna, deleta nusp em planeja
	if (aluno_ok = 1) THEN
		DELETE FROM  planeja
		WHERE 	planeja_aluno_nusp = num_usp;
	END IF;

	--se pessoa é professora, deleta nusp em ministra
	if (prof_ok = 1) THEN
		DELETE FROM ministra
		WHERE 	ministra_prof_nusp = num_usp;
	END IF;

	--se pessoa é admin, deleta nusp em administra
	if (admin_ok = 1) THEN
		DELETE FROM administra
		WHERE 	administra_nusp = num_usp;
	END IF;
	-- cascade nas outras tabelas de pessoa
	DELETE FROM pessoa WHERE nusp = num_usp;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_pessoa(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_pessoa(int)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em aluno ligado à uma pessoa. As relações em
cursa e planeja também se vão, além do perfil student do usuario.*/
CREATE OR REPLACE FUNCTION delete_aluno
(num_usp int, curso text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us
				WHERE pe_us_nusp = num_usp);
	var_login text;
BEGIN
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = num_usp
			INTO var_login;
		--apagar perfil de aluno do usuario
		DELETE	FROM us_pf
			WHERE us_pf_user_login = var_login AND
			us_pf_perfil_nome = 'student';
	END IF;

	--Apaga os planeja deste aluno
	DELETE FROM planeja
	WHERE 	planeja_aluno_nusp = num_usp;

	DELETE 	FROM aluno
		WHERE 	aluno_nusp = num_usp AND
			aluno_curso = curso;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_aluno(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_aluno(int,text)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em professor ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_professor
(num_usp int, unidade text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us
				WHERE pe_us_nusp = num_usp);
	var_login text;
BEGIN
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = num_usp
			INTO var_login;
		--apagar perfil de professor do usuario
		DELETE	FROM us_pf
			WHERE us_pf_user_login = var_login AND
			us_pf_perfil_nome = 'teacher';
	END IF;

	--Apaga os ministra deste professor
	DELETE FROM ministra 
	WHERE 	ministra_prof_nusp = num_usp;

	--Apaga o professor
	DELETE 	FROM professor
		WHERE 	prof_nusp = num_usp AND
			prof_unidade = unidade;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_professor(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_professor(int,text)
	TO dba;
COMMIT;

BEGIN;
/* Apaga a entrada em adminstrador ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_administrador
(num_usp int, unidade text)
RETURNS INTEGER AS $$
DECLARE
	pe_us_ok INTEGER := (	SELECT count(*) FROM pe_us
				WHERE pe_us_nusp = num_usp);
	var_login text;
BEGIN
	IF (pe_us_ok = 1) THEN
		--descobre o login deste usuário
		SELECT  pe_us_user_login 
			FROM pe_us
			WHERE pe_us_nusp = num_usp
			INTO var_login;
		--apagar perfil de professor do usuario
		DELETE	FROM us_pf
			WHERE us_pf_user_login = var_login AND
			us_pf_perfil_nome = 'admin';
	END IF;

	--Apaga os administra deste admin
	DELETE FROM administra 
	WHERE 	administra_nusp = num_usp;

	--Apaga o admin
	DELETE 	FROM admin
		WHERE 	admin_nusp = num_usp AND
			admin_unidade = unidade;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_administrador(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_administrador(int,text)
	TO dba;
COMMIT;

BEGIN;
-- Apaga um oferecimento de uma disciplina por um professor numa certa data
-- Nao mexe em cursa porque senao o aluno fica perdendo disciplinas
CREATE OR REPLACE FUNCTION delete_oferecimento
(num_usp int, sigla text, data date) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM oferecimento
		WHERE 	ofer_disciplina_sigla = sigla AND
			ofer_prof_nusp = num_usp AND
			ofer_ministra_data = data;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_oferecimento(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_oferecimento(int,text,date)
	TO dba;
COMMIT;

BEGIN;
-- Apaga um cursa
CREATE OR REPLACE FUNCTION delete_cursa
(al_nusp int, al_curso text, prof_nusp int, disc_sigla text,
 data date)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM cursa
		WHERE 	cursa_aluno_nusp = al_nusp AND
			cursa_aluno_curso = al_curso AND
			cursa_prof_nusp  = prof_nusp AND
			cursa_disciplina_sigla= disc_sigla AND
			cursa_data = data;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_cursa(int,text,int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_cursa(int,text,int,text,date)
	TO dba;
COMMIT;

-------- RETRIEVAL TYPE FUNCTIONS ------------
BEGIN;
-- retorna todos as pessoas
CREATE OR REPLACE FUNCTION return_all_pessoas()
RETURNS TABLE(	
	nusp			INTEGER,
	cpf			VARCHAR(14),
	pnome			TEXT,
	snome			TEXT,
	datanasc		date,
	sexo			VARCHAR(1)
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM pessoa ;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_pessoas()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_pessoas()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna uma pessoa com o nusp dado
CREATE OR REPLACE FUNCTION return_pessoa_with_nusp(num_usp int)
RETURNS TABLE(	
	numero_usp		INTEGER,
	cpf			VARCHAR(14),
	pnome			TEXT,
	snome			TEXT,
	datanasc		date,
	sexo			VARCHAR(1)
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM pessoa
	WHERE nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_pessoa_with_nusp(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_pessoa_with_nusp(int)
	TO dba,guest;
COMMIT;

BEGIN;
-- retorna todos os alunos
CREATE OR REPLACE FUNCTION return_all_alunos()
RETURNS TABLE(	
	nusp		INTEGER,
	curso		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM aluno;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_alunos()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_alunos()
	TO dba,admin,professor;
COMMIT;

BEGIN;
-- retorna alunos com o mesmo nusp (podem ter cursos diferentes)
CREATE OR REPLACE FUNCTION return_aluno(num_usp int)
RETURNS TABLE(	
	nusp		INTEGER,
	curso		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM aluno
	WHERE aluno_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_aluno(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_aluno(int)
	TO dba,admin,professor,aluno;
COMMIT;

BEGIN;
-- retorna todos os professores
CREATE OR REPLACE FUNCTION return_all_professores()
RETURNS TABLE(	
	nusp		INTEGER,
	unidade		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM professor;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_professores()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_professores()
	TO dba,admin,professor;
COMMIT;

BEGIN;
-- retorna todos um professor com o nusp dado
CREATE OR REPLACE FUNCTION return_prof(num_usp int)
RETURNS TABLE(	
	nusp		INTEGER,
	unidade		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM professor
	WHERE prof_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_prof(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_prof(int)
	TO dba,admin,professor;
COMMIT;

BEGIN;
-- retorna todos os administradores
CREATE OR REPLACE FUNCTION return_all_administradores()
RETURNS TABLE(	
	nusp		INTEGER,
	unidade		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM administrador;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_administradores()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_administradores()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna o administrador com o nusp dado
CREATE OR REPLACE FUNCTION return_admin(num_usp int)
RETURNS TABLE(	
	nusp		INTEGER,
	unidade		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM administrador
	WHERE admin_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_admin(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_admin(int)
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todos os cursas 
CREATE OR REPLACE FUNCTION return_all_cursas()
RETURNS TABLE(	
	aluno_nusp		INTEGER,
	aluno_curso		TEXT,
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	data			date,
	nota			NUMERIC,
	presenca		NUMERIC
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM cursa;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_cursas()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_cursas()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todos os cursas de um aluno
CREATE OR REPLACE FUNCTION return_all_cursas_of_aluno(num_usp int)
RETURNS TABLE(	
	aluno_nusp		INTEGER,
	aluno_curso		TEXT,
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	data			date,
	nota			NUMERIC,
	presenca		NUMERIC
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM cursa
	WHERE cursa_aluno_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_cursas_of_aluno(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_cursas_of_aluno(int)
	TO dba,admin,professor,aluno;
COMMIT;

BEGIN;
-- retorna todos os cursas de um professor
CREATE OR REPLACE FUNCTION return_all_cursas_of_prof(num_usp int)
RETURNS TABLE(	
	aluno_nusp		INTEGER,
	aluno_curso		TEXT,
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	data			date,
	nota			NUMERIC,
	presenca		NUMERIC
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM cursa
	WHERE cursa_prof_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_cursas_of_prof(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_cursas_of_prof(int)
	TO dba,admin,professor;
COMMIT;

BEGIN;
-- retorna todos os cursas de um professor
CREATE OR REPLACE FUNCTION return_all_cursas_of_disciplina(disciplina text)
RETURNS TABLE(	
	aluno_nusp		INTEGER,
	aluno_curso		TEXT,
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	data			date,
	nota			NUMERIC,
	presenca		NUMERIC
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM cursa
	WHERE cursa_disciplina_sigla = disciplina;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_cursas_of_disciplina(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_cursas_of_disciplina(text)
	TO dba,admin,professor,aluno;
COMMIT;

BEGIN;
-- retorna todos os oferecimentos
CREATE OR REPLACE FUNCTION return_all_oferecimentos()
RETURNS TABLE(	
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	ministra_data		date
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM oferecimento;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_oferecimentos()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_oferecimentos()
	TO dba,professor,admin,aluno;
COMMIT;

BEGIN;
-- retorna todos os oferecimentos de um professor
CREATE OR REPLACE FUNCTION return_all_oferecimentos_of_prof(num_usp int)
RETURNS TABLE(	
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	ministra_data		date
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM oferecimento
	WHERE ofer_prof_nusp = num_usp;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_oferecimentos_of_prof(int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_oferecimentos_of_prof(int)
	TO dba,professor,admin,aluno;
COMMIT;

BEGIN;
-- retorna todos os oferecimentos de uma disciplina
CREATE OR REPLACE FUNCTION return_all_oferecimentos_of_disciplina(disciplina text)
RETURNS TABLE(	
	prof_nusp		INTEGER,
	disciplina_sigla	TEXT,
	ministra_data		date
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM oferecimento
	WHERE ofer_disciplina_sigla = disciplina;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_oferecimentos_of_disciplina(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_oferecimentos_of_disciplina(text)
	TO dba,professor,admin,aluno;
COMMIT;
