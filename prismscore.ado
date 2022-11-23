/*----------------------------------------------------------------------------*\
| PRISM Score Calculator - a statistical package designed to calculate         |
| 	PRISM III & IV scores.													   |
|																			   |
|	For help, please see help prismscore. 									   |
|																			   |
|	Version: 1.0 | Created: Jul 28, 2022 | Last Updated: Nov 2, 2022		   | 
|	Author: Razvan Azamfirei - stata@azamfirei.com							   |
|																			   |
|	     																	   |
\*----------------------------------------------------------------------------*/
	*! | Version: 1.0 | Last Updated: Nov 2, 2022 | 
cap program drop 	prismscore
	program 		prismscore
	preserve
		if (c(stata_version) < 17) {
			di as txt "note: this command is written " ///
			"and tested for Stata release 17.0 or higher"
			di as txt "it might not work properly with " ///
			"Stata version `c(stata_version)'"
			loc vers = c(stata_version)
		}
		else loc vers 17
    version `vers'
	
	novarabbrev {
	qui{	
********************************************************************************

	loc age dob doa
	tempvar I_ageIV calculated_age
	loc l_catvar3 sbp gcs hr pupils
	loc l_numvar3 temp  ph  bicarb  pco2 pao2 glucose potassium creatinine /*
	*/	bun wbc plt 
	loc l_numvar3opt templow phhigh bicarbhigh pt ptt
	loc l_catvar4 cpr cancer risk source
	loc l_scores sbp_score temperature_score hr_score acidosis_score /*
	*/	bicarb_score ph_score  pao2_score pco2_score glucose_score  /*
	*/	potassium_score creatinine_score bun_score wbc_score coag_score /*
	*/	platelet_score mentalstatus_score pupils_score
	loc l_scores4 age_score source_score
	loc l_allvars `l_catvar3' `l_numvar3' `l_numvar3opt' `l_catvar4'
	loc l_options prismivoption traceoption sioption /*
	*/	suppressoption noimputationoption plateletoption tempoption /*
	*/	validationoption
	loc l_results neuroscore nonneuroscore prismintermediate /*
	*/	prismfinal totalscore
	loc l_scalars intercept agecoef0 agecoef1 agecoef2 agecoef3 sourcecoef0 /*
	*/	sourcecoef1 sourcecoef2 sourcecoef3 cprcoef cancercoef riskcoef /*
	*/	neurocoef nonneurocoef ph0 ph1 ph2 ph3 bicarb0 bicarb1 bcarb2 pao20 /*
	*/	pao21 pco20 pco21 sbp0 sbp1 sbp2 sbp3 sbp4 sbp5 tmp0 tmp1 gcs0 /*
	*/	hr0 hr1 hr2 hr3 hr4 hr5 pt0 ptt0 ptt1 wbc0 glu0 cr0 cr1 cr2 /*
	*/	bun0 bun1 plt0 plt1 plt2 plt3 rc1 rc2 rc3 ag1 ag2 ag3 ag4 agecase/*
	*/	tmpoor0 tmpoor1 gluoor0 gluoor1 croor0 croor1 bunoor0 bunoor1
	loc helpme "See help prismscore for more details."
	
********************************************************************************	

	syntax newvarlist(min=1 max=4 generate) [if] [in], [Age(varname num)] /*
	*/	[dob(varname)] [doa(varname)] /*
	*/	Sbp(varname num)  temp(varname num) [TEMPLow(varname num)]/*
	*/	Gcs(varname num) Hr(varname num) PUPils(varname num)/*
	*/	ph(varname num) [PHHigh(varname num)] bicarb(varname num)/*
	*/	[BICARBHigh(varname num)] PCo2(varname num) /*
	*/	POTassium(varname num) PAo2(varname num) /*
	*/	GLUcose(varname num) CReatinine(varname num) /*
	*/	Bun(varname num) wbc(varname num) plt(varname num) /*
	*/	[pt(varname num)] [ptt(varname num)] /*
	***/	[PRISMiv] [cpr(varname num)] [CANcer(varname num)] /*
			*/	[Risk(varname num)] [SOUrce(varname num)]/*
	***/	[SI] [TRACE] [SUPPress] [SUPPRESSAll] [NOIMPutation] /*
	***/	[NOVALidation]/*
	***/	[PLTUnit(int 1)] [WBCUnit(int 1)] [FAHRenheit] 
	
		marksample touse, nov

