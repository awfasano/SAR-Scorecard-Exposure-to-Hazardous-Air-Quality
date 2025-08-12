
global data  "C:\Users\vgald\OneDrive\Desktop\SAR_DATA\3. Output"
global out   "C:\Users\vgald\OneDrive\Desktop\SAR_DATA\4. Indicators"




*******  PM25 


forvalues i = 2010(1)2022 {
import delimited "$data\PM25\pm25_exposure_by_admin2_aggregated_`i'.csv", case(preserve) clear
tempfile  L2_pm25_`i'
save  "`L2_pm25_`i''"
}


use  `L2_pm25_2010' ,clear
forvalues i = 2011(1)2022 {
append using  `L2_pm25_`i''
}

drop if  year==.
save "$data\PM25\pm25_by_admin2_aggregated.dta" , replace

collapse (sum)  total_pop  exposed_pop , by( L0_CODE L0_NAME L1_CODE L1_NAME  geo_level wb_status sovereign Disputed  year)
gen   percent_exposed= exposed_pop/total_pop*100
replace  geo_level=1
drop if  year==.
save "$data\PM25\pm25_by_admin1_aggregated.dta" , replace

collapse (sum)  total_pop  exposed_pop , by( L0_CODE L0_NAME   geo_level wb_status sovereign Disputed  year)
gen   percent_exposed= exposed_pop/total_pop*100
replace  geo_level=0
drop if  year==.
save "$data\PM25\pm25_by_admin0_aggregated.dta" , replace




use  "$data\PM25\pm25_by_admin2_aggregated.dta",  clear
drop  exposed_pop total_pop
gsort -Disputed  L0_NAME  L1_NAME  L2_NAME year
drop   wb_status
gen  variable="percent_exposed"
gen var_label = "PM2.5 air pollution, population exposed to levels exceeding WHO guideline value (% of total)"
rename  percent_exposed   value 
order   geo_level year sovereign Disputed L0_CODE L0_NAME  L1_CODE L1_NAME  L2_CODE L2_NAME variable var_label value
tempfile  pm25_2
save  "`pm25_2'"


use  "$data\PM25\pm25_by_admin1_aggregated.dta",  clear
drop  exposed_pop total_pop
gsort -Disputed  L0_NAME  L1_NAME   year
drop   wb_status
gen  variable="percent_exposed"
gen var_label = "PM2.5 air pollution, population exposed to levels exceeding WHO guideline value (% of total)"
rename  percent_exposed   value 
order   geo_level year sovereign Disputed L0_CODE L0_NAME  L1_CODE L1_NAME  variable var_label value
tempfile  pm25_1
save  "`pm25_1'"


use  "$data\PM25\pm25_by_admin0_aggregated.dta",  clear
drop  exposed_pop total_pop
gsort -Disputed  L0_NAME     year
drop   wb_status
gen  variable="percent_exposed"
gen var_label = "PM2.5 air pollution, population exposed to levels exceeding WHO guideline value (% of total)"
rename  percent_exposed   value 
order   geo_level year sovereign Disputed L0_CODE L0_NAME     variable var_label value
tempfile  pm25_0
save  "`pm25_0'"


use  `pm25_0'  , clear
append using  `pm25_1'
append using  `pm25_2'

order  geo_level year  sovereign Disputed L0_CODE L0_NAME L1_CODE L1_NAME L2_CODE L2_NAME variable var_label value

export delimited using "$out\PM25_spatial_Indicators_Levels_0_1_2.csv", replace







