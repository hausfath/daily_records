import delimited "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/global_max.csv", clear

rename records max
drop v1
sort year
tempfile data
save "`data'", replace

import delimited "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/global_min.csv", clear
rename records min
drop v1
sort year

merge year using "`data'"
drop _merge

replace min = min * -1


/*
#delimit ;
twoway (bar max year, color(red) lwidth(thin)) 
	   (bar min year, lwidth(thin) color(blue))
	   (line max_low year, color(maroon) lwidth(thin))
	   (line min_low year, color(navy) lwidth(thin)) 
       ,
  title("CONUS daily minimum and maximum records per year", size(large))
  ytitle("Records per year", size(medlarge))
  caption("Based on Berkeley Earth CONUS gridded daily homogenized data using 272 equal area gridcells", size(small))
  xtitle("", size(vsmall))
  ylabel(-1000 "1000" -500 "500" 0 "0" 500 "500" 1000 "1000", labsize(medium) gmax glcolor(black) glpattern(dot))
  xlabel(1880(20)2020, labsize(medium))
  graphregion(color(white) lcolor(ebg))
  xsize(9)
  ysize(5)
  legend(position(6) region(fcolor(gs15) lcolor(ebg)) size(medsmall) label(1 "Daily Max Records") label(2 "Daily Min Records") order(1 2) col(2))
  ;
#delimit cr

graph export "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/CONUS daily records.png", replace width(3000)

gen ratio = max / (min*-1)

#delimit ;
twoway (bar ratio year, color(black) lwidth(thin))  
       ,
  title("Ratio of record highs to record lows", size(large))
  ytitle("Annual ratio", size(medlarge))
  caption("Based on Berkeley Earth CONUS gridded daily homogenized data using 272 equal area gridcells", size(small))
  xtitle("", size(vsmall))
  ylabel(, labsize(medium) gmax glcolor(black) glpattern(dot))
  xlabel(1880(20)2020, labsize(medium))
  graphregion(color(white) lcolor(ebg))
  xsize(9)
  ysize(5)
  legend(off)
  ;
#delimit cr

graph export "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/CONUS records ratio.png", replace width(3000)
*/

gen decade = int(year/10)
collapse (sum) min max, by(decade)
replace decade = decade * 10 + 5
drop if decade == 2025

#delimit ;
twoway (bar max decade, color(red) lwidth(thin) barwidth(7))
	   (bar min decade, color(blue) lwidth(thin) barwidth(7)) 
       ,
  title("Global land daily maximum and minimum records per decade", size(large))
  ytitle("Records per decade", size(medlarge))
  caption("Based on Berkeley Earth gridded daily homogenized land data using 5498 equal area gridcells", size(small))
  xtitle("", size(vsmall))
  ylabel(-400000 "400k" -200000 "200k" 0 "0" 200000 "200k" 400000 "400k", labsize(medium) gmax glcolor(black) glpattern(dot))
  xlabel(1880(20)2020, labsize(medium))
  graphregion(color(white) lcolor(ebg))
  xsize(9)
  ysize(5)
  legend(position(6) region(fcolor(gs15) lcolor(ebg)) size(medsmall) label(1 "Daily Max Records") label(2 "Daily Min Records") order(1 2) col(2))
  ;
#delimit cr

graph export "/Users/hausfath/Desktop/Climate Science/GHCN Monthly/global daily records decade.png", replace width(3000)
