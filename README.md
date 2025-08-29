# EDS-214 Project

## Author:

Hylaea Miller

## 1 - Project goal

Recreate figure 3 - Hurricane effects on stream chemistry, from the article *"Effects of hurricane disturbance on stream water concentrations and fluxes in eight tropical forest watersheds of the Luquillo Experimental Forest"*.

## Methodology

The data imported from the Environmental Data Initiative [(McDowell and International Institute Of Tropical Forestry (IITF) 2024)](<https://portal.edirepository.org/nis/mapbrowse?packageid=knb-lter-luq.20.492306> were arranged for the creation of the figure. A 9-week moving average was calculated for the concentration of the following nutrients: (a) potassium, (b) nitrate-N, (c) magnesium, (d) calcium, and (e) ammonia-N. The graphs were created with ggplot2, and the results were compared with the original figure.

### Workflow

![](images/Data.png){width="552"}

## Project content

The **Project** directory contains:

-   **R:** R scripts for processing data and performing the analysis and supporting code

-   **data**: Raw data

-   **docs**: Quarto doc

-   **figures**: Plot of the Concentrations in Bisley, Puerto Rico streams before and after Hurricane Hug

## Acknowledgements

Schaefer DouglasA, McDowell WH, Scatena FN, Asbury CE. Effects of hurricane disturbance on stream water concentrations and fluxes in eight tropical forest watersheds of the Luquillo Experimental Forest, Puerto Rico. *Journal of Tropical Ecology*. 2000;16(2):189-207. <doi:10.1017/S0266467400001358>