********************************************************************************	
	
///	Get Option State
 
	tempname `l_options'
	tempvar `l_results'

	if "`trace'" != "" {
		set tr on
		sca traceoption = 1
	}
	else {
		sca traceoption = 0
	}
	if "`noimputation'" != "" {
		sca noimputationoption = 1
	}
	else {
		sca noimputationoption = 0
	}	
	if "`suppressall'" != ""{
		sca suppressoption = 2
	}
	if "`suppress'" != "" & "`suppressall'" == ""{
		sca suppressoption = 1
	}
	if "`suppress'" == "" & "`suppressall'" == ""{
		sca suppressoption = 0
	}	
	if "`novalidation'" == "" {
		sca validationoption = 1
	}
	else {
		sca validationoption = 0
	}
	if suppressoption == 2{
		sca validationoption = 0
	}
	if "`prismiv'" != "" {
		sca prismivoption = 1
	}
	else{
		sca prismivoption = 0
	} 
	if "`si'" != "" {
		sca sioption = 1
	}
	else {
		sca sioption = 0
	} 
	if "`fahrenheit'" != "" {
		sca tempoption = 1
	}
	else {
		sca tempoption = 0
	} 
	
*------------------------------------------------------------------------------*
*	Parses varlist - Counts total number of variables, assign each variable a  *
*	number corresponding to its position and then assigns final vars.          *
*	Rules: 																	   *
*		1. If calculating PRISM IV score you must have 1 newvar (becomes       * 
*		PRISM IV or 4 vars for the PRISM III scores + PRISM IV score.		   *
*																			   *
*		2. If calculating PRISM III scores you need to have 3 variables. 	   *
*------------------------------------------------------------------------------*
	
	loc i = 0 
	cap {
		foreach x in `varlist' {
			loc i = `i' + 1
			loc newvar_`i' `x'
		} 
	}
	if prismivoption == 1 {
		if `i' == 1{
			loc prismivvar `newvar_1' // Holds PRISM IV score 
		}
		if inlist(`i',2,3) {
			di as err "You must specify either 1 or 4 new" _continue
			di as err "variable names if you are trying to" _continue
			di as err " calculate the PRISM IV score. `helpme'"
			err 498
		}
		if `i' == 4 {
			loc neurovar `newvar_1'
			loc nonneurovar `newvar_2'
			loc totalvar `newvar_3'
			loc prismivvar `newvar_4'
		}
	}
	if prismivoption == 0 {
		if inlist(`i', 1, 2) {
			di as err "You must specify 3 newvarvarnames for" _continue
			di as err " PRISM III score calculations. `helpme'"
			err 498
		}
		if `i' == 4 {
			di as err "You have specified too many newvarnames" _continue
			di as err "or have forgotten to include , prismiv"
			err 498
		}
		if `i' == 3 {
			loc neurovar `newvar_1'
			loc nonneurovar `newvar_2'
			loc totalvar `newvar_3'
		}
	}
	

///	Defines Variables and Various Coefficients

/* 	All internal variables start with I_; otherwise STATA gets confused if foo *
*	is the dataset variable and there is a tempvar called `foo'.              */

	tempvar `l_scores' `l_scores4'
	foreach x in `l_allvars' { 		// Generates Temporary Names for all vars
		tempvar I_`x'
	}
	foreach x in `l_catvar3' {		// Generates PRISM III categorical vars
		gen `I_`x'' = ``x'' 
	}	

	foreach x in `l_numvar3opt' {	// Generates "optional" PRISM III num vars
		cap {
			gen `I_`x'' = ``x''
		}
	}
		
	foreach x in `l_numvar3' {		// Generates required PRISM III num vars
		gen `I_`x'' = ``x'' 
	}
	foreach x in `l_scores' {		// Generates placeholders for PRISM III
		gen ``x'' = 0 				// sub-scores
	}
	if prismivoption == 1 {			// If calculating PRISM IV
		foreach x in `l_catvar4' {	// Generates PRISM IV vars
			cap {
				gen `I_`x'' = ``x'' if `touse'
			}
			if _rc != 0 & suppressoption != 2 {
				di as err "`x' not specified. `helpme'"
				err 498
			}
		}
		if noimputationoption == 1 {	
			foreach x in `l_scores4' {
				gen ``x'' = . if `touse'
			}
		}
		if noimputationoption == 0 {
			foreach x in `l_scores4' {
				gen ``x'' = 0 if `touse'
			}
		}
	}
