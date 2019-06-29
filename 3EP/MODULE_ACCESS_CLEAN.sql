\c modulo_acesso;
SET ROLE dba;

DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS perfil CASCADE;
DROP TABLE IF EXISTS service CASCADE;
DROP TABLE IF EXISTS us_pf CASCADE;
DROP TABLE IF EXISTS pf_se CASCADE;

----- CRUD for Module acesso -----
DROP FUNCTION IF EXISTS insert_user;
DROP FUNCTION IF EXISTS insert_role;
DROP FUNCTION IF EXISTS insert_service;
DROP FUNCTION IF EXISTS insert_user_into_role;
DROP FUNCTION IF EXISTS insert_role_into_service;

DROP FUNCTION IF EXISTS update_user_email;
DROP FUNCTION IF EXISTS update_user_password;
DROP FUNCTION IF EXISTS update_perfil_descricao;
DROP FUNCTION IF EXISTS update_service_descricao;
DROP FUNCTION IF EXISTS update_us_pf;
DROP FUNCTION IF EXISTS update_pf_se;

DROP FUNCTION IF EXISTS delete_user;
DROP FUNCTION IF EXISTS delete_role;
DROP FUNCTION IF EXISTS delete_service;
DROP FUNCTION IF EXISTS delete_rel_us_pf;
DROP FUNCTION IF EXISTS delete_rel_pf_se;

DROP FUNCTION IF EXISTS return_all_users;
DROP FUNCTION IF EXISTS return_all_roles;
DROP FUNCTION IF EXISTS return_all_services;
DROP FUNCTION IF EXISTS return_all_us_pf;
DROP FUNCTION IF EXISTS return_all_pf_se;
DROP FUNCTION IF EXISTS return_user;
