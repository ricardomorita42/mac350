/* Usuario q executa este script eh super user*/
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234'
	VALID UNTIL '2019-08-01';
CREATE ROLE aluno 
	LOGIN ENCRYPTED PASSWORD 'aluno'
	VALID UNTIL '2019-08-01';
CREATE ROLE professor 
	LOGIN ENCRYPTED PASSWORD 'prof'
	VALID UNTIL '2019-08-01';
CREATE ROLE admin 
	LOGIN ENCRYPTED PASSWORD 'admin'
	VALID UNTIL '2019-08-01';
CREATE ROLE guest 
	LOGIN ENCRYPTED PASSWORD 'guest'
	VALID UNTIL '2019-08-01';

CREATE DATABASE modulo_acesso OWNER dba;
CREATE DATABASE modulo_curriculo OWNER dba;
CREATE DATABASE modulo_pessoa OWNER dba;
CREATE DATABASE inter_mod_pes_cur OWNER dba;
CREATE DATABASE inter_mod_ace_pes OWNER dba;

GRANT guest to dba,aluno,professor,admin;

\i MODULE_ACCESS_DDL.sql
\i MODULE_ACCESS_FUNCTIONS.sql
\i MODULE_ACCESS_DML.sql

\i INTER_MOD_ACC_PEO_DDL.sql
\i INTER_MOD_ACC_PEO_FUNCTIONS.sql
/* INTER_MOD_ACC_PEO_DML.sql requires valid people to be run 
 so it'll be run inside MODULE_PEOPLE_DML.sql. The order is
 important because entries can only be added to pessoa.aluno,
 pessoa.professor and pessoa.admnistrador if they have a
 valid account which requires a check into inter_ace_pes db.
 additionally, it adds an entry into acesso.us_pf .*/

\i MODULE_PEOPLE_DDL.sql
\i MODULE_PEOPLE_FUNCTIONS.sql
\i MODULE_PEOPLE_DML.sql
