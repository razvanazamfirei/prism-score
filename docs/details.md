---
hide:
  - navigation
---
<style>
.md-typeset__scrollwrap{
  margin: 0em;
}
.md-typeset__table {
    table-layout: fixed;
    width: 70%;
}
table th:first-of-type {
    width: 10%;
}
table th:nth-of-type(2) {
    width: auto;
}
.admonition.info{
  width: 70%;
}
</style>

# Documentation

If this command is used in in any publications, please reference the following article.

!!! info "Citation"

    Azamfirei, Razvan; Mennie, Colleen; Fackler, James; Kudchadkar, Sapna R. Development of a Stata Command for Pediatric Risk of Mortality Calculation. Pediatric Critical Care Medicine 24(3):p e162-e163, March 2023. | DOI: 10.1097/PCC.0000000000003149



## Title

**PRISM Score** — a command to calculate the PRISM III and PRISM IV scores

## Syntax Overview

### Syntax Structure

``` stata
prismscore new_varlist [if] [in] ,
  prismIII_varlist
  [prism4] [prismIV_varlist]
  [unit_options] [debugging_options]
```

### New Variables

**new\_varlist** - will contain the calculated score; need to specify either 1, 3 or 4 variables:

#### PRISM III - New Variables

-   You must specify **3 new variables** in the following order:
    1. **neurologic\_score**
    1. **nonneurologic\_score**
    1. **total\_score** 

The new variables can have any name, but they **must** be specified in this order.

#### PRISM IV - New Variables

There are 2 options:

-   If you are only interested in the PRISM IV score, specify **1 new variable**. The new variable will contain **only** the PRISM IV score.
-   Otherwise, you must specify **4 new variables**. The new variables must follow this order:

    1.  **neurologic\_score**
    1.  **nonneurologic\_score**
    1.  **total\_score**
    1.  **prism4\_score**

Note: The new variable names should be unique (i.e. not already exist). You will get an error if you try using an existing variable.

### Variable Lists and Options

