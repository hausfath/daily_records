import delimited "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/us tmax.csv", clear

rename value tmax
rename anomaly tmax_anom

sort date
tempfile data
save "`data'", replace

import delimited "/Users/hausfath/Desktop/us tmin.txt", delimiter(comma, collapse) clear

rename value tmin
rename anomaly tmin_anom

sort date
merge date using "`data'"
drop _merge

gen month = (date/100 - int(date/100))*100
gen year = int(date/100)

keep year month tmin tmax tmin_anom tmax_anom
sort year month
save "`data'", replace 

import excel "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/CONUS CMIP5 RCP26.xlsx", sheet("Sheet1") firstrow case(lower) clear

rename tmax  cmip5_tmax
rename tmin cmip5_tmin
gen year = int(date) 
gen month = round((date - year) * 12 + 1)
drop date
order year month
sort year month
merge year month using "`data'"


keep if month == 6 | month == 7 | month == 8

collapse (mean) tmin tmax tmin_anom tmax_anom cmip5_tmax cmip5_tmin, by(year)

tsset year

foreach series of varlist tmin tmax tmin_anom tmax_anom cmip5_tmax cmip5_tmin {
	su `series' if year >= 1951 & year <= 1980
	replace `series' = `series' - r(mean)
	replace `series' = `series' * 9/5.
	tssmooth ma `series'_ma  = `series', window(4,1,0)
	replace `series'_ma = . if `series' == .
}

drop if year < 1900

#delimit ;
twoway 
	(line tmin_anom_ma year if year < 2019, color(blue) lwidth(thin))
	(line tmax_anom_ma year if year < 2019, color(red) lwidth(thin)) 
    ,
    title("US Summer Maximum and Minimum Temps (5-yr avg)", size(medium))
    ytitle("Change from 1951-1980 (Degrees F)", size(small))
  	xtitle("", size(small))
  	ylabel(,labsize(small))
  	xlabel(,labsize(small))
  	ylabel(-3(1)4, gmax glcolor(black) glpattern(dot)) 
  	xlabel(1900(20)2020)
  	scheme(economist)
  	graphregion(color(white) lcolor(ebg))
  	legend(region(fcolor(gs15) lcolor(ebg)) size(vsmall)  label(1 "Minimum Temp")  label(2 "Maximum Temp") order(1 2) col(2))
    xsize(6)
	ysize(5.5)
	;
#delimit cr

graph export "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/conus summer tmin tmax F.png", replace width(1000)


#delimit ;
twoway 
	(line tmin_anom_ma year if year < 2020, color(blue) lwidth(thin))
    (line cmip5_tmin_ma year if year < 2020, color(blue) lwidth(thin) lpattern(shortdash))
	(line tmax_anom_ma year if year < 2020, color(red) lwidth(thin)) 
	(line cmip5_tmax_ma year if year < 2020, color(red) lwidth(thin) lpattern(shortdash))
    ,
    title("US Summer Maximum and Minimum Temperatures w/ CMIP5", size(medium))
    ytitle("Degrees C change from 1951-1980", size(small))
  	xtitle("", size(small))
  	ylabel(,labsize(small))
  	xlabel(,labsize(small))
  	ylabel(-1.5(0.5)2, gmax glcolor(black) glpattern(dot)) 
  	xlabel(1900(20)2020)
  	scheme(economist)
  	graphregion(color(white) lcolor(ebg))
  	legend(region(fcolor(gs15) lcolor(ebg)) size(vsmall)  label(1 "Minimum Temp")  label(3 "Maximum Temp") order(1 3) col(2))
    xsize(6)
	ysize(5.5)
	;
#delimit cr

graph export "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/conus summer tmin tmax CMIP5.png", replace width(1000)
