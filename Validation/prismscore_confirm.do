cscript prismscore adofile prismscore
use "Validated Data.dta"
datasignature confirm using "Validated Data.dtasig", strict

qui prismscore neuro_c nonneuro_c totalscore_c, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt)

	assert neuro_c == neuro
	assert nonneuro_ == nonneuro_c
	assert totalscore_c == totalscore
	
drop neuro_c nonneuro_c totalscore_c

qui prismscore neuro_c nonneuro_c totalscore_c, doa(doa) dob(dob) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si
	assert neuro_c == neuro
	assert nonneuro_ == nonneuro_c
	assert totalscore_c == totalscore
drop neuro_c nonneuro_c totalscore_c

clear

use "P4_Validated Data.dta"
datasignature confirm using "P4_Validated Data.dtasig", strict

qui prismscore neuro_c nonneuro_c totalscore_c score, age(age) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose) potassium(potassium) creatinine(creatinine) bun(bun) wbc(wbc) plt(plt) pt(pt) ptt(ptt) prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)

	assert abs(float(prism4) - float(score)) < 2 * 1E-2
	assert neuro_c == neuro
	assert nonneuro_ == nonneuro_c
	assert totalscore_c == totalscore
	drop score neuro_c nonneuro_c totalscore_c
	
	qui prismscore neuro_c nonneuro_c totalscore_c score, dob(dob) doa(doa) sbp(sbp) hr(hr) temp(temp_high) templow(temp_low) gcs(gcs) pupils(pupils) ph(phlow) phhigh(phhigh) bicarb(bicarblow) bicarbhigh(bicarbhigh) pco2(pco2) pao2(pao2) glucose(glucose_si) potassium(potassium) creatinine(creatinine_si) bun(bun_si) wbc(wbc_k) plt(plt_k) pt(pt) ptt(ptt) pltunit(1000) wbcunit(1000) si prismiv source(source) risk(risk) cancer(cancer) cpr(cpr)
	assert abs(float(prism4) - float(score)) < 2 * 1E-2
	assert neuro_c == neuro
	assert nonneuro_ == nonneuro_c
	assert totalscore_c == totalscore
	drop score neuro_c nonneuro_c totalscore_c