This is a very quick overview of the syntax. For more information see [Options](#options)

#### PRISM III - Variable List

##### Age

Must specify either `age` or both `dob` and `doa`

| Option Name  | Option Description                     |
| ------------ | -------------------------------------- |
| age(varname) | age variable. Requires special coding. |
| dob(varname) | date of birth variable                 |
| doa(varname) | date of admission variable             |

##### Temperature

| Option Name          | Option Description                 |
| -------------------- | ---------------------------------- |
| temp(varname)        | temperature variable<sup>[1]</sup> |
| *Optional*           |                                    |
| templow(varname)     | low temperature variable           |

!!! info

    [1] if *templow* is used, then *temp* designates the high temperature variable

##### Additional Vitals

| Option Name     | Option Description               |
| --------------- | -------------------------------- |
| sbp(varname)    | Systolic Blood Pressure variable |
| hr(varname)     | Heart Rate variable              |
| gcs(varname)    | Glasgow Coma Score variable      |
| pupils(varname) | number of pupils > 3mm and fixed |


##### Acid-Base Status

| Option Name     | Option Description       |
| --------------- | ------------------------ |
| ph(varname)     | pH variable <sup>[1]</sup>          |
| bicarb(varname) | bicarbonate variable <sup>[2]</sup>|
| pco2(varname)   | PCO2 variable            |
| pao2(varname)   | PaO2 variable            |

!!! info
    [1] if *phhigh* is used, then *ph* designates the low pH variable.

    [2] If *bicarbhigh* is used, then it designates the low bicarbonate variable.

###### Optional

| Option Name         | Option Description                       |
| ------------------- | ---------------------------------------- |
| phhigh(varname)     | pH High Variable <sup>[1]</sup>          |
| bicarbhigh(varname) | Bicarbonate High Variable <sup>[2]</sup> |


!!! info
    [1] if *phhigh* is used, then *ph* designates the low pH variable.

    [2] If *bicarbhigh* is used, then it designates the low bicarbonate variable.

##### Laboratory Values

| Option Name          | Option Description                   |
| -------------------- | ------------------------------------ |
| glucose(varname)     | glucose variable in mg/dL            |
| potassium(varname)   | potassium variable in mmol/L         |
| creatinine(varname)  | creatinine variable in mg/dL         |
| bun(varname)         | BUN variable in mg/dL                |
| wbc(varname)         | WBC variable in cells/mm3            |
| plt(varname)         | Platelet Count variable in cells/mm3 |

#### PRISM IV - Variable List

*prismiv* calculates the PRISM IV % mortality.

Required

| Option Name     | Option Description                            |
| --------------  | --------------------------------------------  |
| source(varname) | admission source. Requires special coding     |
| cpr(varname)    | CPR status                                    |
| cancer(varname) | cancer status                                 |
| risk(varname)   | low-risk system of primary dysfunction status |

#### Additional Options

| Option Name      | Option Description                                 |
| ---------------- | -------------------------------------------------- |
| si               | will calculate scores based on SI Lab values       |
| pltunit(integer) | allows specifying a different platelet count unit  |
| wbcunit(integer) | allows specifying a different WBC unit             |
| FAHRenheit       | allows specifying a different temperature unit     |

#### Debugging Options

| Option Name   | Option Description                                                            |
| ------------- | ----------------------------------------------------------------------------- |
| trace         | enables the trace option for the command. Useful in case of unexpected errors |
| suppress      | suppresses warnings regarding data imputation                                 |
| suppressall   | suppress all errors and data validation functions                             |
| noimputation  | shows missing score if any variables are missing                              |
| novalidation  | supresses out-of-range data checks. If this is not specified, values that are out-of-range will be considered missing |

## Description

*prismscore* calculates PRISM III and PRISM IV scores. The scores are outcome prognostication tools that have been used extensively in clinical care and research to calculate the expected mortality and control for illness severity in pediatric intensive care units.

## Options

For all required variables, if there is data missing you will receive a warning. The calculation will still be performed using normal values for the age group. See options *suppress* and *suppressall* for more information.

### Main

*prismiv* will calculate a percentage mortality based on the PRISM IV score. This will require specifying *admitsource(varname)*, *cancer(varname)*, *cpr(varname)*, and *risk(varname)*.

### PRISM III

**age** (varname numeric) designates the age variable. Age must be coded as:

| Value         | Value Description                  |
| ------------- | ---------------------------------- |
| **0**         | *age* &le; 14 days                 |
| **1**         | 14 days &lt; *age* &lt; 1 month    |
| **2**         | 1 month &le; *age* &lt; 12 months  |
| **3**         | 12 months &le; *age* &lt; 12 years |
| **4**         | *age* &ge; 12 years                |

Alternatively use *dob* and *doa* for automatic calculations of age. This is recommended if the age is not already appropriately coded.

**dob**(varname [**date**](http://www.stata.com/help.cgi?datetime)) designates the date of birth variable. Date of birth must be in [**%td**](http://www.stata.com/help.cgi?datetime_display_formats) format.

**doa**(varname [**date**](http://www.stata.com/help.cgi?datetime)) designates the date of admission variable. Date of admission must be in [**%td**](http://www.stata.com/help.cgi?datetime_display_formats) format.
___
**sbp(varname numeric)** designates the systolic blood pressure variable.

**hr(varname numeric)** designates the heart rate variable.

**gcs(varname integer)** designates the Glascow Coma Score variable.

**pupils(varname integer)** designates the variable containing the number of pupils >3mm and fixed.

___
**temp(varname numeric)** designates the temperature variable. If there is only one temperature recorded, the command will use the recorded temperature for both high and low temperature calculations. If both a high and a low temperature value are recorded, specify *templow*.

**templow(varname numeric)** designates the low temperature variable. If both *temp* and *templow* are specified, the command will compare the values and will use the highest value for high temperature calculations and the lowest value for the low temperature calculations.

___
**ph(varname numeric)** designates the ph variable. If there is only one pH recorded, the command will use the recorded pH for both high and low pH calculations. If both a high and a low pH value are recorded, specify *phhigh*.

**phhigh(varname numeric)** designates the high ph variable. If both *ph* and *phhigh* are specified, the command will compare the values and will use the highest value for high ph calculations and the lowest value for the low ph calculations.
___
**bicarb(varname numeric)** designates the HCO3-/CO2 variable. If there is only one bicarbonate value recorded, the command will use the recorded bicarbonate values for both high and low bicarbonate calculations. If both a high and a low bicarbonate value are recorded, specify *bicarbhigh*.

**bicarbhigh(varname numeric)** designates the high HCO3-/CO2 variable. If both *bicarb* and *bicarbhigh* are specified, the command will compare the values and will use the highest value for high bicarbonate calculations and the lowest value for the low bicarbonate calculations.
___
**pco2(varname numeric)** designates the PCO2 variable; not to be confused with the bicarb variable.

**po2(varname numeric)** designates the PO2 variable.
___
**glucose(varname)** glucose variable in mg/dL.

**potassium(varname)** potassium variable in mEq/L or mmol/L. The units are identical.

**creatinine(varname)** creatinine variable in mg/dL.

**bun(varname)** BUN variable in mg/dL.
___
**wbc(varname)** WBC variable in cells/mm3.

**plt(varname)** Platelet Count variable in cells/mm3.

### PRISM IV

**source(varname)** Admission Source variable. Source must be coded as:

| Value         | Value  Description     |
| ------------- | ---------------------- |
| **0**         | Operating Room or PACU |
| **1**         | Another Hospital       |
| **2**         | Inpatient Unit         |
| **3**         | Emergency Department   |

**cpr(varname)** CPR in the last 24h variable. CPR must be coded as: **0** = No | **1** = Yes.

**cancer(varname)** Acute or Chronic Cancer variable. Cancer must be coded as: **0** = No | **1** = Yes.

**risk(varname)** Low-risk systems of primary dysfunction variable. Risk must be coded as: **0** = No | **1** = Yes. Endocrine, hematologic, musculoskeletal, and renal systems are defined as low risk.

### Unit Options

**wbcunit(numeric)** If not specified, it defaults to cells/mm3 (i.e. *wbcunit(1)*). If data is in 1000 \* cells/mm3 specify *wbcunit(1000)*.

**pltunit(numeric)** If not specified, it defaults to cells/mm3 (i.e. *pltunit(1)*). If data is in 1000 \* cells/mm3 specify *pltunit(1000)*.

**si** If specified, it assumes glucose is recorded as mmol/L, creatinine is recorded as umol/L and BUN is recorded as mmol/L. Otherwise it assumes glucose, creatinine and BUN are recorded as mg/dL.

**fahrenheit** If specified, it assumes glucose is recorded in Fahrenheit. If not specified, Celsius is assumed.

### Useful

**trace** enables trace

**suppress** suppresses warnings about calculation with missing values

**suppressall** suppresses all warnings and data checks

**noimputation** calculated score will be set to missing if any of the included variables are missing

**novalidation** values that are out-of-range will be set to missing.

## Custom Implementations

Some groups have modified the coefficients attributed to each of the variables in the PRISM IV score calculation. The coefficients used in this command are the ones reported in Pollack 2016.[^1]^,^[^2] If you wish to change them, you have to modify the prismscore.ado file. I am not offering a command-based option to prevent inadvertent changes by inexperienced users. If you are having issues with this, please reach out.

[^1]: Pollack MM, Patel KM, Ruttimann UE. PRISM III: an updated Pediatric Risk of Mortality score. Crit Care Med. 1996;24(5):743-52.
[^2]: Pollack MM, Holubkov R, Funai T, Dean JM, Berger JT, Wessel DL, et al. The Pediatric Risk of Mortality Score: Update 2015. Pediatr Crit Care Med. 2016;17(1):2-9.

Instructions:
Open the prism.ado file. Locate the section containing the PRISM IV coefficients (line 261); alternatively search for **CHANGE THIS**. 
```stata linenums="257" hl_lines="5" title="prismscore.ado"
//  Sets coefficients and bounds

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
```        

Modify the coefficients as needed and reload the program. The following commands should be helpful:

```stata title=""
doedit prismscore.ado
* Make edits and save.
program drop prismscore
do prismscore.ado
```
