/*import data*/
proc import out=chs
datafile="C:\Users\Holly\Desktop\health survey\8 Final project\racial_health_disparities\chs_clean_recode.csv"
dbms=csv replace;
getnames=yes;
run;

/*table 1 age*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*agegroup /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_age;
run;

data race_age;
set race_age;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_age dbms=csv
outfile="race_age.csv"
replace;
run;

/*table 1 race total*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace /cl(type=logit);
ods output OneWay = race;
run;

data race;
set race;
format Percent LowerCL UpperCL 8.2;
run;

proc export data=race dbms=csv
outfile="race.csv"
replace;
run;

/*table 1 sex*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*birthsex /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_sex;
run;

data race_sex;
set race_sex;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_sex dbms=csv
outfile="race_sex.csv"
replace;
run;

/*table 1 education*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*education /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_edu;
run;

data race_edu;
set race_edu;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_edu dbms=csv
outfile="race_edu.csv"
replace;
run;

/*table 1 income*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*imputed_povertygroup /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_pov;
run;

data race_pov;
set race_pov;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_pov dbms=csv
outfile="race_pov.csv"
replace;
run;

/*table 1 insurance*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*insured /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_ins;
run;

data race_ins;
set race_ins;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_ins dbms=csv
outfile="race_ins.csv"
replace;
run;

/*table 1 usual care provider*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*pcp18 /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_pcp;
run;

data race_pcp;
set race_pcp;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_pcp dbms=csv
outfile="race_pcp.csv"
replace;
run;

/*table 1 general health*/
proc surveyfreq data=chs;
strata strata; weight wt19_dual;
table newrace*generalhealth /cl(type=logit) row chisq(secondorder);
ods output CrossTabs = race_health;
run;

data race_health;
set race_health;
format RowPercent RowLowerCL RowUpperCL 8.2;
run;

proc export data=race_health dbms=csv
outfile="race_health.csv"
replace;
run;

/*model for insurance*/
proc surveylogistic data = chs;
strata strata; weight wt19_dual;
class newrace(ref = first)  birthsex(ref = first) generalhealth (ref = first)  /  param= ref;
model insured (event='1') = newrace birthsex generalhealth;
domain agegroup;
ods output OddsRatios=or;
run;

/*OR plot for insurance*/
data or;
set or;
if domain ne " ";
if effect in ("newrace       2 vs 1", "newrace       3 vs 1", "newrace       4 vs 1");
length name $30;
if agegroup=4 & effect="newrace       2 vs 1" then name="65+ Black Non-hispanic";
else if agegroup=4 & effect="newrace       3 vs 1" then name="65+ Hispanic";
else if agegroup=4 & effect="newrace       4 vs 1" then name="65+ Other Non-hispanic";
else if agegroup=3 & effect="newrace       2 vs 1" then name="45-64 Black Non-hispanic";
else if agegroup=3 & effect="newrace       3 vs 1" then name="45-64 Hispanic";
else if agegroup=3 & effect="newrace       4 vs 1" then name="45-64 Other Non-hispanic";
else if agegroup=1 & effect="newrace       2 vs 1" then name="18-44 Black Non-hispanic";
else if agegroup=1 & effect="newrace       3 vs 1" then name="18-44 Hispanic";
else if agegroup=1 & effect="newrace       4 vs 1" then name="18-44 Other Non-hispanic";
or="OR";
lower="LowerCI";
upper="UpperCI";
format OddsRatioEst UpperCL LowerCL 8.2;
run;

ods listing gpath='C:\Users\Holly\Desktop\health survey\8 Final project';
ods graphics / imagename="insurance" imagefmt=png;
proc sgplot data=or noautolegend;
scatter y=name x=OddsRatioEst / xerrorupper=UpperCL xerrorlower=LowerCL markerattrs=(symbol=squarefilled size=5);
scatter y=name x=or / markerchar=OddsRatioEst x2axis;
scatter y=name x=lower / markerchar=LowerCL x2axis;
scatter y=name x=upper / markerchar=UpperCL x2axis;
refline 1 2 / axis=x;
xaxis offsetmin=0 offsetmax=0.40 max=2 display=(nolabel);
x2axis offsetmin=0.65 display=(noticks nolabel);
yaxis display=(noticks nolabel);
run;

/*fully adjusted model for usual care provider*/
proc surveylogistic data = chs;
strata strata; weight wt19_dual;
class newrace(ref = first) birthsex(ref = first) generalhealth (ref = first) 
imputed_povertygroup(ref = first) education (ref = first) insured (ref = first) /  param= ref;
model pcp18(event='1') = newrace birthsex generalhealth insured imputed_povertygroup education;
domain agegroup;
ods output OddsRatios=or2;
run;

/*OR plot for usual care provider*/
data or2;
set or2;
if domain ne " ";
if effect in ("newrace              2 vs 1", "newrace              3 vs 1", 
"newrace              4 vs 1", "insured              2 vs 1");
length name $30;
if agegroup=4 & effect="newrace              2 vs 1" then name="65+ Black Non-hispanic";
else if agegroup=4 & effect="newrace              3 vs 1" then name="65+ Hispanic";
else if agegroup=4 & effect="newrace              4 vs 1" then name="65+ Other Non-hispanic";
else if agegroup=4 & effect="insured              2 vs 1" then name="65+ Uninsured";
else if agegroup=3 & effect="newrace              2 vs 1" then name="45-64 Black Non-hispanic";
else if agegroup=3 & effect="newrace              3 vs 1" then name="45-64 Hispanic";
else if agegroup=3 & effect="newrace              4 vs 1" then name="45-64 Other Non-hispanic";
else if agegroup=3 & effect="insured              2 vs 1" then name="45-64 Uninsured";
else if agegroup=1 & effect="newrace              2 vs 1" then name="18-44 Black Non-hispanic";
else if agegroup=1 & effect="newrace              3 vs 1" then name="18-44 Hispanic";
else if agegroup=1 & effect="newrace              4 vs 1" then name="18-44 Other Non-hispanic";
else if agegroup=1 & effect="insured              2 vs 1" then name="18-44 Uninsured";
or="OR";
lower="LowerCI";
upper="UpperCI";
format OddsRatioEst UpperCL LowerCL 8.2;
run;

ods listing gpath='C:\Users\Holly\Desktop\health survey\8 Final project';
ods graphics / imagename="pcp" imagefmt=png;
proc sgplot data=or2 noautolegend;
scatter y=name x=OddsRatioEst / xerrorupper=UpperCL xerrorlower=LowerCL markerattrs=(symbol=squarefilled size=5);
scatter y=name x=or / markerchar=OddsRatioEst x2axis;
scatter y=name x=lower / markerchar=LowerCL x2axis;
scatter y=name x=upper / markerchar=UpperCL x2axis;
refline 1 4 / axis=x;
xaxis offsetmin=0 offsetmax=0.40 max=4 display=(nolabel);
x2axis offsetmin=0.65 display=(noticks nolabel);
yaxis display=(noticks nolabel);
run;
