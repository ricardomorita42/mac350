BEGIN;
------------------- Updates em Pessoa ------------------
--Dado um numero usp, atualiza pnome e snome.
CREATE OR REPLACE FUNCTION update_nome
(IN num_usp int, INOUT new_pnome text, INOUT new_snome text)
AS 
$$
	UPDATE pessoa 
	SET pnome = new_pnome, snome = new_snome
	WHERE nusp = num_usp
	RETURNING pnome,snome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_nome(int,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_nome(int,text,text)
	TO dba,guest;
COMMIT;

BEGIN;
--Dado um numero usp, atualiza a data de nascimento.
CREATE OR REPLACE FUNCTION update_datanasc
(IN num_usp int, INOUT new_datanasc date)
AS 
$$
	UPDATE pessoa 
	SET datanasc = new_datanasc
	WHERE nusp = num_usp
	RETURNING new_datanasc
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_datanasc(int,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_datanasc(int,date)
	TO dba,guest;
COMMIT;

BEGIN;
--Dado um numero usp, atualiza o sexo de uma pessoa.
CREATE OR REPLACE FUNCTION update_sexo
(IN num_usp int, INOUT new_sexo varchar(1))
AS $$
	UPDATE pessoa 
	SET sexo = new_sexo
	WHERE nusp = num_usp
	RETURNING new_sexo
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_sexo(int,varchar(1))
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_sexo(int,varchar(1))
	TO dba,guest;
COMMIT;

BEGIN;
------------------------------------------------------------
--dado um user_login, atualiza o email.
CREATE OR REPLACE FUNCTION update_email
(INOUT login TEXT, INOUT new_email text)
AS $$
	UPDATE usuario
	SET user_email = new_email 
	WHERE user_login = login 
	RETURNING user_login,user_email
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_email(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_email(text,text)
	TO dba;
COMMIT;

BEGIN;
--dado um user_login, atualiza o password.
CREATE OR REPLACE FUNCTION update_password
(IN login TEXT, IN new_password text, OUT success boolean)
AS $$
	UPDATE usuario
	SET user_password = crypt(new_password,gen_salt('bf'))
	WHERE user_login = login 
	RETURNING TRUE 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_password(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_password(text,text)
	TO dba,guest;
COMMIT;

BEGIN;
-- Atualiza a descrição de um perfil. 
CREATE OR REPLACE FUNCTION update_perfil_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE perfil 
	SET perfil_descricao =  new_descricao
	WHERE perfil_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_perfil_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_perfil_descricao(text,text)
	TO dba;
COMMIT;

BEGIN;
-- Atualiza a descrição de um serviço.
CREATE OR REPLACE FUNCTION update_service
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE service 
	SET service_descricao =  new_descricao
	WHERE service_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_service(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_service(text,text)
	TO dba;
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
	TO dba,teacher;
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
	TO dba,student;
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
	TO dba,teacher;
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
	TO dba,teacher;
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
	TO dba,teacher;
COMMIT;

BEGIN;
--Mudar uma sigla de disciplina para outra sigla
--Obs: Como insert_cursa depende de planeja, não é bom usar esta função.
CREATE OR REPLACE FUNCTION update_planeja_disciplina
(INOUT nusp int, INOUT new_sigla text)
AS $$
	UPDATE planeja 
	SET planeja_disciplina_sigla = new_sigla
	WHERE planeja_aluno_nusp = nusp
	RETURNING planeja_aluno_nusp,planeja_disciplina_sigla
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_planeja_disciplina(int,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_planeja_disciplina(int,text)
	TO dba,student;
COMMIT;

BEGIN;
------------------- Updates em Disciplina ------------------
CREATE OR REPLACE FUNCTION update_disciplina_unidade
(INOUT sigla text, INOUT new_unidade text)
AS $$
	UPDATE disciplina
	SET disciplina_unidade = new_unidade
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_unidade
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_unidade(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_unidade(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_nome
(INOUT sigla text, INOUT new_nome text)
AS $$
	UPDATE disciplina
	SET disciplina_nome = new_nome
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_nome(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_nome(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_cred_aula
(INOUT sigla text, INOUT new_cred_aula int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_aula = new_cred_aula
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_aula
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_cred_aula(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_cred_aula(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_cred_trabalho
(INOUT sigla text, INOUT new_cred_trabalho int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_trabalho = new_cred_trabalho
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_trabalho
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_cred_trabalho(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_cred_trabalho(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
/* deve-se inserir nova entrada em administra caso se queira
mudar outros atributos da tabela. Se houvesse data de final
esta função será mais útil com leve adaptação. */
CREATE OR REPLACE FUNCTION update_administra_data_inicio
(INOUT nusp int, INOUT curriculo_sigla text, INOUT new_data date)
AS $$
	UPDATE administra
	SET administra_inicio = new_data
	WHERE	administra_nusp = nusp AND
		administra_curriculo_sigla = curriculo_sigla 
	RETURNING administra_nusp, administra_curriculo_sigla, administra_inicio
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_administra_data_inicio(int,text,date)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_administra_data_inicio(int,text,date)
	TO dba,admin;
COMMIT;

BEGIN;
------------------- Updates em Curriculo ------------------
CREATE OR REPLACE FUNCTION update_curriculo_unidade
(INOUT sigla text, INOUT new_unidade text)
AS $$
	UPDATE curriculo
	SET curriculo_unidade = new_unidade
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_unidade
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_unidade(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_unidade(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_nome
(INOUT sigla text, INOUT new_nome text)
AS $$
	UPDATE curriculo
	SET curriculo_nome = new_nome
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_nome(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_nome(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_obrig
(INOUT sigla text, INOUT new_cred_obrig int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_obrig = new_cred_obrig
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_obrig
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_obrig(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_obrig(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_opt_elet
(INOUT sigla text, INOUT new_cred_opt_elet int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_opt_elet = new_cred_opt_elet
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_opt_elet
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_opt_elet(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_opt_elet(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_opt_liv
(INOUT sigla text, INOUT new_cred_opt_liv int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_opt_liv = new_cred_opt_liv
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_opt_liv
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_opt_liv(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_opt_liv(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda descrição de uma trilha
CREATE OR REPLACE FUNCTION update_trilha_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE trilha
	SET trilha_descricao = new_descricao
	WHERE trilha_nome = nome 
	RETURNING trilha_nome , trilha_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_trilha_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_trilha_descricao(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda descrição de um modulo 
CREATE OR REPLACE FUNCTION update_modulo_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE modulo
	SET modulo_descricao = new_descricao
	WHERE modulo_nome = nome 
	RETURNING modulo_nome , modulo_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_modulo_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_modulo_descricao(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda bibliografia de uma disciplina
CREATE OR REPLACE FUNCTION update_disc_biblio_descricao
(INOUT disc_sigla text, INOUT new_descricao text)
AS $$
	UPDATE disciplina_biblio
	SET disc_biblio_descricao = new_descricao
	WHERE disc_biblio_disciplina_sigla = disc_sigla
	RETURNING disc_biblio_disciplina_sigla, disc_biblio_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disc_biblio_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disc_biblio_descricao(text,text)
	TO dba,admin;
COMMIT;
