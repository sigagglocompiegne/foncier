/*Amt_Fon_Eco V1.0*/
/*Creation des vues applicatives stockées dans le schéma x_apps */
/* afe_21_vues_xapps.sql */
/*PostGIS*/

/* Propriétaire : GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet */



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                              VUES APPLICATIVES                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ########################################################### SCHEMA x_apps ################################################################

-- ##################################################### xapps_geo_v_ces_acqu_n #####################################################################


CREATE OR REPLACE VIEW x_apps.xapps_geo_v_ces_acqu_n
 AS
 WITH req_tot AS (
         SELECT a.idgeoaf AS id,
            'acquisition'::text AS typ,
            a.lib_proprio AS vendeur,
            o.orga_lib AS acheteur,
            to_char(a.d_acte, 'DD-MM-YYYY'::text) AS d_acte,
            a.geom
           FROM m_foncier.geo_fon_acqui a,
            m_foncier.lt_ces_orga o
          WHERE a.d_acte >= (((( SELECT max("right"(tables.table_name::text, 4)::integer) AS max
                   FROM information_schema.tables
                  WHERE tables.table_schema::text = 'm_foncier'::text AND tables.table_name::text ~~ 'geo_fon_parcelle_proprio_%'::text)) || '-01-01'::text)::timestamp without time zone) AND a.d_acte <= now() AND a.d_acte IS NOT NULL AND a.l_orga::text = o.l_orga::text AND (a.l_orga::text = ANY (ARRAY['10'::character varying::text, '24'::character varying::text]))
        UNION ALL
         SELECT c.idces::integer AS id,
            'cession'::text AS typ,
            g.orga_lib AS vendeur,
            c.l_acque AS acheteur,
            to_char(c.d_acte::timestamp with time zone, 'DD-MM-YYYY'::text) AS d_acte,
            o.geom
           FROM m_foncier.an_cession c,
            m_foncier.lk_cession_lot lc,
            r_objet.geo_objet_fon_lot o,
            m_foncier.lt_ces_orga g
          WHERE c.idces::text = lc.idces::text AND lc.idgeolf = o.idgeolf AND c.l_orga::text = g.l_orga::text AND c.d_acte >= (((( SELECT max("right"(tables.table_name::text, 4)::integer) AS max
                   FROM information_schema.tables
                  WHERE tables.table_schema::text = 'm_foncier'::text AND tables.table_name::text ~~ 'geo_fon_parcelle_proprio_%'::text)) || '-01-01'::text)::timestamp without time zone) AND c.d_acte <= now() AND c.d_acte IS NOT NULL AND NOT (c.idces::integer IN ( SELECT c_1.idces::integer AS idces
                   FROM m_foncier.an_cession c_1,
                    m_foncier.lk_cession_lot lc_1,
                    r_objet.geo_objet_fon_lot o_1,
                    m_foncier.lt_ces_orga g_1
                  WHERE c_1.idces::text = lc_1.idces::text AND lc_1.idgeolf = o_1.idgeolf AND c_1.l_orga::text = g_1.l_orga::text AND date_part('day'::text, now() - c_1.d_acte::timestamp with time zone) <= 730::double precision AND c_1.d_acte IS NOT NULL AND (c_1.l_acque::text = ANY (ARRAY['ARC'::character varying::text, 'Commune de Compiègne'::character varying::text, 'Compiègne'::character varying::text, 'Ville de Compiègne'::character varying::text, 'commune de compiegne'::character varying::text, 'commune de Compiègne'::character varying::text]))))
        )
 SELECT row_number() OVER () AS gid,
    req_tot.id,
    req_tot.typ,
    req_tot.vendeur,
    req_tot.acheteur,
    req_tot.d_acte,
    req_tot.geom
   FROM req_tot;

COMMENT ON VIEW x_apps.xapps_geo_v_ces_acqu_n
    IS 'Vue applicative affichant les cessions et les acquisitions de l''ARC et de la ville de Compiègne (par rapport à la date de l''acte notarié) entre maintenant et le 1er janvier du millésime du dernier cadastre en base';

-- ##################################################### xapps_geo_v_ces_acqu_n1 #####################################################################

CREATE OR REPLACE VIEW x_apps.xapps_geo_v_ces_acqu_n1
 AS
 WITH req_tot AS (
         SELECT a.idgeoaf AS id,
            'acquisition'::text AS typ,
            a.lib_proprio AS vendeur,
            o.orga_lib AS acheteur,
            to_char(a.d_acte, 'DD-MM-YYYY'::text) AS d_acte,
            a.geom
           FROM m_foncier.geo_fon_acqui a,
            m_foncier.lt_ces_orga o
          WHERE date_part('day'::text, now() - a.d_acte::timestamp with time zone) <= 730::double precision AND a.d_acte IS NOT NULL AND a.l_orga::text = o.l_orga::text AND (a.l_orga::text = ANY (ARRAY['10'::character varying::text, '24'::character varying::text]))
        UNION ALL
         SELECT c.idces::integer AS id,
            'cession'::text AS typ,
            g.orga_lib AS vendeur,
            c.l_acque AS acheteur,
            to_char(c.d_acte::timestamp with time zone, 'DD-MM-YYYY'::text) AS d_acte,
            o.geom
           FROM m_foncier.an_cession c,
            m_foncier.lk_cession_lot lc,
            r_objet.geo_objet_fon_lot o,
            m_foncier.lt_ces_orga g
          WHERE c.idces::text = lc.idces::text AND lc.idgeolf = o.idgeolf AND c.l_orga::text = g.l_orga::text AND date_part('day'::text, now() - c.d_acte::timestamp with time zone) <= 730::double precision AND c.d_acte IS NOT NULL AND NOT (c.idces::integer IN ( SELECT c_1.idces::integer AS idces
                   FROM m_foncier.an_cession c_1,
                    m_foncier.lk_cession_lot lc_1,
                    r_objet.geo_objet_fon_lot o_1,
                    m_foncier.lt_ces_orga g_1
                  WHERE c_1.idces::text = lc_1.idces::text AND lc_1.idgeolf = o_1.idgeolf AND c_1.l_orga::text = g_1.l_orga::text AND date_part('day'::text, now() - c_1.d_acte::timestamp with time zone) <= 730::double precision AND c_1.d_acte IS NOT NULL AND (c_1.l_acque::text = ANY (ARRAY['ARC'::character varying::text, 'Commune de Compiègne'::character varying::text, 'Compiègne'::character varying::text, 'Ville de Compiègne'::character varying::text, 'commune de compiegne'::character varying::text, 'commune de Compiègne'::character varying::text]))))
        )
 SELECT row_number() OVER () AS gid,
    req_tot.id,
    req_tot.typ,
    req_tot.vendeur,
    req_tot.acheteur,
    req_tot.d_acte,
    req_tot.geom
   FROM req_tot;

COMMENT ON VIEW x_apps.xapps_geo_v_ces_acqu_n1
    IS 'Vue applicative affichant les cessions et les acquisitions de l''ARC et de la ville de Compiègne entre maintenant et la date l''acte notarié qui doit être inférieur à 2 ans (n+n-1)';

