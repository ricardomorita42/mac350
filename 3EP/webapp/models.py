# coding: utf-8
# Generated using sqlacodegen
from sqlalchemy import CheckConstraint, Column, Date, ForeignKey, Integer, Numeric, String, Table, Text, text
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata

#DB modulo_pessoa
class Pessoa(Base):
    __tablename__ = 'pessoa'
    __table_args__ = (
        CheckConstraint("(cpf)::text ~~ '___.___.___-__'::text"),
        CheckConstraint("(sexo)::text = ANY ((ARRAY['F'::character varying, 'M'::character varying, 'O'::character varying])::text[])")
    )

    nusp = Column(Integer, primary_key=True, server_default=text("nextval('pessoa_nusp_seq'::regclass)"))
    cpf = Column(String(14), nullable=False, unique=True)
    pnome = Column(Text, nullable=False)
    snome = Column(Text, nullable=False)
    datanasc = Column(Date, nullable=False)
    sexo = Column(String(1), nullable=False)


class Administrador(Pessoa):
    __tablename__ = 'administrador'

    admin_nusp = Column(ForeignKey('pessoa.nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    admin_unidade = Column(Text, nullable=False)


class Professor(Pessoa):
    __tablename__ = 'professor'

    prof_nusp = Column(ForeignKey('pessoa.nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    prof_unidade = Column(Text, nullable=False)


class Aluno(Base):
    __tablename__ = 'aluno'

    aluno_nusp = Column(ForeignKey('pessoa.nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False, unique=True)
    aluno_curso = Column(Text, primary_key=True, nullable=False)

    pessoa = relationship('Pessoa', uselist=False)


class Cursa(Base):
    __tablename__ = 'cursa'
    __table_args__ = (
        CheckConstraint('(cursa_nota >= (0)::numeric) AND (cursa_nota <= (10)::numeric)'),
        CheckConstraint('(cursa_presenca >= (0)::numeric) AND (cursa_presenca <= (100)::numeric)')
    )

    cursa_aluno_nusp = Column(ForeignKey('aluno.aluno_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    cursa_aluno_curso = Column(Text, primary_key=True, nullable=False)
    cursa_prof_nusp = Column(ForeignKey('professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    cursa_disciplina_sigla = Column(Text, primary_key=True, nullable=False)
    cursa_data = Column(Date, primary_key=True, nullable=False)
    cursa_nota = Column(Numeric, nullable=False)
    cursa_presenca = Column(Numeric, nullable=False)

    aluno = relationship('Aluno')
    professor = relationship('Professor')


class Oferecimento(Base):
    __tablename__ = 'oferecimento'

    ofer_prof_nusp = Column(ForeignKey('professor.prof_nusp', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    ofer_disciplina_sigla = Column(Text, primary_key=True, nullable=False)
    ofer_ministra_data = Column(Date, primary_key=True, nullable=False)

    professor = relationship('Professor')


#DB modulo_acesso
class Perfil(Base):
    __tablename__ = 'perfil'

    perfil_nome = Column(Text, primary_key=True)
    perfil_descricao = Column(Text)

    service = relationship('Service', secondary='pf_se')


class Service(Base):
    __tablename__ = 'service'

    service_nome = Column(Text, primary_key=True)
    service_descricao = Column(Text)


class Usuario(Base):
    __tablename__ = 'usuario'

    user_login = Column(Text, primary_key=True)
    user_email = Column(Text, nullable=False, unique=True)
    user_password = Column(Text, nullable=False)


t_pf_se = Table(
    'pf_se', metadata,
    Column('pf_se_perfil_nome', ForeignKey('perfil.perfil_nome', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    Column('pf_se_service_nome', ForeignKey('service.service_nome', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
)


class UsPf(Base):
    __tablename__ = 'us_pf'

    us_pf_user_login = Column(ForeignKey('usuario.user_login'), primary_key=True, nullable=False)
    us_pf_perfil_nome = Column(ForeignKey('perfil.perfil_nome'), primary_key=True, nullable=False)
    us_pf_perfil_inicio = Column(Date)

    perfil = relationship('Perfil')
    usuario = relationship('Usuario')

#DB modelo_curriculo
class Curriculo(Base):
    __tablename__ = 'curriculo'
    __table_args__ = (
        CheckConstraint('(curriculo_cred_obrig > 0) AND (curriculo_cred_obrig < 10000)'),
        CheckConstraint('(curriculo_cred_opt_elet > 0) AND (curriculo_cred_opt_elet < 10000)'),
        CheckConstraint('(curriculo_cred_opt_liv > 0) AND (curriculo_cred_opt_liv < 10000)')
    )

    curriculo_sigla = Column(Text, primary_key=True)
    curriculo_unidade = Column(Text)
    curriculo_nome = Column(Text)
    curriculo_cred_obrig = Column(Integer, nullable=False)
    curriculo_cred_opt_elet = Column(Integer, nullable=False)
    curriculo_cred_opt_liv = Column(Integer, nullable=False)

    trilha = relationship('Trilha', secondary='cur_tril')


class Disciplina(Base):
    __tablename__ = 'disciplina'
    __table_args__ = (
        CheckConstraint('(disciplina_cred_aula >= 0) AND (disciplina_cred_aula < 1000)'),
        CheckConstraint('(disciplina_cred_trabalho >= 0) AND (disciplina_cred_trabalho < 1000)')
    )

    disciplina_sigla = Column(Text, primary_key=True)
    disciplina_unidade = Column(Text)
    disciplina_nome = Column(Text)
    disciplina_cred_aula = Column(Integer)
    disciplina_cred_trabalho = Column(Integer)

    modulo = relationship('Modulo', secondary='dis_mod')
    parents = relationship(
        'Disciplina',
        secondary='disciplina_requisitos',
        primaryjoin='Disciplina.disciplina_sigla == disciplina_requisitos.c.disc_reqs_disciplina_requisito',
        secondaryjoin='Disciplina.disciplina_sigla == disciplina_requisitos.c.disc_reqs_disciplina_sigla'
    )


class DisciplinaBiblio(Disciplina):
    __tablename__ = 'disciplina_biblio'

    disc_biblio_disciplina_sigla = Column(ForeignKey('disciplina.disciplina_sigla', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    disc_biblio_descricao = Column(Text, nullable=False)


class Trilha(Base):
    __tablename__ = 'trilha'

    trilha_nome = Column(Text, primary_key=True)
    trilha_descricao = Column(Text)


t_cur_tril = Table(
    'cur_tril', metadata,
    Column('cur_tril_curriculo_sigla', ForeignKey('curriculo.curriculo_sigla', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    Column('cur_tril_trilha_nome', ForeignKey('trilha.trilha_nome', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
)


t_disciplina_requisitos = Table(
    'disciplina_requisitos', metadata,
    Column('disc_reqs_disciplina_sigla', ForeignKey('disciplina.disciplina_sigla', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    Column('disc_reqs_disciplina_requisito', ForeignKey('disciplina.disciplina_sigla', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
)


class Modulo(Base):
    __tablename__ = 'modulo'

    modulo_nome = Column(Text, primary_key=True)
    modulo_descricao = Column(Text)
    modulo_trilha_nome = Column(ForeignKey('trilha.trilha_nome', onupdate='CASCADE'))

    trilha = relationship('Trilha')


class TrilhaExtrareq(Base):
    __tablename__ = 'trilha_extrareqs'

    tril_extrareqs_trilha_nome = Column(ForeignKey('trilha.trilha_nome', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
    tril_extrareqs_requisito = Column(Text, primary_key=True, nullable=False)
    tril_extrareqs_id = Column(Integer, nullable=False, server_default=text("nextval('trilha_extrareqs_tril_extrareqs_id_seq'::regclass)"))

    trilha = relationship('Trilha')


t_dis_mod = Table(
    'dis_mod', metadata,
    Column('disc_mod_disciplina_sigla', ForeignKey('disciplina.disciplina_sigla', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    Column('disc_mod_modulo_nome', ForeignKey('modulo.modulo_nome', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False)
)

#DB inter_mod_ace_pes
class PeU(Base):
    __tablename__ = 'pe_us'

    pe_us_nusp = Column(Integer, primary_key=True, nullable=False, unique=True, server_default=text("nextval('pe_us_pe_us_nusp_seq'::regclass)"))
    pe_us_user_login = Column(Text, primary_key=True, nullable=False, unique=True)

#DB inter_mod_pes_cur
class Administra(Base):
    __tablename__ = 'administra'

    administra_nusp = Column(Integer, primary_key=True, nullable=False)
    administra_curriculo_sigla = Column(Text, primary_key=True, nullable=False)
    administra_inicio = Column(Date)


class Ministra(Base):
    __tablename__ = 'ministra'

    ministra_prof_nusp = Column(Integer, primary_key=True, nullable=False)
    ministra_disciplina_sigla = Column(Text, primary_key=True, nullable=False)


class Planeja(Base):
    __tablename__ = 'planeja'

    planeja_aluno_nusp = Column(Integer, primary_key=True, nullable=False)
    planeja_disciplina_sigla = Column(Text, primary_key=True, nullable=False)
