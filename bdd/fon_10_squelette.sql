/*Amt_Fon_Eco V1.0*/
/*Creation du squelette de la structure des données (table, séquence, trigger,...) */
/* afe_10_squelette.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                SCHEMA                                                                        ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- sont intégrer également ici les schémas dépendant. Il ne faut les supprimer si d'autress informatiosn y sont aossicées.

-- DROP SCHEMA IF EXISTS m_foncier;

/*
CREATE SCHEMA m_foncier
    AUTHORIZATION create_sig;

COMMENT ON SCHEMA m_foncier
    IS 'Données géographiques métiers sur le thème du foncier';

*/

-- séquences :
--------------

-- DROP SEQUENCE IF EXISTS m_foncier.ces_seq;
-- DROP SEQUENCE IF EXISTS m_foncier.an_fon_acqui_proprio_gid_seq;

-- liste de valeurs :
---------------------

-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_cond;
-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_nota;
-- DROP TABLE IF EXISTS m_activite_eco.lt_src_geom;
-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_tact;
-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_etat;
-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_orga;
-- DROP TABLE IF EXISTS m_activite_eco.lt_ces_voca;


-- tables :
-----------

-- DROP TABLE IF EXISTS m_foncier.geo_fon_acqui;
-- DROP TABLE IF EXISTS m_foncier.an_fon_acqui_proprio;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                SEQUENCE                                                                      ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ##########################################################################################################
-- ################################################# SCHEMA M_FONCIER ##################################
-- ##########################################################################################################

-- ################################################# ces_seq ##################################
-- ################################################# Séquence des identifiants des acquisitions et des cessions ##################################

CREATE SEQUENCE m_foncier.ces_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ################################################# an_fon_acqui_proprio_gid_seq ##################################
-- ################################################# Séquence des identifiants des médias joints aux dossiers d'acquisition ##################################

CREATE SEQUENCE m_foncier.an_fon_acqui_proprio_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     FONCTIONS                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ##########################################################################################################
-- ################################################# SCHEMA PUBLIC ##################################
-- ##########################################################################################################

-- Les fonctions utilisées ici sont tous le schéma public et partagées. Elles ne sont donc pas spésifiques à cette thématique.

-- ################################################# ft_m_acqui_proprio_idmedia ##################################

CREATE OR REPLACE FUNCTION m_foncier.ft_m_acqui_proprio_idmedia()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN

NEW.idmedia := NEW.idgeoaf || '_' || NEW.gid;
   
    return new;
END;

$BODY$;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ##########################################################################################################
-- ################################################# SCHEMA M_FONCIER ##################################
-- ##########################################################################################################

-- Les domaines de valeurs sont partagés avec les cessions foncières et sont présents dans le répertoire acti_eco.

-- Domaine de valeurs partagé :

-- m_activite_eco.lt_ces_cond;
-- m_activite_eco.lt_ces_nota;
-- m_activite_eco.lt_src_geom;
-- m_activite_eco.lt_ces_tact;
-- m_activite_eco.lt_ces_etat;
-- m_activite_eco.lt_ces_orga;
-- m_activite_eco.lt_ces_voca;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                TABLE                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ##########################################################################################################
-- ################################################# SCHEMA M_FONCIER ##################################
-- ##########################################################################################################


-- ################################################# Classe des objets d'acquisiton : geo_fon_acqui ##################################


