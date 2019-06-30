/* Usuario q executa este script eh super user*/
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234';
CREATE ROLE aluno 
	LOGIN ENCRYPTED PASSWORD 'aluno';
CREATE ROLE professor 
	LOGIN ENCRYPTED PASSWORD 'prof';
CREATE ROLE admin 
	LOGIN ENCRYPTED PASSWORD 'admin';
CREATE ROLE guest 
	LOGIN ENCRYPTED PASSWORD 'guest';

CREATE DATABASE modulo_acesso OWNER dba;
CREATE DATABASE modulo_curriculo OWNER dba;
CREATE DATABASE modulo_pessoa OWNER dba;
CREATE DATABASE inter_mod_pes_cur OWNER dba;
CREATE DATABASE inter_mod_ace_pes OWNER dba;

GRANT guest to dba,aluno,professor,admin;

CREATE EXTENSION IF NOT EXISTS citext;
DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

\i MODULE_ACCESS_DDL.sql
\i INTER_MOD_ACC_PEO_DDL.sql
\i MODULE_CURRICULUM_DDL.sql
\i MODULE_PEOPLE_DDL.sql
\i INTER_MOD_PEO_CUR_DDL.sql

\i MODULE_ACCESS_FUNCTIONS.sql
\i INTER_MOD_ACC_PEO_FUNCTIONS.sql
\i MODULE_CURRICULUM_FUNCTIONS.sql
\i MODULE_PEOPLE_FUNCTIONS.sql
\i INTER_MOD_PEO_CUR_FUNCTIONS.sql

/* A divisao do DML do DB modulo_pessoa foi feita em tres partes por que
este necessita que os DMLs dos outros DBs sejam preenchidos para que este
seja corretamente adicionado. Mas os outros DBs necessitam de partes do
DML de modulo_pessoa, entao foi necessario carregar em partes o DML de
modulo_pessoa. */
\i MODULE_ACCESS_DML.sql
\i MODULE_CURRICULUM_DML.sql
\i MODULE_PEOPLE_DML.sql
\i INTER_MOD_ACC_PEO_DML.sql
\i MODULE_PEOPLE_DML2.sql
\i INTER_MOD_PEO_CUR_DML.sql
\i MODULE_PEOPLE_DML3.sql
