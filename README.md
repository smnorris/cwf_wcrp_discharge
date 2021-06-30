# WCRP Discharge

Mean annual discharge pre-processing for CWF Watershed Connectivity Restoration Plans.

For Bulkley River, Elk River and Horsefly watersheds, high resoloution discharge data was provided by Foundry Spatial for CWF use only.
Lower Nicola discharge was also provided (separately), but this data is from PCIC with no further processing by Foundry.

These scripts load the data to a `foundry` schema in postgres db and links the watershed based discharge values to streams.
To use the output in `bcfishpass` habitat modelling, copy the output table to the table `bcfishpass.discharge`, replacing the default discharge table.

## Requirements

See `bcfishpass`

## Usage

Edit the discharge script to point to the provided shapefiles. Run the script:

    ./discharge.sh

## Output table

                           Table "foundry.fwa_streams_mad"
            Column        |         Type         | Collation | Nullable | Default
    ----------------------+----------------------+-----------+----------+---------
     linear_feature_id    | bigint               |           | not null |
     watershed_group_code | character varying(4) |           |          |
     mad_m3s              | double precision     |           |          |
    Indexes:
        "fwa_streams_mad_pkey" PRIMARY KEY, btree (linear_feature_id)