//	Sets coefficients and bounds

	tempname `l_scalars' 
	
		// PRISM IV coefficients - Change this
		sca intercept = -5.776
		sca agecoef0 = 1.311
		sca agecoef1 = 0.968
		sca agecoef2 = 0.357
		sca agecoef3 = 0
		sca sourcecoef0 = 0
		sca sourcecoef1 = 1.012
		sca sourcecoef2 = 1.626
		sca sourcecoef3 = 0.693
		sca cprcoef = 1.082
		sca cancercoef = 0.766
		sca riskcoef = -1.697
		sca neurocoef = 0.197
		sca nonneurocoef = 0.163
	
		// PRISM III vital bounds
		sca sbp0 = 40
		sca sbp1 = 45
		sca sbp2 = 55
		sca sbp3 = 65
		sca sbp4 = 75
		sca sbp5 = 85
		sca hr0 = 145
		sca hr1 = 155
		sca hr2 = 185
		sca hr3 = 205
		sca hr4 = 215
		sca hr5 = 225
		sca tmp0 = float(33.0)
		sca tmp1 = float(40.0)
		sca gcs0 = 8
		
		//	PRISM IV lab bounds - must be float or else comparison will not work
		//	close to the boundries because of how STATA stores numbers
		
		sca ph0 = float(7.0) 
		sca ph1 = float(7.28)
		sca ph2 = float(7.48)
		sca ph3 = float(7.55)
		sca bicarb0 = float(5)
		sca bicarb1 = float(16.9)
		sca bicarb2 = float(34.0)
		sca pao20 = float(42.0)
		sca pao21 = float(49.9)
		sca pco20 = float(50.0)
		sca pco21 = float(75)

		sca pot0 = float(6.9)		
		sca glu0 = float(200)
		sca cr0 = float(0.85)
		sca cr1 = float(0.9)
		sca cr2 = float(1.30)
		sca bun0 = float(11.9)
		sca bun1 = float(14.90)
		
		sca wbc0 = 3000
		sca pt0 = float(22.0)
		sca ptt0 = float(57.0)
		sca ptt1 = float(85.0)
		sca plt0 = 50000
		sca plt1 = 99999
		sca plt2 = 100000
		sca plt3 = 200000
		
		sca gluoor0 = float(5)
		sca gluoor1 = float(999)
		sca croor0 = float(0.01)
		sca croor1 = float(15)
		sca bunoor0 = float(1)
		sca bunoor1 = float(150)
		sca tmpoor0 = float(25.0)
		sca tmpoor1 = float(45.0)
		
// 	Replaces bounds for lab values in SI units and temperature in F. 

		// Rather than converting the underlying values, I'm just setting new
		// bounds; cleaner and less resource-intensive 
		
	if sioption == 1 {
		sca glu0 = float(11.0)
		sca cr0 = float(75)
		sca cr1 = float(80)
		sca cr2 = float(115)
		sca bun0 = float(4.3)
		sca bun1 = float(5.4)
		sca gluoor0 = float(0.2)
		sca gluoor1 = float(55.45)
		sca croor0 = float(0.8)
		sca croor1 = float(1350)
		sca bunoor0 = float(0.3)
		sca bunoor1 = float(53.6)
	}	
	
	if tempoption == 1 {
		sca tmp0 = float(91.4)
		sca tmp1 = float(104.0) 
		sca tmpoor0 = float(77.0)
		sca tmpoor1 = float(113.0)
	}
	
//	Changes bounds for WBC and Platelets based on units (cells vs 1000 cells)

		// Default option is all cell counts in cells. If K cells, sets
		// option to 1000 which is used further down
		
	sca plateletoption = 1
	sca wbcoption = 1
	if `pltunit' == 1000 {
		sca plateletoption = 1000
	}
	if `wbcunit' == 1000 {
		sca wbcoption = 1000
	}
	if `pltunit'!= 1 & `pltunit' != 1000 & `pltunit' != . {
		di as err "Platelet Unit incorrectly specified."
		err 498
	}
	if `wbcunit'!= 1 & `wbcunit' != 1000 & `wbcunit' != . {
		di as err "WBC Unit incorrectly specified."
		err 498
	}	 	
	forvalues x = 0(1)3 { // Uses plateletoption to set platelet bounds
		sca plt`x' = plt`x' / plateletoption
	}
	
	sca wbc0 = wbc0 / wbcoption // Uses WBC option to set wbc bounds

