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

--Cria um perfil
CREATE OR REPLACE FUNCTION insert_role 
(INOUT perfil_nome text, INOUT perfil_descricao text DEFAULT NULL)
AS
$$
	INSERT INTO perfil
	VALUES ($1,$2)
	RETURNING perfil_nome, perfil_descricao
$$
LANGUAGE sql;

--Insere um usuario existente em um perfil existente
CREATE OR REPLACE FUNCTION insert_user_into_role 
(INOUT user_login text, INOUT perfil_nome text)
AS
$$
	INSERT INTO us_pf
	VALUES ($1,$2,current_date)
	RETURNING $1,$2 
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
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	INSERT INTO aluno VALUES(nusp, curso);

	PERFORM insert_user_into_role(nickname,'student');

	--Adicionando perfil guest ao usuario
	PERFORM insert_user_into_role(nickname,'guest');

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
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	INSERT INTO professor (prof_nusp,prof_unidade)
	VALUES(nusp, unidade);

	PERFORM insert_user_into_role(nickname,'teacher');

	--Adicionando perfil guest ao usuario
	PERFORM insert_user_into_role(nickname,'guest');

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Insere um admin como usuário que tenha um nusp válido (i.e. está em pessoa).
também liga este usuário a pessoa e perfil, criando entradas em
pe_us e us_pf.
  Importante que haja um perfil com nome 'admin' em perfil ou esta função falhará.
(i.e. executar insert_role('admin') primeiro */
CREATE OR REPLACE FUNCTION insert_admin
(nusp int, unidade text, nickname text, email text, password text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	PERFORM insert_user_into_role(nickname,'admin');

	INSERT INTO admnistrador 
	VALUES(nusp, unidade);

	--Adicionando perfil guest ao usuario
	PERFORM insert_user_into_role(nickname,'guest');

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Insere um guest como usuário que tenha um nusp válido (i.e. está em pessoa).
também liga este usuário a pessoa e perfil, criando entradas em
pe_us e us_pf.
  Importante que haja um perfil com nome 'guest' em perfil ou esta função falhará.
(i.e. executar insert_role('student') primeiro  */
CREATE OR REPLACE FUNCTION insert_guest
(nusp int, curso text, nickname text, email text, password text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil

	INSERT INTO pe_us (pe_us_nusp,pe_us_user_login)
	VALUES(nusp,nickname)
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	--Adicionando perfil guest ao usuario
	PERFORM insert_user_into_role(nickname,'guest');

	--raise notice 'Value %', idperf;
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

/* Pode ser usado para adicionar uma ligação entre uma Disciplina e um
modulo ja existente também. Caso modulo_nome seja NULL,
então a disciplina não será atrelada a ninguém.
   Pode-se chamar também para criar uma noval relação entre disciplina
existente e outro módulo. */
CREATE OR REPLACE FUNCTION insert_disciplina
(disciplina_sigla text, disciplina_unidade text, disciplina_nome text,
disciplina_cred_aula int, disciplina_cred_trabalho int, modulo_nome text)
RETURNS INTEGER AS $$
BEGIN
	IF $6 IS NULL THEN
		INSERT INTO disciplina VALUES ($1,$2,$3,$4,$5);
	ELSE
		INSERT INTO disciplina VALUES ($1,$2,$3,$4,$5) ON CONFLICT DO NOTHING;
		INSERT INTO dis_mod VALUES ($1,$6);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Cria um oferecimento de uma disciplina por um professor. Caso uma data não seja
 adicionada, usa-se a data atual como ministra_data. */
CREATE OR REPLACE FUNCTION insert_oferecimento
(ofer_prof_nusp int, ofer_disciplina_sigla text, ofer_ministra_data date default NULL)
RETURNS INTEGER AS $$
DECLARE
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
BEGIN
	IF $3 IS NULL THEN
		INSERT INTO oferecimento VALUES ($1,$2,date_atm);
	ELSE
		INSERT INTO oferecimento VALUES ($1,$2,$3);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

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

/* Insere uma entrada para um aluno que vai cursar uma disciplina oferecida.
Primeiro verifica-se se o aluno tem esta matéria no planejamento. Depois
é necessária uma checagem para ver se a disciplina está sendo oferecida 
(i.e. o curso está em oferecimento).
 */
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

/* As funções a seguir são usadas para adicionar atributos multi-valorados
às entidades correspondentes. No momento não há intenção de usar estas
para checagem mais complexas de pré-requisitos necessários por falta de tempo.
 */

CREATE OR REPLACE FUNCTION insert_trilha_extrareqs
(INOUT trilha_nome text, INOUT requisito text)
AS
$$
	INSERT INTO trilha_extrareqs 
	VALUES ($1,$2)
	RETURNING trilha_nome, requisito 
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_disciplina_requisitos
(INOUT disciplina_sigla text, INOUT requisito text)
AS
$$
	INSERT INTO disciplina_requisitos 
	VALUES ($1,$2)
	RETURNING disciplina_sigla, requisito 
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_disciplina_biblio
(INOUT disciplina_sigla text, INOUT requisito text)
AS
$$
	INSERT INTO disciplina_biblio
	VALUES ($1,$2)
	RETURNING disciplina_sigla, requisito 
$$
LANGUAGE sql;

-------------------------------------------------------------------
\i EP2_DDL_CLEAN.sql
\i EP2_DDL.sql
\i EP2_DML.sql
