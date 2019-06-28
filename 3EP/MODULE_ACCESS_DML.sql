\c acesso
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
select * from insert_user(227705861,'BCC' ,'tonya'	,'tonya@email.com'	,'aluno_secret'  ,'student');
select * from insert_user(386930905,'BMAT','felipe'	,'felipe@email.com'	,'aluno2_secret' ,'student');
select * from insert_user(859852130,'BCC' ,'danny'	,'danny@email.com'	,'aluno3_secret' ,'student');
select * from insert_user(310554114,'BCC' ,'lauryn'	,'lauryn@email.com'	,'aluno4_secret' ,'student');
select * from insert_user(613923368,'BCC' ,'lillian'	,'lillian@email.com'	,'aluno5_secret' ,'student');
select * from insert_user(311285463,'BCC' ,'jessica'	,'jessica@email.com'	,'aluno6_secret' ,'student');
select * from insert_user(991002548,'BCC' ,'joann'	,'joann@email.com'	,'aluno7_secret' ,'student');
select * from insert_user(158298846,'BCC' ,'robert'	,'robert@email.com'	,'aluno8_secret' ,'student');
select * from insert_user(761213416,'BCC' ,'rodney'	,'rodney@email.com'	,'aluno9_secret' ,'student');
select * from insert_user(702391605,'BCC' ,'james'	,'james@email.com'	,'aluno10_secret','student');
select * from insert_user(559853740,'BCC' ,'jeana'	,'jeana@email.com'	,'aluno11_secret','student');
select * from insert_user(994567006,'BCC' ,'heather'	,'heather@email.com'	,'aluno12_secret','student');
select * from insert_user(230057892,'BMAT','otis'	,'otis@email.com'	,'aluno13_secret','student');
select * from insert_user(961065297,'BMAT','gregory'	,'gregory@email.com'	,'aluno14_secret','student');
select * from insert_user(162109146,'BMAT','kelly'	,'kelly@email.com'	,'aluno15_secret','student');
select * from insert_user(939847659,'BMAT','marie'	,'marie@email.com'	,'aluno16_secret','student');
select * from insert_user(489997003,'BMAE','elliott'	,'elliott@email.com'	,'aluno17_secret','student');
select * from insert_user(365513041,'BMAE','david'	,'david@email.com'	,'aluno18_secret','student');
select * from insert_user(300606205,'BMAE','chester'	,'chester@email.com'	,'aluno19_secret','student');
select * from insert_user(815705605,'BMAE','dave'	,'dave@email.com'	,'aluno20_secret','student');

select * from insert_user(588508512,'POLI','ismael'	,'p_ismael@email.com'	,'teacher_secret'  ,'teacher');
select * from insert_user(217525199,'IME' ,'virginia'	,'p_virginia@email.com' ,'teacher2_secret' ,'teacher');
select * from insert_user(403856584,'IME' ,'virginia2'	,'p_virginia2@email.com','teacher3_secret' ,'teacher');
select * from insert_user(629091676,'IME' ,'roland'	,'p_roland@email.com'	,'teacher4_secret' ,'teacher');
select * from insert_user(914806276,'IME' ,'charles'	,'p_charles@email.com'  ,'teacher5_secret' ,'teacher');
select * from insert_user(442932985,'EACH','michelle'	,'p_michelle@email.com' ,'teacher6_secret' ,'teacher');
select * from insert_user(292003247,'POLI','laurence'	,'p_laurence@email.com' ,'teacher7_secret' ,'teacher');
select * from insert_user(388414429,'IME' ,'ray'	,'p_ray@email.com'	,'teacher8_secret' ,'teacher');
select * from insert_user(886902161,'IME' ,'shane'	,'p_shane@email.com'	,'teacher9_secret' ,'teacher');
select * from insert_user(344149328,'IME' ,'raymond'	,'p_raymond@email.com'	,'teacher10_secret','teacher');

select * from insert_user(933545064,'IME' ,'ellen'	,'a_ellen@email.com'	,'admin1_secret' ,'admin');
select * from insert_user(169779300,'IME' ,'ronald'	,'a_ronald@email.com'	,'admin2_secret' ,'admin');
select * from insert_user(180318059,'IME' ,'brenda'	,'a_brenda@email.com'	,'admin3_secret' ,'admin');
select * from insert_user(813824779,'IME' ,'jean'	,'a_jean@email.com'	,'admin4_secret' ,'admin');
select * from insert_user(704437879,'POLI','katherine'	,'a_katherine@email.com','admin5_secret' ,'admin');
select * from insert_user(773718543,'IME' ,'zachary'	,'a_zachary@email.com'	,'admin6_secret' ,'admin');
select * from insert_user(377913230,'IME' ,'elizabeth'	,'a_elizabeth@email.com','admin7_secret' ,'admin');
select * from insert_user(306625659,'IME' ,'melanie'	,'a_melanie@email.com'	,'admin8_secret' ,'admin');
select * from insert_user(295230948,'POLI','christy'	,'a_christy@email.com'	,'admin9_secret' ,'admin');
select * from insert_user(897719693,'IME' ,'karen'	,'a_karen@email.com'	,'admin10_secret','admin');
