# CWF WCRP Discharge

Mean annual discharge pre-processing for CWF Watershed Connectivity Restoration Plans.

For Bulkley River, Elk River and Horsefly watersheds, high resoloution discharge data was provided by Foundry Spatial for CWF use only.
Lower Nicola discharge was also provided (separately), but this data is from PCIC with no further processing by Foundry.

These scripts:
- load the data to a `foundry` schema in postgres db 
- link the watershed based discharge values to streams
- load the result to `whse_basemapping.fwa_stream_networks_discharge` in place of any existing values

## Requirements

See `fwapg`

## Usage

Edit the discharge script to point to the provided shapefiles. 
Run the script to load provided Foundry discharge to FWA discharge table:

    ./discharge.sh

