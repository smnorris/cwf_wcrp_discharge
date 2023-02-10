#!/bin/bash
set -euxo pipefail

# Load discharge data
# Discharge data provided by Foundry Spatial under agreement with CWF - for CWF use only.

psql -c "CREATE SCHEMA IF NOT EXISTS foundry"

# load the shapes and tidy the rather precise discharge values
ogr2ogr \
  -f PostgreSQL PG:$DATABASE_URL \
  -lco OVERWRITE=YES \
  -t_srs EPSG:3005 \
  -lco SCHEMA=foundry \
  -lco GEOMETRY_NAME=geom \
  -nln cwf_mad_funds \
  -nlt PROMOTE_TO_MULTI \
  -sql "SELECT wfi as watershed_feature_id, round(mad_mm, 5) as mad_mm, round(up_area_m2, 2) as upstream_area_m2, round(mad_m3s, 5) as mad_m3s from cwf_mad_funds" \
  -dialect SQLITE \
  ~/Data/Foundry/cwf_mad_request/cwf_mad_funds.shp

ogr2ogr \
  -f PostgreSQL $DATABASE_URL \
  -lco OVERWRITE=YES \
  -t_srs EPSG:3005 \
  -lco SCHEMA=foundry \
  -lco GEOMETRY_NAME=geom \
  -nln cwf_mad_funds_lnic \
  -nlt PROMOTE_TO_MULTI \
  -sql "SELECT wfi as watershed_feature_id, round(mad_mm, 5) as mad_mm, round(up_area_m2, 2) as upstream_area_m2, round(mad_m3s, 5) as mad_m3s FROM funds_nicola_mad" \
  -dialect SQLITE \
  ~/Data/Foundry/cwf_mad_request_nicola/funds_nicola_mad.shp

# there is no need to have duplicate wsd shapes, create a simple MAD table
psql -c "DROP TABLE IF EXISTS foundry.fwa_watersheds_mad"
psql -c "CREATE TABLE foundry.fwa_watersheds_mad (watershed_feature_id integer primary key, upstream_area_m2 double precision, mad_mm double precision, mad_m3s double precision)"
psql -c "INSERT INTO foundry.fwa_watersheds_mad (watershed_feature_id, upstream_area_m2, mad_mm, mad_m3s) SELECT watershed_feature_id, upstream_area_m2, mad_mm, mad_m3s FROM foundry.cwf_mad_funds"
psql -c "INSERT INTO foundry.fwa_watersheds_mad (watershed_feature_id, upstream_area_m2, mad_mm, mad_m3s) SELECT watershed_feature_id, upstream_area_m2, mad_mm, mad_m3s FROM foundry.cwf_mad_funds_lnic"
psql -c "DROP TABLE foundry.cwf_mad_funds"
psql -c "DROP TABLE foundry.cwf_mad_funds_lnic"

# finally, create the discharge per stream table and load to bcfishpass.discharge
psql -f sql/discharge.sql