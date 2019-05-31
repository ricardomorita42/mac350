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

DROP FUNCTION insert_person(int,text,text,text,date,VARCHAR);
DROP FUNCTION insert_student(int,text,text,text);
DROP FUNCTION insert_role(text);
--DROP FUNCTION priv_insert_user(int,text,text);
--DROP FUNCTION ins_student_trigg() CASCADE;
TRUNCATE b01_pessoa CASCADE;
TRUNCATE b10_usuario CASCADE;
TRUNCATE b09_perfil CASCADE;

--adicionado por um superadmin ou alguém da graduacao
--b01_pessoa = t(NUSP,CPF,PNome,SNome,DataNasc,Sexo)
CREATE OR REPLACE FUNCTION insert_person 
(INOUT NUSP int, INOUT CPF text, INOUT PNome text,
 INOUT SNome text, INOUT DataNasc date, INOUT Sexo VARCHAR(1))
AS
$$
	INSERT INTO b01_pessoa
	VALUES ($1,$2,$3,$4,$5,$6)
	RETURNING NUSP, CPF, PNome, SNome, DataNasc, Sexo
$$
LANGUAGE sql;

CREATE OR REPLACE FUNCTION insert_role 
(OUT perfil_ID int, INOUT pefil_Nome text)
AS
$$
	INSERT INTO b09_perfil
	VALUES (DEFAULT, $1)
	RETURNING perfil_ID, perfil_Nome
$$
LANGUAGE sql;

/*
  Insere um estudante como usuário que tenha um nusp válido (i.e. está em b01_pessoa).
também liga este usuário a b01_pessoa e b09_perfil, criando entradas em
b13a_rel_pe_us e b13b_rel_us_pf.

  Importante que haja um perfil com nome 'student' em b09_perfil ou esta função falhará.
(i.e. executar inserv_role('student') primeiro
 */
CREATE OR REPLACE FUNCTION insert_student
(NUSP int, nickname text, email text, password text)
RETURNS INTEGER AS $$
DECLARE
	idperf  int := (SELECT perfil_ID FROM b09_perfil WHERE perfil_Nome = 'student');
	date_atm date := (SELECT TO_CHAR(NOW() :: DATE,'dd-mm-yyyy'));
	--gerando com numeros aleatorios para auxiliar ao testar, evitando colisao de logins
	login_nick text := TRIM(BOTH FROM nickname) || TRIM(BOTH FROM to_char(floor(random() * 100 + 1),'99'));
BEGIN
	WITH ins1 AS (
	INSERT INTO b10_usuario (us_ID,us_login,us_email,us_password)
	VALUES (DEFAULT,login_nick,email,crypt(password,gen_salt('bf')))
	RETURNING us_ID)

	, ins2 AS (
	INSERT INTO b13a_rel_pe_us 
	VALUES(DEFAULT,NUSP,(select us_ID from ins1))
	RETURNING rel_peus_ID)
	
	INSERT INTO b13b_rel_us_pf
	VALUES(DEFAULT, (select us_ID from ins1), idperf, date_atm);

	--raise notice 'Value %', idperf;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------

select * from insert_role('student');

select * from insert_person(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
select * from insert_student(227705861,'tonya','tonya@email.com','secret');
