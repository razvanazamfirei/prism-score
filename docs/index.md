---
hide:
  - navigation
---
# Getting Started

This is a command developed for the calculation of PRISM III & PRISM IV scores.

## Installation Instructions

### Using net

Open Stata. Run the following command:

```stata
net install prismscore, from(https://azamfirei.com/prism-score)
```

### Using ssc

Open Stata. Run the following command:

```stata
ssc install pccmtoolkit
```

### Manually

Download all files from the /src subfolder. Copy them into your adopath. If you're not sure where that is, run the following:

```stata
adopath
```

The output will look similar to this: *(your directories will differ depending on your OS)*

```stata
[1]  (BASE)      "/Applications/Stata/ado/base/"
[2]  (SITE)      "/Applications/Stata/ado/site/"
[3]              "."
[4]  (PERSONAL)  "/Users/{yourusername}/Documents/Stata/ado/personal/"
[5]  (PLUS)      "/Users/{yourusername}/Library/Application Support/Stata/ado/plus/"
[6]  (OLDPLACE)  "~/ado/"
```

Open the directory listed under (PLUS). Copy the files into the folder. For extra style-points, find the `p` subfolder, and copy the files there.

## Usage Instructions

For more information about PRISM III & PRISM IV scores see the following references.[^1]^,^[^2] There are two main ways of running this command.
[^1]: Pollack MM, Patel KM, Ruttimann UE. PRISM III: an updated Pediatric Risk of Mortality score. Crit Care Med. 1996;24(5):743-52.
[^2]: Pollack MM, Holubkov R, Funai T, Dean JM, Berger JT, Wessel DL, et al. The Pediatric Risk of Mortality Score: Update 2015. Pediatr Crit Care Med. 2016;17(1):2-9.

### Stata dialog

Launch the dialog with `db prismscore`. Alternatively, add this line to your profile.do file:

```stata
window menu append item "stUserData" "PRISM Score" "db prismscore"
```

If you do not already have one, open a dofile editor, copy the line above, and save it as profile.do in your personal directory.
See [Manual Installation](#manually) instructions; your personal directory is folder (PERSONAL)

### Command-Line Interface

```stata
prismscore [syntax]
```

See `help prismscore` or [Documentation](details.md) for more information.

## Important Remarks

The command assumes your data is clean. While there are data validation checks built in, they cannot account for every situation. The quality of the calculation depends on the quality of the underlying data. You should explore your data beforehand and try to correct any errors.

The command supports only one measurement scale per variable. If, for example, you have temperature data that's both in &deg;C and &deg;F, you will have to convert &deg;F -> &deg;C or vice-versa.

As detailed in the [documentation](details#custom-implementations) file, you can change the coefficients used for the logistic function.

## Citation

!!! info "Citation"

    Azamfirei, Razvan; Mennie, Colleen; Fackler, James; Kudchadkar, Sapna R. Development of a Stata Command for Pediatric Risk of Mortality Calculation. Pediatric Critical Care Medicine 24(3):p e162-e163, March 2023. | DOI: 10.1097/PCC.0000000000003149


### License

**Copyright 2022 Razvan Azamfirei**

Licensed under the Apache License, Version 2.0 (the"License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