*------------------------------------------------------------------------------*	
* 	Protects against edge cases where foo_high < foo_low. First it fills in    * 
*	missing values from the paired variable (if foo_low != . & foo_high == .   *
*	foo_high = foo_low. Then it places foo_high and foo_low in tempvars and    *
*	replaces foo_high/foo_low with max/min of all values. 					   *
*																			   *
*	In simpler terms, for measurements that have both a high and a low variable*
*	only one has to be specified. If both are specified, even if the data is   *
*	entered incorrectly (e.g. high value in low variable) this will fix it.	   *
*------------------------------------------------------------------------------*
                   
if noimputationoption == 0 {	
	cap conf v `I_templow'
	if _rc != 0 {
		tempvar I_templow
		gen `I_templow' = `I_temp' if `touse'
	} 	
	else {
		tempvar thtmp tltmp
		replace `I_temp' = `I_templow' if `I_temp' == . & `touse'
		replace `I_templow' = `I_temp' if `I_templow' == . & `touse'
		gen `tltmp' = `I_templow' /*
		*/	if inrange(`I_temp', `I_templow', .) & `touse'
		gen `thtmp' = `I_temp' /*
		*/	if inrange(`I_templow', ., `I_temp') & `touse'
		replace `I_temp' = min(`I_temp', `tltmp', `thtmp') if `touse'
		replace `I_templow' = max(`I_templow', `tltmp', `thtmp') if `touse'
		drop `thtmp' `tltmp'
	}

	cap conf v `I_phhigh'
	if _rc != 0 {
		tempvar I_phhigh
		gen `I_phhigh' = `I_ph' if `touse'
	}
	else{
		tempvar phtmp pltmp
		replace `I_ph' = `I_phhigh' if `I_ph' == . & `touse'
		replace `I_phhigh' = `I_ph' if `I_phhigh' == . & `touse'
		gen `pltmp' = `I_phhigh' /*
		*/	if inrange(`I_ph', `I_phhigh', .) & `touse'
		gen `phtmp' = `I_ph' if inrange(`I_phhigh', ., `I_ph') & `touse'
		replace `I_ph' = min(`I_ph', `pltmp', `phtmp') if `touse'
		replace `I_phhigh' = max(`I_phhigh', `pltmp', `phtmp') if `touse'
		drop `phtmp' `pltmp'
	}
	cap conf v `I_bicarbhigh'
	if _rc != 0 {
		tempvar I_bicarbhigh
		gen `I_bicarbhigh' = `I_bicarb' if `touse'
	}
	if _rc == 0 {
		tempvar bhtmp bltmp
		replace `I_bicarb' = `I_bicarbhigh' if `I_bicarb' == . & `touse'
		replace `I_bicarbhigh' = `I_bicarb' if `I_bicarbhigh' == . & `touse'
		gen `bltmp' = `I_bicarbhigh' /*
		*/	if inrange(`I_bicarb', `I_bicarbhigh', .) & `touse'
		gen `bhtmp' = `I_bicarb' /*
		*/	if inrange(`I_bicarbhigh', ., `I_bicarb') & `touse'
		replace `I_bicarb' = min(`I_bicarb', `bltmp', `bhtmp') if `touse'
		replace `I_bicarbhigh' = max(`I_bicarbhigh', `bltmp', `bhtmp') /*
		*/	if `touse'
		drop `bhtmp' `bltmp'
	}
}
********************************************************************************
// Error Checking

		cap {
			tempvar I_age
			gen `I_age' = `age'
		}
			if _rc != 0{
				sca ag1 = 0
			}
			else {
				sca ag1 = 1
			}
		
		cap {
			tempvar I_dob
			gen `I_dob' = `dob'
		}
			if _rc != 0 {
				sca ag2 = 0
			}
			else {
				sca ag2 = 1
			}
		cap {
			tempvar I_doa
			gen `I_doa' = `doa'
		}
			if _rc != 0 {
				sca ag3 = 0
			}
			else {
				sca ag3 = 1
			}
		sca ag4 = ag2 + ag3 
			// If 2 both dob and doa exist, if 1 only one exists. If 0, none
		if ag1 == 1 & ag4 == 0 {
			sca agecase = 1 // Only categorical age is specified
		}
		
		if ag1 == 1 & inrange(ag4, 1, 2) {
			sca agecase = 2 // Both age & DoB DoA are specified
		}
		
		if ag1 == 0 & ag4 == 0 {
			sca agecase = 3 // Nothing is specified
		}
		
		if ag1 == 0 & ag4 == 1 {
			sca agecase = 4
		}
		
		if ag1 == 0 & ag4 == 2 {
			sca agecase = 5
		}
	
		if agecase == 2 {
			di as err "Both age, DoB and DoA are specified."
			di as err "Specify either age or DoB and DoA"
		}
		
		if agecase == 3 {
			di as err "Neither age, DoB or DoA are specified."
			di as err "Specify either age or DoB and DoA"
		}
		
		if agecase == 4 {
			di as err "You must specify both DoB and DoA"
		}
		
			
		// Ensures categorical variables are entered in the correct format
		if agecase == 1 {
			cou if !inlist(`I_age', 0, 1, 2, 3, 4, .)
				if r(N) != 0 {
					di as err "Age is not in the correct format. `helpme'"
					err 498
				}
			gen `I_ageIV' = 0 if `I_age' == 0
			replace `I_ageIV' = 1 if `I_age' == 1
			replace `I_ageIV' = 2 if `I_age' == 2
			replace `I_ageIV' = 3 if inrange(`I_age', 3,4)
			replace `I_age' = 0 if inrange(`I_age',0,1)
			replace `I_age' = 1 if `I_age' == 2
			replace `I_age' = 2 if `I_age' == 3
			replace `I_age' = 3 if `I_age' == 4
		}
		
		if agecase == 5 {
			gen `calculated_age' = datediff(`I_dob', `I_doa', "DAY")
			cap as `calculated_age' >= 0, f
			if _rc != 0 {
				di as err "Calculated age is negative. Observations will be ignored."
			}
			gen `I_age' = 0 if inrange(`calculated_age', 0, 30)
			replace `I_age' = 1 if inrange(`calculated_age', 31, 365)
			replace `I_age' = 2 if inrange(`calculated_age', 366, 4380) //12y
			replace `I_age' = 3 if inrange(`calculated_age', 4381, .) //12y
			gen `I_ageIV' = 0 if inrange(`calculated_age', 0, 14)
			replace `I_ageIV' = 1 if inrange(`calculated_age', 15, 30)
			replace `I_ageIV' = 2 if `I_age' == 1
			replace `I_ageIV' = 3 if inrange(`I_age', 2,3)
		}

	if suppressoption != 2 { 	// Checks that either PT or PTT are specified
		sca rc1 = 0			// If either are missing generates empty var
		sca rc2 = 0			// to prevent errors in calculation.
		sca ag1 = 0
		sca ag2 = 0
		sca ag3 = 0
		sca ag4 = 0
		cap {
			conf v `I_pt'
		}
			if _rc != 0 {
				sca rc1 = 1
			}
		cap {
			conf v `I_ptt'
		}
			if _rc != 0 {
				sca rc2 = 1
			}	
		sca rc3 = rc1 + rc2	
		if rc3 == 2 {
			di as err "You must specify either PT or PTT. `helpme'"
			err 498
		}
		else {		
			if rc1 == 1 { 	
				replace `I_pt' = .
			}
			if rc2 == 1 {
				replace `I_ptt' = .
			}
		}

	cou if !inlist(`I_pupils', 0, 1, 2, .)
	if r(N) != 0 {
			di as err "Pupils are not in the correct format. `helpme'"
			err 498
		}

if prismivoption == 1 & noimputationoption == 0 {
	cou if !inlist(`I_source', 0, 1, 2, 3, .) 
	if r(N) != 0 {
		di as err "source is not in the correct format. `helpme'"
		err 498
			}
	if suppressoption == 0 {
		cou if `I_source' == .
		if r(N) != 0 {
			di as err "source imputed. `helpme'"
			}
	}	
	
	foreach x in cpr cancer risk {
		cou if !inlist(`I_`x'', 0, 1, .)
		if r(N) != 0 {
			di as err "`x' is not binary. `helpme'"
			err 450
		}
		if suppressoption == 0 {
			cou if `I_`x'' == .
			if r(N) != 0 {
				di as err "Some `x' values imputed. `helpme'"
			}
		}
	}
}
}	// If errors are suppressed, generates empty vars for missing variables 
if suppressoption == 2{ 
	foreach x in `l_allvars' {
		cap{
		conf v `I_`x''
		}
		if _rc != 0 {
			gen `I_`x'' = .
		}
	}
}	// Assigns age and source coefficients based on age and source values
if prismivoption == 1 {
	forvalues x = 0(1)3 {
		replace `source_score' = sourcecoef`x' if `I_source' == `x'
	}


	forvalues x = 0(1)3 {
		replace `age_score' = agecoef`x' if `I_ageIV' == `x'
	} 
}

if validationoption == 1{
	n{
		di ""
		di as text "The following lists the number of out-of-range values:"
		di as text "SBP"
	replace `I_sbp' = . if `I_sbp' < 0 & `I_sbp' > 300
		di "HR"
	replace `I_hr' = . if `I_hr' < 0 & `I_hr' > 300
		di "GCS"
	replace `I_gcs' = . if `I_gcs' < 3 & `I_gcs' > 15
		di "Temperature High"
	replace `I_temp' = . if `I_temp' < tmpoor0 & `I_temp' > tmpoor1
		di "Temperature Low"
	replace `I_templow' = . if `I_templow' < tmpoor0 & `I_templow' > tmpoor1
		di "pH Low"
	replace `I_ph' = . if `I_ph' < 6.5 & `I_ph' > 7.9
		di "pH High"
	replace `I_phhigh' = . if `I_phhigh' < 6.5 & `I_phhigh' > 7.9
		di "Bicarb Low"
	replace `I_bicarb' = . if `I_bicarb' < 0.1 & `I_bicarb' > 60
		di "Bicarb High"
	replace `I_bicarbhigh' = . if `I_bicarbhigh' < 0.1 & `I_bicarbhigh' > 60
		di "PCO2"
	replace `I_pco2' = . if `I_pco2' < 1 & `I_pco2' > 200
		di "PaO2"
	replace `I_pao2' = . if `I_pao2' < 1 & `I_pao2' > 600
		di "Glucose"
	replace `I_glucose' = . if `I_glucose' < gluoor0 & `I_glucose' > gluoor1
		di "Potassium"
	replace `I_potassium' = . if `I_potassium' < 1 & `I_potassium' > 10
		di "Creatinine"
	replace `I_creatinine' = . if `I_creatinine' < croor0 & /*
	*/	`I_creatinine' > croor1
		di "BUN"
	replace `I_bun' = . if `I_bun' < bunoor0 & `I_bun' > bunoor1
	}
}
********************************************************************************
// Score Calculation
	replace `sbp_score' = 3 if ((`I_age' == 0 & inrange(`I_sbp', sbp0, sbp2))|/*
	*/	(`I_age' == 1 & inrange(`I_sbp', sbp1, sbp3)) | /*
	*/	(`I_age' == 2 & inrange(`I_sbp', sbp2, sbp4)) | /*
	*/	(`I_age' == 3 & inrange(`I_sbp', sbp3, sbp5))) & `I_sbp' != .
	replace `sbp_score' = 7 if ((`I_age' == 0 & `I_sbp' < sbp0) |  /*
	*/	(`I_age' == 1 & `I_sbp' < sbp1) | (`I_age' == 2 & `I_sbp' < sbp2) | /*
	*/	(`I_age' == 3 & `I_sbp' < sbp3)) & `I_sbp' != .
	
	replace `temperature_score' = 3 if (`I_temp' > tmp1 | `I_templow' > tmp1 |/*
	*/	`I_temp' < tmp0 | `I_templow' < tmp0) & `I_temp' != . & `I_templow' != .
	
	replace `mentalstatus_score' = 5 if `I_gcs' < gcs0 & `I_gcs' != .
	replace `mentalstatus_score' = 0 if `I_gcs' >= gcs0 & `I_gcs' != .
	
	replace `hr_score' = 3 if ((`I_age' == 0 & inrange(`I_hr', hr4, hr5)) | /*
	*/	(`I_age' == 1 & inrange(`I_hr', hr4, hr5)) | /*
	*/	(`I_age' == 2 & inrange(`I_hr', hr2, hr3))|/*
	*/	(`I_age' == 3 & inrange(`I_hr', hr0, hr1))) & `I_hr' != . 
	replace `hr_score' = 4 if ((`I_age' == 0 & hr > hr5) | /*
	*/	(`I_age' == 1 & `I_hr' > hr5) | (`I_age' == 2 & `I_hr' > hr3) | /*
	*/	(`I_age' == 3 & `I_hr' > hr1)) & `I_hr' != . 
		
	replace `pupils_score' = 7 if `I_pupils' == 1
	replace `pupils_score' = 11 if `I_pupils' == 2 
	replace `pupils_score' = 0 if `I_pupils' == 0
	
	replace `acidosis_score' = 2 if (inrange(`I_ph', ph0, ph1) | /*
	*/	inrange(`I_bicarb', bicarb0, bicarb1)) 
	replace `acidosis_score' = 6 if (`I_ph' < ph0 | `I_bicarb' < bicarb0 ) /*
	*/	& `I_ph' != . & `I_bicarb' != . 

	replace `ph_score' = 2 if inrange(`I_phhigh', ph2, ph3) | /*
	*/	inrange(`I_ph', ph2, ph3)
	replace `ph_score' = 3 if `I_phhigh' != . & (`I_phhigh' >ph3)
			
	replace `pco2_score' = 1 if inrange(`I_pco2', pco20, pco21)
	replace `pco2_score' = 3 if `I_pco2' > pco21 & `I_pco2' != .
		
	replace `bicarb_score' = 4 if (`I_bicarbhigh' > bicarb2 /*
	*/	& `I_bicarbhigh' != .) | (`I_bicarb' > bicarb2 & `I_bicarb' != .)
		
	replace `pao2_score' = 3 if inrange(`I_pao2', pao20, pao21) 
	replace `pao2_score' = 6 if `I_pao2' < pao20 & `I_pao2' != .	
		
	replace `wbc_score' = 4 if `I_wbc' < wbc0 
	replace `coag_score' = 3 if (`I_age' == 0 & ((inrange(`I_pt', pt0, .) & /*
	*/	!inlist(`I_pt',pt0)) |((inrange(`I_ptt', ptt1, .) & /*
	*/	!inlist(`I_ptt',ptt1))))) | (inrange(`I_age', 1, 3) & /*
	*/	((inrange(`I_pt', pt0, .) & !inlist(`I_pt',pt0))| /*
	*/	(inrange(`I_ptt', ptt0, .) & !inlist(`I_ptt',ptt0))))
	
	replace `glucose_score' = 2 if `I_glucose' > glu0 & `I_glucose' != .
			
	replace `potassium_score' = 3 if `I_potassium' > pot0 & `I_potassium' != .

	replace `creatinine_score' = 2 if ((`I_age' == 0 & `I_creatinine' > cr0)| /*
	*/	(inrange(`I_age', 1, 2) & `I_creatinine' > cr1) | /*
	*/	(`I_age' == 3 & `I_creatinine' > cr2)) & `I_creatinine'!= . 
	
	replace `bun_score' = 3	if ((`I_age' == 0 & `I_bun' > bun0) | /*
	*/	(inrange(`I_age', 1, 3) & `I_bun' > bun1)) & `I_bun' !=.
		
	replace `platelet_score' = 2 if inrange(`plt', plt2, plt3)
	replace `platelet_score' = 4 if inrange(`plt', plt0, plt1)
	replace `platelet_score' = 5 if `plt' < plt0 & `plt' != . 

********************************************************************************

	gen `neuroscore' = `pupils_score' + `mentalstatus_score' if `touse'
    gen `nonneuroscore' = `sbp_score' + `temperature_score' +				  /* 
	*/	`hr_score' + `acidosis_score' + `bicarb_score' + `ph_score' +		  /*
	*/	`pao2_score' + `pco2_score' + `glucose_score' + `potassium_score' +	  /*
	*/	`creatinine_score' + `bun_score' + `wbc_score' + `coag_score' +		  /*
	*/	`platelet_score' if `touse'
	gen `totalscore' = `neuroscore' + `nonneuroscore' if `touse'
	
		// Places temporary variables into permanent ones
	if noimputationoption == 1 {
		tempvar missingcheck3
		
		egen `missingcheck3' = rowmiss(`I_sbp' `I_gcs' `I_hr' `I_pupils'	  /*
		*/	`I_temp' `I_' `I_ph' `I_' `I_bicarb' `I_' `I_pco2' `I_pao2'		  /*
		*/	`I_glucose' `I_potassium' `I_creatinine' `I_bun' `I_wbc' `I_plt'  /*
		*/	`I_templow' `I_phhigh' `I_bicarbhigh' `I_pt' `I_ptt' )
		
			replace `neuroscore' = . if `missingcheck3' != 0
			replace `nonneuroscore' = . if `missingcheck3' != 0
			replace `totalscore' = . if `missingcheck3' != 0
	}	
	cap {	
		replace `neurovar' = `neuroscore'
		replace `nonneurovar' = `nonneuroscore'
		replace `totalvar' = `totalscore'
	}
	

if prismivoption == 1 {
		// Calculates PRISM IV coefficient sum
		
	gen double `prismintermediate' = intercept + `age_score' + /*
	*/	`source_score' + (`I_cpr' * cprcoef) + (`I_cancer' * cancercoef) + /*
	*/	(`I_risk' * riskcoef) + (`neuroscore' * neurocoef) + /*
	*/	(`nonneuroscore' * nonneurocoef) if `touse'
	
		// Applies logistic function to previous result
	gen double `prismfinal' = 100 / (1 + exp(-`prismintermediate')) /*
	*/	if `touse'
	
		// Rounds result to make it look pretty
	replace `prismfinal' = round(`prismfinal', 0.01) 
	if noimputationoption == 1 {
		tempvar missingcheck4
		egen `missingcheck4' = rowmiss(`I_cpr' `I_cancer' `I_risk' `I_source')
		replace `prismfinal' = . if `missingcheck4' != 0 | `missingcheck3' != 0
	}
		// Places temporary variable into the permanent one
	replace `prismivvar' = `prismfinal' 
}
********************************************************************************
if traceoption == 1{
	set tr off
}
if suppressoption == 2 {
	n: di as text/*
	*/	"This calculation ran with suppressall enabled. "/*
	*/	"It skipped all data validation and imputed " /*
	*/	"missing values as normal. You should be using " /*
	*/	"option suppress if you want to hide imputation " /*
	*/	"messages while still keeping data validation." /*
	*/	_newline "`helpme'"
}
}
}
********************************************************************************
di as text _newline "Calculation completed successfully." _continue
restore, not
end

/*
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
*/ 
