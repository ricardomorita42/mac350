------------- From SUPPORT.sql --------------------
/*
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
-- For security create admin schema as well
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234'
	VALID UNTIL '2019-07-01';
CREATE SCHEMA IF NOT EXISTS admins;
GRANT admins TO dba;

DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );
*/

---------------------------------------------------

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

CREATE OR REPLACE FUNCTION insert_role 
(INOUT perfil_nome text, INOUT perfil_descricao text DEFAULT NULL)
AS
$$
	INSERT INTO perfil
	VALUES ($1,$2)
	RETURNING perfil_nome, perfil_descricao
$$
LANGUAGE sql;

/* Insere um estudante como usuário que tenha um nusp válido (i.e. está em pessoa).
também liga este usuário a pessoa e perfil, criando entradas em
pe_us e us_pf.
  Importante que haja um perfil com nome 'student' em perfil ou esta função falhará.
(i.e. executar insert_role('student') primeiro  */
CREATE OR REPLACE FUNCTION insert_student
(nusp int, curso text, nickname text, email text, password text)
RETURNS INTEGER AS $$
DECLARE
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
	--gerando com numeros aleatorios para auxiliar ao testar, evitando colisao de logins
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	INSERT INTO us_pf
	VALUES(nickname, 'student', date_atm);

	INSERT INTO aluno
	VALUES(nusp, curso);

	--raise notice 'Value %', idperf;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Insere um professor como usuário que tenha um nusp válido (i.e. está em pessoa).
também liga este usuário a pessoa e perfil, criando entradas em
pe_us e us_pf.
  Importante que haja um perfil com nome 'teacher' em perfil ou esta função falhará.
(i.e. executar insert_role('teacher') primeiro */
CREATE OR REPLACE FUNCTION insert_teacher
(nusp int, unidade text, nickname text, email text, password text)
RETURNS INTEGER AS $$
DECLARE
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
	--gerando com numeros aleatorios para auxiliar ao testar, evitando colisao de logins
	--login_nick text := TRIM(BOTH FROM nickname) || TRIM(BOTH FROM to_char(floor(random() * 100 + 1),'99'));
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	INSERT INTO us_pf(us_pf_user_login,us_pf_perfil_nome,us_pf_perfil_inicio)
	VALUES(nickname, 'teacher', date_atm);

	INSERT INTO professor (prof_nusp,prof_unidade)
	VALUES(nusp, unidade);

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Insere um professor como usuário que tenha um nusp válido (i.e. está em pessoa).
também liga este usuário a pessoa e perfil, criando entradas em
pe_us e us_pf.
  Importante que haja um perfil com nome 'admin' em perfil ou esta função falhará.
(i.e. executar insert_role('admin') primeiro */
CREATE OR REPLACE FUNCTION insert_admin
(nusp int, unidade text, nickname text, email text, password text)
RETURNS INTEGER AS $$
DECLARE
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
	--gerando com numeros aleatorios para auxiliar ao testar, evitando colisao de logins
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	INSERT INTO us_pf
	VALUES(nickname, 'admin', date_atm);

	INSERT INTO admnistrador 
	VALUES(nusp, unidade);

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Caso se queira ligar um servico existente a outro perfil pode-se usar
esta funcao tambem pois basta add outra entrada em pf_se.
Caso $1 seja nulo, um serviço será criado sem ser relacionado a um perfil.  */
CREATE OR REPLACE FUNCTION insert_service
(perfil_nome text, service_nome text, service_descricao text)
RETURNS INTEGER AS $$
BEGIN
	IF $1 IS NULL THEN
		INSERT into service VALUES ($2,$3);
	ELSE
		INSERT into service VALUES ($2,$3) ON CONFLICT DO NOTHING;
		INSERT into pf_se VALUES ($1,$2);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* É adicinado por um admin então deve estar ligada com um admnistrador pelo menos.
(i.e., não se deve criar um currículo sem admin). Também pode adicionar 
mais um admin para um currículo.  */
CREATE OR REPLACE FUNCTION insert_curriculum
(curriculo_sigla text, curriculo_unidade text, curriculo_nome text, curriculo_cred_obrig int,
 curriculo_cred_opt_elet int, curriculo_opt_liv int, admnin_nusp int)
RETURNS INTEGER AS $$
DECLARE
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
BEGIN
	INSERT into curriculo VALUES ($1,$2,$3,$4,$5,$6) ON CONFLICT DO NOTHING;
	INSERT into admnistra VALUES ($7,$1,date_atm);

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Pode ser usado para adicionar uma ligação entre uma trilha e um
curriculo ja existente também. Caso curriculo_sigla seja NULL,
então a trilha não será atrelada a ninguém. */
CREATE OR REPLACE FUNCTION insert_trilha
(trilha_nome text, trilha_descricao text, curriculo_sigla text )
RETURNS INTEGER AS $$
BEGIN
	IF $3 IS NULL THEN
		INSERT INTO trilha VALUES ($1,$2);
	ELSE
		INSERT INTO trilha VALUES ($1,$2) ON CONFLICT DO NOTHING;
		INSERT INTO cur_tril VALUES ($3,$1);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Pode ser usado para adicionar uma ligação entre uma trilha e um
curriculo ja existente também. Caso curriculo_sigla seja NULL,
então a trilha não será atrelada a ninguém. */
CREATE OR REPLACE FUNCTION insert_modulo
(modulo_nome text, modulo_descricao text, trilha_nome text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO modulo VALUES ($1,$2,$3) ON CONFLICT DO NOTHING;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------
\i EP2_DDL_CLEAN.sql
\i EP2_DDL.sql
\i DML.sql
