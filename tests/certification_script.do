cscript prismscore adofile prismscore
cd "./tests/data"
use "prism_3_dataset_5.dta"
datasignature confirm using "prism_3_dataset_5.dtasig", strict

qui prismscore neuro_c nonneuro_c totalscore_c, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt)

	assert neuro_c == neuro
	assert nonneuro_c == nonneuro
	assert totalscore_c == totalscore
	
drop neuro_c nonneuro_c totalscore_c

qui prismscore neuro_c nonneuro_c totalscore_c, doa(doa) dob(dob) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si
	assert neuro_c == neuro
	assert nonneuro_c == nonneuro
	assert totalscore_c == totalscore
drop neuro_c nonneuro_c totalscore_c

clear

use "P4_Validated Data.dta"
datasignature confirm using "P4_Validated Data.dtasig", strict
	
	qui prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)

	assert abs(float(prism4) - float(score)) < 2 * 1E-2
	assert neuro_c == neuro
	assert nonneuro_c == nonneuro
	assert totalscore_c == totalscore
	drop score neuro_c nonneuro_c totalscore_c
	
	qui prismscore neuro_c nonneuro_c totalscore_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)
	assert abs(float(prism4) - float(score)) < 2 * 1E-2
	assert neuro_c == neuro
	assert nonneuro_c == nonneuro
	assert totalscore_c == totalscore
	drop score neuro_c nonneuro_c totalscore_c
	
	noi di as result "The following section will intentionally trigger errors and verify the appropriate error code. This test is passed succesfully if the last line displays: Certification completed succesfully."
	qui {
	* Missing Score Variables
		rcof "noi prismscore neuro_c nonneuro_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
	rcof "noi prismscore nonneuro_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
	rcof "noi prismscore nonneuro_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
	rcof "noi prismscore score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
	rcof "noi prismscore prismscore neuro_c nonneuro_c totalscore_c, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
* Missing PRISM IV variables	
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cancer(cancer)" == 102
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cpr(cpr)" == 102
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) cancer(cancer) cpr(cpr)" == 102
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv risk(risk) cancer(cancer) cpr(cpr)" == 102
* Incorrect Units
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(954) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr) " == 499
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(964) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 499
* Age Errors
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 103
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 102
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 102
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, dob(dob) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 102
	preserve
	replace age = 5 if totalscore == 43
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 498
	restore
* PT/PTT Errors
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt)" == 102
* Pupils
	preserve
	replace pupils = 3 if totalscore == 43
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt)" == 499
	restore
* PRISM IV options
	preserve
	replace source = 6 if totalscore == 43
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 499
	restore
	foreach x in cpr cancer risk {
	preserve
	replace `x' = 6 if totalscore == 43
	rcof "noi prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)" == 450
	restore
	}
	}
	noi di as result "Certification completed succesfully. `c(current_date)' `c(current_time)'" 