CREATE TABLE m_foncier.geo_fon_acqui
(
    idgeoaf integer NOT NULL DEFAULT nextval('m_foncier.ces_seq'::regclass),
    idacq character varying(10) COLLATE pg_catalog."default",
    l_etat character varying(2) COLLATE pg_catalog."default",
    l_orga character varying(2) COLLATE pg_catalog."default",
    d_delib1 timestamp without time zone,
    d_delib2 timestamp without time zone,
    d_delib3 timestamp without time zone,
    insee character varying(20) COLLATE pg_catalog."default",
    d_int timestamp without time zone,
    l_voca character varying(2) COLLATE pg_catalog."default",
    lib_proprio character varying(100) COLLATE pg_catalog."default",
    lib_par_i character varying(254) COLLATE pg_catalog."default",
    lib_par_f character varying(50) COLLATE pg_catalog."default",
    d_esti1 timestamp without time zone,
    d_esti2 timestamp without time zone,
    d_esti3 timestamp without time zone,
    m_esti double precision,
    lib_surf integer,
    l_condi character varying(2) COLLATE pg_catalog."default",
    l_type character varying(2) COLLATE pg_catalog."default",
    d_prom timestamp without time zone,
    d_acte timestamp without time zone,
    l_notaire character varying(2) COLLATE pg_catalog."default",
    l_notaire_a character varying(50) COLLATE pg_catalog."default",
    m_acquiht double precision,
    m_acquittc double precision,
    l_mfrais double precision,
    l_mfrais_g_ttc double precision,
    l_mfrais_n_ttc double precision,
    l_mfrais_a_ttc double precision,
    l_macqui_s double precision,
    l_type_a boolean,
    l_type_b boolean,
    l_type_c boolean,
    date_maj timestamp without time zone,
    geom geometry(MultiPolygon,2154),
    commune character varying(100) COLLATE pg_catalog."default",
    l_observ character varying(255) COLLATE pg_catalog."default",
    src_geom character varying COLLATE pg_catalog."default" DEFAULT '20'::character varying,
    idsite character varying(10) COLLATE pg_catalog."default",
    l_acopro boolean NOT NULL DEFAULT false,
    op_sai character varying(80) COLLATE pg_catalog."default",
    date_sai timestamp without time zone,
    CONSTRAINT geo_fon_acqui_pkey PRIMARY KEY (idgeoaf),
    CONSTRAINT geo_fon_acqui_condi_fkey FOREIGN KEY (l_condi)
        REFERENCES m_foncier.lt_ces_cond (l_condi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acqui_notaire_fkey FOREIGN KEY (l_notaire)
        REFERENCES m_foncier.lt_ces_nota (l_notaire) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acqui_srcgeom_fkey FOREIGN KEY (src_geom)
        REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acqui_type_fkey FOREIGN KEY (l_type)
        REFERENCES m_foncier.lt_ces_tact (l_type) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acquis_etat_fkey FOREIGN KEY (l_etat)
        REFERENCES m_foncier.lt_ces_etat (l_etat) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acquis_orga_fkey FOREIGN KEY (l_orga)
        REFERENCES m_foncier.lt_ces_orga (l_orga) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT geo_fon_acquis_voca_fkey FOREIGN KEY (l_voca)
        REFERENCES m_foncier.lt_ces_voca (l_voca) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

COMMENT ON TABLE m_foncier.geo_fon_acqui
    IS 'Table contenant les données sur les acquisitons foncières réalisées par l''ARC et la ville de Compiègne';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.idgeoaf
    IS 'Identifiant unique de l''objet';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.idacq
    IS 'Identifiant du dossier (issu de DynMap)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_etat
    IS 'Code de l''état de l''acquisition du foncier';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_orga
    IS 'Code de l''organisme acquéreur';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_delib1
    IS 'Date de la délibération (1)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_delib2
    IS 'Date de la délibération (2)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_delib3
    IS 'Date de la délibération (3)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.insee
    IS 'Code Insee de la commune';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_int
    IS 'Date d''ouverture du dossier';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_voca
    IS 'Code de la vocation de l''acquisition';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.lib_proprio
    IS 'Libellé du propriétaire initial';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.lib_par_i
    IS 'Identifiant des parcelles initiales';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.lib_par_f
    IS 'Identifiant des parcelles finales';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_esti1
    IS 'Date d''estimation(1)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_esti2
    IS 'Date d''estimation(2)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_esti3
    IS 'Date d''estimation(3)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.m_esti
    IS 'Montant de l''estimation en € HT';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.lib_surf
    IS 'Surface cadastrée en m²';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_condi
    IS 'Code de la condition de cession';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_type
    IS 'Code du type d''acte';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_prom
    IS 'Date de la promesse de vente';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.d_acte
    IS 'Date de l''acte de vente';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_notaire
    IS 'Code du Nom du notaire';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_notaire_a
    IS 'Autre(s) notaire(s)';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.m_acquiht
    IS 'Montant de l''acquisition en € HT';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.m_acquittc
    IS 'Montant de l''acquisition en € TTC';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_mfrais
    IS 'Montant des frais global';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_mfrais_g_ttc
    IS 'Montant des frais de géomètre TTC';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_mfrais_n_ttc
    IS 'Montant des frais de notaire TTC';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_mfrais_a_ttc
    IS 'Montant des frais autres (agences, divers, ...) TTC';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_macqui_s
    IS 'Montant de l''acquisition en € HT par m²';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_type_a
    IS 'Type de montant : terrain';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_type_b
    IS 'Type de montant : bâti';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_type_c
    IS 'Type de montant : surface de plancher';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.date_maj
    IS 'Date de mise à jour des données';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_observ
    IS 'Observations diverses';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.src_geom
    IS 'Référentiel spatial utilisé pour la saisie';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.idsite
    IS 'Identifiant unique du site';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.l_acopro
    IS 'Attribut permettant de distinguer si l''acquisition concerne 1 propriété unique ou une copropriété avec n procédures d''acquisition (1 par propriétaire). Dans ce dernier cas, la table an_fon_acqui_proprio peut-être alimenté par le nombre de propriétaire en question';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.op_sai
    IS 'Opérateur de saisie';

COMMENT ON COLUMN m_foncier.geo_fon_acqui.date_sai
    IS 'Date de saisie';
    
-- Index: geo_fon_acqui_geom_idx
-- DROP INDEX m_foncier.geo_fon_acqui_geom_idx;

CREATE INDEX geo_fon_acqui_geom_idx
    ON m_foncier.geo_fon_acqui USING gist
    (geom)
    TABLESPACE pg_default;
    
-- Index: idx_geo_fon_acqui_idacq
-- DROP INDEX m_foncier.idx_geo_fon_acqui_idacq;

CREATE INDEX idx_geo_fon_acqui_idacq
    ON m_foncier.geo_fon_acqui USING btree
    (idacq COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
    
-- Index: idx_geo_fon_acqui_l_etat
-- DROP INDEX m_foncier.idx_geo_fon_acqui_l_etat;

CREATE INDEX idx_geo_fon_acqui_l_etat
    ON m_foncier.geo_fon_acqui USING btree
    (l_etat COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: t_t0_secu_geom_epci
-- DROP TRIGGER t_t0_secu_geom_epci ON m_foncier.geo_fon_acqui;

CREATE TRIGGER t_t0_secu_geom_epci
    BEFORE INSERT OR UPDATE OF geom
    ON m_foncier.geo_fon_acqui
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_m_secu_geom_sb_epci();

-- Trigger: t_t1_idsite
-- DROP TRIGGER t_t1_idsite ON m_foncier.geo_fon_acqui;

CREATE TRIGGER t_t1_idsite
    BEFORE INSERT OR UPDATE 
    ON m_foncier.geo_fon_acqui
    FOR EACH ROW
    EXECUTE PROCEDURE m_foncier.ft_m_ces_acq_idsite();

ALTER TABLE m_foncier.geo_fon_acqui
    DISABLE TRIGGER t_t1_idsite;

-- Trigger: t_t2_insee
-- DROP TRIGGER t_t2_insee ON m_foncier.geo_fon_acqui;

CREATE TRIGGER t_t2_insee
    BEFORE INSERT OR UPDATE 
    ON m_foncier.geo_fon_acqui
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_commune_pl();

-- Trigger: t_t3_insert_date_sai
-- DROP TRIGGER t_t3_insert_date_sai ON m_foncier.geo_fon_acqui;

CREATE TRIGGER t_t3_insert_date_sai
    BEFORE INSERT
    ON m_foncier.geo_fon_acqui
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_sai();

-- Trigger: t_t4_insert_date_maj
-- DROP TRIGGER t_t4_insert_date_maj ON m_foncier.geo_fon_acqui;

CREATE TRIGGER t_t4_insert_date_maj
    BEFORE INSERT OR UPDATE 
    ON m_foncier.geo_fon_acqui
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_maj();

-- ################################################# Classe des objets des médias associés : an_fon_acqui_proprio ##################################


CREATE TABLE m_foncier.an_fon_acqui_proprio
(
    gid integer NOT NULL DEFAULT nextval('m_foncier.an_fon_acqui_proprio_gid_seq'::regclass),
    idgeoaf integer NOT NULL,
    l_proprio character varying(254) COLLATE pg_catalog."default",
    l_etat character varying(2) COLLATE pg_catalog."default" DEFAULT 0,
    idmedia character varying COLLATE pg_catalog."default",
    l_lot character varying(20) COLLATE pg_catalog."default",
    date_sai timestamp without time zone,
    date_maj timestamp without time zone,
    CONSTRAINT an_fon_acqui_proprio_pkey PRIMARY KEY (gid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

COMMENT ON TABLE m_foncier.an_fon_acqui_proprio
    IS 'Table alphanumérique listant les caractéristiques des acquisitions lors d''une acquisition foncière en copropriété. Cette table est liée à la table geo_fon_acqui.';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.gid
    IS 'Identifiant unique (clé interne)';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.idgeoaf
    IS 'Identifiant de l''acquisition foncière';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.l_proprio
    IS 'Libellé du propriétaire';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.l_etat
    IS 'Etat du dossier (liste de valeur état du dossier des acquisitions)';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.idmedia
    IS 'Identifiant pour les médias (pour utiliser la même table que les acquisitions et les cessions mais pas récupérer les mêmes médias pour chaque propriétaire) constitué du N° de l''acquisition et du gis';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.l_lot
    IS 'Numéro du lot de copropriétés concernés';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.date_sai
    IS 'Date de saisie de la donnée dans la base';

COMMENT ON COLUMN m_foncier.an_fon_acqui_proprio.date_maj
    IS 'Date de mise à jour de la donnée dans la base';
    
-- Index: idx_an_fon_acqui_proprio_idacq
-- DROP INDEX m_foncier.idx_an_fon_acqui_proprio_idacq;

CREATE INDEX idx_an_fon_acqui_proprio_idacq
    ON m_foncier.an_fon_acqui_proprio USING btree
    (idgeoaf ASC NULLS LAST)
    TABLESPACE pg_default;
    
-- Index: idx_an_fon_acqui_proprio_idmedia
-- DROP INDEX m_foncier.idx_an_fon_acqui_proprio_idmedia;

CREATE INDEX idx_an_fon_acqui_proprio_idmedia
    ON m_foncier.an_fon_acqui_proprio USING btree
    (idmedia COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

-- Trigger: t_t1_m_acqui_proprio_idmedia
-- DROP TRIGGER t_t1_m_acqui_proprio_idmedia ON m_foncier.an_fon_acqui_proprio;

CREATE TRIGGER t_t1_m_acqui_proprio_idmedia
    BEFORE INSERT
    ON m_foncier.an_fon_acqui_proprio
    FOR EACH ROW
    EXECUTE PROCEDURE m_foncier.ft_m_acqui_proprio_idmedia();

-- Trigger: t_t2_insert_date_maj
-- DROP TRIGGER t_t2_insert_date_maj ON m_foncier.an_fon_acqui_proprio;

CREATE TRIGGER t_t2_insert_date_maj
    BEFORE INSERT OR UPDATE 
    ON m_foncier.an_fon_acqui_proprio
    FOR EACH ROW
    EXECUTE PROCEDURE public.ft_r_timestamp_maj();
