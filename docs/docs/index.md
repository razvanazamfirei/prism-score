---
hide:
  - navigation
---
# Getting Started

This is a command developed for the calculation of PRISM III & PRISM IV scores. It is released under a GPLv3 license, which means that it's free for anyone to use. 

## Installation Instructions
### Using net
Open Stata. Run the following command: 
```
net install prismscore, from(https://razvanazamfirei.github.io/prism-scoring)
```
### Using ssc
Open Stata. Run the following command: 
```
ssc install prismscore
```
### Manually
Download all files from the /src subfolder. Copy them into your adopath. If you're not sure where that is, run the following: 
```
adopath
```
The output will look similar to this: *(your directories will differ depending on your OS)*
```
[1]  (BASE)      "/Applications/Stata/ado/base/"
[2]  (SITE)      "/Applications/Stata/ado/site/"
[3]              "."
[4]  (PERSONAL)  "/Users/{yourusername}/Documents/Stata/ado/personal/"
[5]  (PLUS)      "/Users/{yourusername}/Library/Application Support/Stata/ado/plus/"
[6]  (OLDPLACE)  "~/ado/"
```
Open the directory listed under (PLUS). Copy the files into the folder. For extra style-points, find the `p` subfolder, and copy the files there. 
## Usage Instructions
For more information about PRISM III & PRISM IV scores see . There are two main ways of running this command. 

### Stata dialog
Go to `User -> Statistics -> Prism Score`. Alternatively, launch the dialog with `db prismscore`.

### Command-Line Interface
```
prismscore [syntax]
```
See ```help prismscore``` for more information.
## Important Remarks
The command assumes your data is clean. While there are data validation checks built in, they cannot account for every situation. The quality of the calculation depends on the quality of the underlying data. You should explore your data beforehand and try to correct any errors. 

The command supports only one measurement scale per variable. If, for example, you have temperature data that's both in Celsius and Fahrenheit, you will have to convert Fahrenheit -> Celsius or viceversa. 

As detailed in the help file, you can change the coefficients used for the logistic function.