---
hide:
  - navigation
---
# Documentation

## Title


**PRISM Score** — a command to calculate the PRISM III and PRISM IV scores

## Syntax

`prismscore` [**new\_varlist**](#new_varlist) \[[if](http://www.stata.com/help.cgi?if)\] \[[in](http://www.stata.com/help.cgi?in)\] `,` [prismIII\_varlist](#p3v) \[**prism4** [prismIV\_varlist](#p4v)\] \[unit\_options\] \[debugging\_options\]


## New Variables 
**new\_varlist** - will contain the calculated score; need to specifiy either 1, 3 or 4 variables:

**PRISM III**

You must specify **3 new variables** in the following order: neurologic\_score nonneurologic\_score total\_score. The new variables can have any name you want, but the order is very important.

**PRISM IV**

You have 2 options here: 
- If you are only interested in the PRISM IV score, specify **1 new variable**. The new variable will contain **only** the PRISM IV score.
- Otherwise, you must specify **4 new variables**. The new variables must follow this order: neurologic\_score nonneurologic\_score total\_score prism4\_score.

Note: The new variables should not already exist. You will get an error if you try using an existing variable.

## Options

This is a very quick overview of the syntax. For more information see ##Options

### **PRISM III** (required)

#### Age - Must specify either `age` or both `dob` and `doa`
| First Header  | Second Header |
| ------------- | ------------- |
| `age(varname)`  | age variable. Requires special coding.  |
| `dob(varname)` | date of birth variable |
| `doa(varname)` | date of admission variable |

 


##### Temperature 

`temp(varname)`temperature variable. If `templow` is used, then `temp` designates the high temperature variable

Optional

`templow(varname)` temperature variable. If `templow` is used, then `temp` designates the high temperature variable

##### Additional Vitals

| First Header  | Second Header |
| ------------- | ------------- |
| sbp(varname)  | Content Cell  |
| Content Cell  | Content Cell  |

systolic blood pressure variable.

`hr(varname)`

heart rate variable.

`gcs(varname)`

Glasgow Coma Score variable.

`pupils(varname)`

number of pupils > 3mm and fixed.

##### Acid-Base Status

`ph(varname)`

pH variable; if `phhigh` is used, then `ph` designates the low pH variable.

`bicarb(varname)`

designates the bicarbonate variable. if `bicarbhigh` is used, then it designates the low bicarbonate variable

`pco2(varname)`

PCO2 variable.

`pao2(varname)`

PaO2 variable.

Optional

`phhigh(varname)`

pH variable; if `phhigh` is used, then `ph` designates the low pH variable.

`bicarbhigh(varname)`

designates the bicarbonate variable. if `bicarbhigh` is used, then it designates the low bicarbonate variable

##### Laboratory Values

`glucose(varname)`

glucose variable in mg/dL.

`potassium(varname)`

potassium variable in mmol/L.

`creatinine(varname)`

creatinine variable in mg/dL.

`bun(varname)`

BUN variable in mg/dL.

`wbc(varname)`

WBC variable in cells/mm3.

`plt(varname)`

Platelet Count variable in cells/mm3.

#### **PRISM IV** (optional)

`prismiv`

calculates the PRISM IV % mortality.

Required

`source(varname)`

admission source. Requires special coding.

`cpr(varname)`

CPR status.

`cancer(varname)`

cancer status.

`risk(varname)`

low-risk system of primary dysfunction status.

#### **Additional Options**

`si`

will calculate scores based on SI Lab values.

`pltunit(integer)`

allows specifying a different platelet count unit.

`wbcunit(integer)`

allows specifying a different WBC unit.

`FAHRenheit`

allows specifying a different temperature unit.

#### **Debugging Options**

`trace`

enables the trace option for the command. Useful in case of unexpected errors.

`suppress`

suppresses warnings regarding data imputation.

`suppressall`

suppress all errors and data validation functions.

`noimputation`

shows missing score if any variables are missing.

`novalidation`

supresses out-of-range data checks. If this is not specified, values that are out-of-range will be considered missing.

{marker description}{nobreak None} {title None:Description} {pstd None} {pstd None} `prismscore` calculates PRISM III and PRISM IV scores. The scores are outcome prognostication tools that have been used extensively in clinical care and research to calculate the expected mortality and control for illness severity in pediatric intensive care units.

## Options


For all required variables, if there is data missing you will receive a warning. The calculation will still be performed using normal values for the age group. See options `suppress` and `suppressall` for more information.

### Main

`prismiv` will calculate a percentage mortality based on the PRISM IV score. This will require specifying `admitsource(varname)`, `cancer(varname)`, `cpr(varname)`, and `risk(varname)`.

### PRISM III

`age`(varname numeric) designates the age variable. Age must be coded as: **0** = (<- - 14 days\] | **1** = (14 days - 1 month) | **2** = \[1 month - 12 months) | **3** = \[12 months - 12 years) | **4** = \[12 years ->). Alternatively use `dob` and `doa` for automatic calculations of age. This is recommended if the age is not already appropriately coded.

`dob`(varname [**date**](http://www.stata.com/help.cgi?datetime)) designates the date of birth variable. Date of birth must be in [**%td**](http://www.stata.com/help.cgi?datetime_display_formats) format.

`doa`(varname [**date**](http://www.stata.com/help.cgi?datetime)) designates the date of admission variable. Date of admission must be in [**%td**](http://www.stata.com/help.cgi?datetime_display_formats) format.

{p2line 5 5}

`sbp(varname numeric)` designates the systolic blood pressure variable.

`hr(varname numeric)` designates the heart rate variable.

`gcs(varname integer)` designates the Glascow Coma Score variable.

`pupils(varname integer)` designates the variable containing the number of pupils >3mm and fixed.

`temp(varname numeric)` designates the temperature variable. If there is only one temperature recorded, the command will use the recorded temperature for both high and low temperature calculations. If both a high and a low temperature value are recorded, specify `templow`.

`templow(varname numeric)` designates the low temperature variable. If both `temp` and `templow` are specified, the command will compare the values and will use the highest value for high temperature calculations and the lowest value for the low temperature calculations.

{p2line 5 5}

`ph(varname numeric)` designates the ph variable. If there is only one pH recorded, the command will use the recorded pH for both high and low pH calculations. If both a high and a low pH value are recorded, specify `phhigh`.

`phhigh(varname numeric)` designates the high ph variable. If both `ph` and `phhigh` are specified, the command will compare the values and will use the highest value for high ph calculations and the lowest value for the low ph calculations.

`bicarb(varname numeric)` designates the HCO3-/CO2 variable. If there is only one bicarbonate value recorded, the command will use the recorded bicarbonate values for both high and low bicarbonate calculations. If both a high and a low bicarbonate value are recorded, specify `bicarbhigh`.

`bicarbhigh(varname numeric)` designates the high HCO3-/CO2 variable. If both `bicarb` and `bicarbhigh` are specified, the command will compare the values and will use the highest value for high bicarbonate calculations and the lowest value for the low bicarbonate calculations.

`pco2(varname numeric)` designates the PCO2 variable; not to be confused with the bicarb variable.

`po2(varname numeric)` designates the PO2 variable.

{p2line 5 5}

`glucose(varname)` glucose variable in mg/dL.

`potassium(varname)` potassium variable in mEq/L or mmol/L. The units are identical.

`creatinine(varname)` creatinine variable in mg/dL.

`bun(varname)` BUN variable in mg/dL.

`wbc(varname)` WBC variable in cells/mm3.

`plt(varname)` Platelet Count variable in cells/mm3.

### PRISM IV

`source(varname)` Admission Source variable. Source must be coded as: **0** = Operating Room or PACU | **1** = Another Hospital| **2** = Inpatient Unit| **3** = Emergency Department.

`cpr(varname)` CPR in the last 24h variable. CPR must be coded as: **0** = No | **1** = Yes.

`cancer(varname)` Acute or Chronic Cancer variable. Cancer must be coded as: **0** = No | **1** = Yes.

`risk(varname)` Low-risk systems of primary dysfunction variable. Risk must be coded as: **0** = No | **1** = Yes. Endocrine, hematologic, musculoskeletal, and renal systems are defined as low risk.

### Unit Options

`wbcunit(numeric)` If not specified, it defaults to cells/mm3 - `wbcunit(1)`. If data is in 1000 \* cells/mm3 specify `wbcunit(1000)`.

`pltunit(numeric)` If not specified, it defaults to cells/mm3 - `pltunit(1)`. If data is in 1000 \* cells/mm3 specify `pltunit(1000)`.

`si` If specified, it assumes glucose is recorded as mmol/L, creatinine is recorded as umol/L and BUN is recorded as mmol/L. Otherwise it assumes glucose, creatinine and BUN are recorded as mg/dL.

`fahrenheit` If specified, it assumes glucose is recorded in Fahrenheit. If not specified, Celsius is assumed.

### Useful

`trace` enables trace

`suppress` suppresses warnings about calculation with missing values

`suppressall` suppresses all warnings and data checks

`noimputation` calculated score will be set to missing if any of the included variables are missing

`novalidation` if this option is

NOT



## Custom Implementations
--

Some groups have modified the coefficients attributed to each of the variables in the PRISM IV score calculation. The coefficients used in this command are the ones reported in Pollack 2016. If you wish to change them, you have to modify the prismscore.ado file. I am not offering a command-based option to prevent inadvertent changes by inexperienced users. If you are having issues with this, please email me and I'm happy to help.

Instructions  
Open the prism.ado file. Locate the section containing the PRISM IV coefficients (line 210); alternatively search for **CHANGE THIS**. Modify the coefficients as needed and reload the program. The following commands should be helpful:

1\. `. doedit prismscore.ado`

2\. Make edits and save.

3\. `. program drop prismscore`

4\. `. do prismscore.ado`

## References


\[1\] Pollack MM, Patel KM, Ruttimann UE. PRISM III: an updated Pediatric Risk of Mortality score. Crit Care Med. 1996;24(5):743-52.  
\[2\] Pollack MM, Holubkov R, Funai T, Dean JM, Berger JT, Wessel DL, et al. The Pediatric Risk of Mortality Score: Update 2015. Pediatr Crit Care Med. 2016;17(1):2-9.

## Author


Email:

Razvan Azamfirei[**stata@azamfirei.com**](mailto:stata@azamfirei.com)

## License


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public

[**License**](https://gnu.org/licenses/gpl-3.0.html) for more details.