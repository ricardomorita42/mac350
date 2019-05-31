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
DROP FUNCTION insert_student(int,text,text);
--DROP FUNCTION priv_insert_user(int,text,text);
--DROP FUNCTION ins_student_trigg() CASCADE;
TRUNCATE b01_pessoa CASCADE;
TRUNCATE b10_usuario CASCADE;

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

/* Um aluno que tenha dado em b01_pessoa pode criar uma
conta de aluno com esta função, informando NUSP para associar 
b10_usuario com alguem de b01_pessoa na relação b13a_rel_pe_us.
CREATE OR REPLACE FUNCTION insert_student
(INOUT NUSP int, INOUT email text, INOUT password text,OUT us_ID int)
AS $$
	--SELECT priv_insert_user(NUSP, us_email, password);
	INSERT INTO b10_usuario (us_ID,us_email,us_password)
	VALUES (DEFAULT,email,password)
	RETURNING NUSP, email,password,us_ID;

$$ LANGUAGE sql;
*/
CREATE OR REPLACE FUNCTION insert_student
(NUSP int, email text, password text)
RETURNS INTEGER AS $$
BEGIN
	WITH ins1 AS (
	INSERT INTO b10_usuario (us_ID,us_email,us_password)
	VALUES (DEFAULT,email,crypt(password,gen_salt('bf')))
	RETURNING us_ID)

	INSERT INTO b13a_rel_pe_us 
	VALUES(DEFAULT,NUSP,(select us_ID from ins1));
	RETURN NUSP;
END;
$$ LANGUAGE plpgsql;

/*
CREATE OR REPLACE FUNCTION ins_student_trigg() 
RETURNS trigger AS $stu_stamp$
BEGIN
	INSERT INTO b13a_rel_pe_us
	VALUES (DEFAULT,NEW.NUSP,NEW.us_ID);
	RETURN NEW;
END; 
$stu_stamp$ LANGUAGE plpgsql;

CREATE TRIGGER create_rel_pe_us
	AFTER INSERT ON b10_usuario
	FOR EACH ROW
	EXECUTE PROCEDURE ins_student_trigg();
*/
-------------------------------------------------------------------

select * from insert_person(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
select * from insert_student(227705861,'tonya@email.com','secret');
