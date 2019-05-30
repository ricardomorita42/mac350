/*
Next lines checks if you have permission to create extensions
and:
	*create two extensions: pgcrypto for password and citext for email check
	*create a role dba and a schema admins
	*grant permissions to dba over admins
*/

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
-- For security create admin schema as well
CREATE ROLE dba
	WITH SUPERUSER CREATEDB CREATEROLE
	LOGIN ENCRYPTED PASSWORD 'dba1234'
	VALID UNTIL '2019-07-01';
CREATE SCHEMA IF NOT EXISTS admins;
GRANT admins TO dba;

/*
If you get something like:
ERROR:  permission denied to create extension "pgcrypto"
HINT:  Must be superuser to create this extension.
It means that the current user does not permissions to create extensions,
in that case, log out and use the postgres superuser our grant superuser
permission to yourself.
Usually you can log as postgres by doing:
$sudo su - postgres
$psql -d <NAME_OF_THE_DATABASE>
Example:
decio@laptop:~$ sudo su - postgres
postgres@laptop$ psql -d test
psql (9.5.16)
Type "help" for help.

test=# CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION
test=# \q
*/

/*
After creating the extensions, lets create a domain for valid emails
Valid emails follows a specific Request for Comment defined in RFC5322
For more info, see: https://tools.ietf.org/html/rfc5322
*/
DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );


/*
After creating the EXTENSIONs and the email DOMAIN, go back to your user
and execute.
*/
DROP TABLE IF EXISTS b10_usuario CASCADE;
CREATE TABLE b10_usuario(
	us_id       	SERIAL,
	us_email    	email,
	us_password 	TEXT NOT NULL,
	us_perfil_id	INTEGER,

	CONSTRAINT pk_user PRIMARY KEY (us_id),
	CONSTRAINT sk_user UNIQUE (us_email),
	CONSTRAINT fk_usuario FOREIGN KEY (us_perfil_id)
		REFERENCES b09_perfil (perfil_id)
);

/*
You should create a function and trigger to insert new user, but since I don't
want to spoil all the fun, I will just provide the insert operation syntax
*/

-- Remove comments from the next line to text the insertion of a tuple
INSERT INTO b10_usuario (us_email, us_password) VALUES ('decio@mail.com', crypt('deciopassword', gen_salt('bf')));

/*
INSERT 0 1
test=> select * from users;
 id |     email      |                           password                           
----+----------------+--------------------------------------------------------------
  1 | decio@mail.com | $2a$06$hrVWxlypvvjRY5xat9YNPeHy9H2aD8h5NFwvrvUc9aRZjSe7H9Ul.
(1 row)
*/

/*
Below I present a function for password check that returns true if password
match.
To avoid sharing salt between API and Database, I defined that our agreement
is that:
	*API and client must agree on some hashing method between them.
	*Between API server-side and Database the call is made using plain text
	*Database checks with their internal hash/salt and returns only true/false
	*API and client must agree on how to deal with that information
Due security issues, I am defining and executing it under a transaction.
This may be a little paranoid because the system is not yet deployed and we
will take the roles of DBAs, back-end and front-end developers ourselves, but
good practices never die, right? :-)
I am setting a security search path in admin schema to avoid malicious use
of the function. Fell free to adjust the schema to your needs or leave it
without SECURITY DEFINER Definition.
*/

-- BEGIN OF THE ENTIRE TRANSACTION
BEGIN;
-- Firstly we define the function
-- START OF THE FUNCTION PART!
CREATE OR REPLACE FUNCTION check_password(user_email email, user_pass TEXT)
RETURNS BOOLEAN AS $$
DECLARE
valid_login BOOLEAN;
BEGIN
	-- This select returns either 1 row if valid or 0 rows if invalid
	-- Just setting the case password match to a boolean
	SELECT COUNT(*) = 1 INTO valid_login
	FROM public.users
	WHERE us_email = $1 AND us_password = public.crypt($2, us_password);

	RETURN valid_login;
END;
$$  LANGUAGE plpgsql
    SECURITY DEFINER
	-- Here we set the secure search_path, by providing a trusted
	-- schema (admin) before anything else like pg_temp
    SET search_path = admins, pg_temp;

-- END OF THE FUNCTION PART!

-- With function defined, we revoke permission to call from public
-- And allow call just from dba
REVOKE ALL ON FUNCTION check_password(user_email email, user_pass TEXT)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION check_password(user_email email, user_pass TEXT)
	TO dba;
COMMIT;
-- END OF THE ENTIRE TRANSACTION
