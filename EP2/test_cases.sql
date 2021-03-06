----Inserting roles----
select * from insert_role('guest');
select * from insert_role('student');
select * from insert_role('teacher');
select * from insert_role('admin');

----!! Inserting service into role !!----
select * from insert_service('student','retrieve_nota','receber uma nota de disciplina');
select * from insert_service('teacher','retrieve_nota','receber uma nota de disciplina');
--Testando inserir só em service
select * from insert_service(NULL,'teste','testando');

----!! Inserting person and then adding her as student!!----
select * from insert_person(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
select * from insert_user(227705861,'BCC','tonya','tonya@email.com','aluno_secret','student');
select * from insert_person(386930905,'290.027.844-46','Felipe','Derby','27-8-1986','M');
select * from insert_user(386930905,'BMAT','felipe','felipe@email.com','aluno2_secret','student');

----!! Inserting person and then adding him as teacher !!----
select * from insert_person(344149328,'774.313.118-03','Raymond','Ho','14-2-1992','M');
select * from insert_user(344149328,'IME','raymond','raymond@email.com','teacher_secret','teacher');
select * from insert_person(588508512,'610.661.507-97','Ismael'	,'Brown','7-10-1950','M');
select * from insert_user(588508512,'POLI','ismael','ismael@email.com','teacher2_secret','teacher');

----!! Inserting person and then adding her as admin !!----
select * from insert_person(933545064,'157.039.387-49','Ellen','Denney','28-3-1956','F');
select * from insert_user(933545064,'IME','ellen','ellen@email.com','admin_secret','admin');
select * from insert_person(169779300,'341.805.458-23','Ronald','Goyette','12-1-1996','M');
select * from insert_user(169779300,'IME','Ronald','ronald@email.com','admin2_secret','admin');

/*Inserting person with role 'teacher' as 'admin' aka testing if a person can have multiple
roles at the same time */
select * from insert_admin(344149328,'IME','raymond','raymond@email.com','adm_teacher_secret');

----!! Inserting curriculum !!----
--Testando N:M
select * from insert_curriculum('BCC' ,'IME','Bacharelado em Ciencia da Computacao',111,52,24,933545064);
select * from insert_curriculum('BMAT' ,'IME','Bacharelado em Matematica',111,52,24,933545064);
select * from insert_curriculum('BCC' ,'IME','Bacharelado em Ciencia da Computacao',111,52,24,169779300);

----!! Inserting trilha !!----
--Testando N:M
select * from insert_trilha('Sistemas',NULL,'BCC');
select * from insert_trilha('Sistemas',NULL,'BMAT');
select * from insert_trilha('Big Data',NULL,'BCC');

--Testando inserir trilha sem ligar com curriculo
select * from insert_trilha('Teste',NULL,NULL);

----!! Inserting modulo !!----
select * from insert_modulo('modulo a','isto é uma descrição','Sistemas');

--Inserindo o mesmo módulo numa outra trilha, deve falhar (i.e. só ter o insert acima)
select * from insert_modulo('modulo a','isto é uma descrição','Big Data');

--Testando inserir modulo sem ligar com uma trilha 
select * from insert_modulo('modulo b','isto é outra descrição',NULL);

----!! Inserting disciplinas !!----
select * from insert_disciplina ('MAC0101','IME' ,'Topicos basicos de computação',4,0,'modulo a');

--inserindo disciplina sem atrelar a um modulo
select * from insert_disciplina ('MAC0102','IME' ,'Teoria de computação',4,2,NULL);

--inserindo a mesma disciplina em outro modulo
select * from insert_disciplina ('MAC0101','IME' ,'Topicos basicos de computação',4,0,'modulo b');

----!! Inserting planeja !!----
select * from insert_planeja(227705861,'MAC0101');

--testando se mesmo nusp pode planejar mais de uma disciplina
select * from insert_planeja(227705861,'MAC0102');

--testando se dois nusps podem planejar a mesma matéria
select * from insert_planeja(386930905,'MAC0101');

----!! Inserting oferecimentos !!----
select * from insert_oferecimento(344149328,'MAC0101',NULL);

--inserindo mesmo professor em outra matéria
select * from insert_oferecimento(344149328,'MAC0102','01-01-2018');

--inserindo outro professor na mesma matéria
select * from insert_oferecimento(588508512,'MAC0101',NULL);

----!! Inserting cursa !!----
select * from insert_cursa(386930905,588508512,'MAC0101',0.0,100.0);

--tentando inserir cursar matéria que não está no planejamento do aluno
select * from insert_cursa(386930905,344149328,'MAC0102',0.0,100.0);

--tentando inserir cursar matéria no planejamento mas que não está sendo oferecida
select * from insert_cursa(386930905,123456,'MAC0101',0.0,100.0);

