---
hide:
  - navigation
---
# Getting Started

This is a command developed for the calculation of PRISM III & PRISM IV scores. It is released under a GPLv3 license, which means that it's free for anyone to use.

## Installation Instructions

### Using net

Open Stata. Run the following command:

```stata
net install prismscore, from(https://azamfirei.com/prism-score)
```

### Using ssc

Open Stata. Run the following command:

**Note**: This is not yet available.

```stata
ssc install prismscore
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

For more information about PRISM III & PRISM IV scores see . There are two main ways of running this command.

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

See `help prismscore` for more information.

## Important Remarks

The command assumes your data is clean. While there are data validation checks built in, they cannot account for every situation. The quality of the calculation depends on the quality of the underlying data. You should explore your data beforehand and try to correct any errors.

The command supports only one measurement scale per variable. If, for example, you have temperature data that's both in Celsius and Fahrenheit, you will have to convert Fahrenheit -> Celsius or viceversa.

As detailed in the help file, you can change the coefficients used for the logistic function.

### Disclaimer

I would like to draw your attention to [Section 15](about/license.md#15-disclaimer-of-warranty) and [Section 16](about/license.md#16-limitation-of-liability) of the license.

```markdown
### 15. Disclaimer of Warranty

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

### 16. Limitation of Liability

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
```

Every section of the license under which this program is distributed is important. My failure to mention it explicitly here does not constitute a waiver of those terms.
