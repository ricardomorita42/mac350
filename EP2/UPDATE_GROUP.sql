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

--Dado um numero usp, atualiza o sexo de uma pessoa.
CREATE OR REPLACE FUNCTION update_sexo
(IN num_usp int, INOUT new_sexo varchar(1))
AS $$
	UPDATE pessoa 
	SET sexo = new_sexo
	WHERE nusp = num_usp
	RETURNING new_sexo
$$ LANGUAGE sql;

------------------------------------------------------------

--dado um user_login, atualiza o password.
CREATE OR REPLACE FUNCTION update_password
(IN login TEXT, IN new_password text, OUT success boolean)
AS $$
	UPDATE usuario
	SET user_password = crypt(new_password,gen_salt('bf'))
	WHERE user_login = login 
	RETURNING TRUE 
$$ LANGUAGE sql;

/* Atualiza a descrição de um perfil. 
Da maneira como foi implementado, o nome da descrição é chave 1aria.
Portanto, caso seja necessário renomear um perfil, deve-se criar outro perfil
e apagar o perfil antigo. Esta função só renomeia a descrição
de um perfil preexistente. */
CREATE OR REPLACE FUNCTION update_perfil
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE perfil 
	SET perfil_descricao =  new_descricao
	WHERE perfil_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;

/* Atualiza a descrição de um serviço.
Da maneira como foi implementado, o nome da descrição é chave 1aria.
Portanto, caso seja necessário renomear um service, deve-se criar outro service
e apagar o service antigo. Esta função só renomeia a descrição
de um service preexistente. */
CREATE OR REPLACE FUNCTION update_service
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE service 
	SET service_descricao =  new_descricao
	WHERE service_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;

--Atualiza a unidade ligada à um professor
CREATE OR REPLACE FUNCTION update_prof_unidade
(INOUT nusp int, INOUT new_unidade text)
AS $$
	UPDATE professor
	SET prof_unidade = new_unidade
	WHERE prof_nusp = nusp
	RETURNING prof_nusp, prof_unidade 
$$ LANGUAGE sql;

--Atualiza a unidade ligada à um admin 
CREATE OR REPLACE FUNCTION update_admin_unidade
(INOUT nusp int, INOUT new_unidade text)
AS $$
	UPDATE admnistrador
	SET admin_unidade = new_unidade
	WHERE admin_nusp = nusp
	RETURNING admin_nusp, admin_unidade 
$$ LANGUAGE sql;

--Atualiza o curso ligado a um aluno
CREATE OR REPLACE FUNCTION update_aluno_curso
(INOUT nusp int, INOUT new_curso text)
AS $$
	UPDATE aluno
	SET aluno_curso= new_curso
	WHERE aluno_nusp = nusp
	RETURNING aluno_nusp, aluno_curso
$$ LANGUAGE sql;

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

------------------- Updates em Disciplina ------------------
CREATE OR REPLACE FUNCTION update_disciplina_unidade
(INOUT sigla text, INOUT new_unidade text)
AS $$
	UPDATE disciplina
	SET disciplina_unidade = new_unidade
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_unidade
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION update_disciplina_nome
(INOUT sigla text, INOUT new_nome text)
AS $$
	UPDATE disciplina
	SET disciplina_nome = new_nome
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_nome
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION update_disciplina_cred_aula
(INOUT sigla text, INOUT new_cred_aula int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_aula = new_cred_aula
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_aula
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION update_disciplina_cred_trabalho
(INOUT sigla text, INOUT new_cred_trabalho int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_trabalho = new_cred_trabalho
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_trabalho
$$ LANGUAGE sql;
------------------------------------------------------------
