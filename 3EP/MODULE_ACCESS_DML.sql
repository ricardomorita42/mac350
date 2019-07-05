\c modulo_acesso
SET ROLE dba;

----Inserting roles----
select * from insert_role('guest');
select * from insert_role('student');
select * from insert_role('teacher');
select * from insert_role('admin');
select * from insert_role('intern');
select * from insert_role('superadmin');
select * from insert_role('dba');
select * from insert_role('debugger');
select * from insert_role('reitor');
select * from insert_role('api');

---- Inserting services----
select * from insert_service('dba','insert_person',NULL);
select * from insert_service('dba','insert_role',NULL);
select * from insert_service('dba','insert_user',NULL);
select * from insert_service('dba','insert_service',NULL);
select * from insert_service('dba','insert_into_administra',NULL);
select * from insert_service('dba','insert_curriculum',NULL);
select * from insert_service('dba','insert_user_into_role',NULL);
select * from insert_service('dba','insert_trilha',NULL);
select * from insert_service('dba','insert_modulo',NULL);
select * from insert_service('dba','insert_disciplina',NULL);
select * from insert_service('dba','insert_ministra',NULL);
select * from insert_service('dba','insert_oferecimento',NULL);
select * from insert_service('dba','insert_planeja',NULL);
select * from insert_service('dba','insert_cursa',NULL);
select * from insert_service('dba','insert_trilha_extrareqs',NULL);
select * from insert_service('dba','insert_disciplina_requisitos',NULL);
select * from insert_service('dba','insert_disciplina_biblio',NULL);

----Inserting Users----
select * from insert_user('tonya'		,'tonya@email.com'		,'aluno_secret'  ,'student');
select * from insert_user('felipe'		,'felipe@email.com'		,'aluno2_secret' ,'student');
select * from insert_user('danny'		,'danny@email.com'		,'aluno3_secret' ,'student');
select * from insert_user('lauryn'		,'lauryn@email.com'		,'aluno4_secret' ,'student');
select * from insert_user('lillian'		,'lillian@email.com'	,'aluno5_secret' ,'student');
select * from insert_user('jessica'		,'jessica@email.com'	,'aluno6_secret' ,'student');
select * from insert_user('joann'		,'joann@email.com'		,'aluno7_secret' ,'student');
select * from insert_user('robert'		,'robert@email.com'		,'aluno8_secret' ,'student');
select * from insert_user('rodney'		,'rodney@email.com'		,'aluno9_secret' ,'student');
select * from insert_user('james'		,'james@email.com'		,'aluno10_secret','student');
select * from insert_user('jeana'		,'jeana@email.com'		,'aluno11_secret','student');
select * from insert_user('heather'		,'heather@email.com'	,'aluno12_secret','student');
select * from insert_user('otis'		,'otis@email.com'		,'aluno13_secret','student');
select * from insert_user('gregory'		,'gregory@email.com'	,'aluno14_secret','student');
select * from insert_user('kelly'		,'kelly@email.com'		,'aluno15_secret','student');
select * from insert_user('marie'		,'marie@email.com'		,'aluno16_secret','student');
select * from insert_user('elliott'		,'elliott@email.com'	,'aluno17_secret','student');
select * from insert_user('david'		,'david@email.com'		,'aluno18_secret','student');
select * from insert_user('chester'		,'chester@email.com'	,'aluno19_secret','student');
select * from insert_user('dave'		,'dave@email.com'		,'aluno20_secret','student');

select * from insert_user('ismael'		,'p_ismael@email.com'	,'teacher_secret'  ,'teacher');
select * from insert_user('virginia'	,'p_virginia@email.com' ,'teacher2_secret' ,'teacher');
select * from insert_user('virginia2'	,'p_virginia2@email.com','teacher3_secret' ,'teacher');
select * from insert_user('roland'		,'p_roland@email.com'	,'teacher4_secret' ,'teacher');
select * from insert_user('charles'		,'p_charles@email.com'  ,'teacher5_secret' ,'teacher');
select * from insert_user('michelle'	,'p_michelle@email.com' ,'teacher6_secret' ,'teacher');
select * from insert_user('laurence'	,'p_laurence@email.com' ,'teacher7_secret' ,'teacher');
select * from insert_user('ray'			,'p_ray@email.com'		,'teacher8_secret' ,'teacher');
select * from insert_user('shane'		,'p_shane@email.com'	,'teacher9_secret' ,'teacher');
select * from insert_user('raymond'		,'p_raymond@email.com'	,'teacher10_secret','teacher');

select * from insert_user('ellen'		,'a_ellen@email.com'	,'admin1_secret' ,'admin');
select * from insert_user('ronald'		,'a_ronald@email.com'	,'admin2_secret' ,'admin');
select * from insert_user('brenda'		,'a_brenda@email.com'	,'admin3_secret' ,'admin');
select * from insert_user('jean'		,'a_jean@email.com'		,'admin4_secret' ,'admin');
select * from insert_user('katherine'	,'a_katherine@email.com','admin5_secret' ,'admin');
select * from insert_user('zachary'		,'a_zachary@email.com'	,'admin6_secret' ,'admin');
select * from insert_user('elizabeth'	,'a_elizabeth@email.com','admin7_secret' ,'admin');
select * from insert_user('melanie'		,'a_melanie@email.com'	,'admin8_secret' ,'admin');
select * from insert_user('christy'		,'a_christy@email.com'	,'admin9_secret' ,'admin');
select * from insert_user('karen'		,'a_karen@email.com'	,'admin10_secret','admin');
