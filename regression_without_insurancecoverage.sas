
* Import dataset;
proc import out=chs_clean
	datafile="C:\Users\tjqja\Documents\Columbia\P8123 Analysis of Health Surveys\Final Project\chs_clean.csv"
	dbms=csv replace;
	getnames=yes;
run;

* Regression fitting;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model didntgetcare18 (event='1') = newrace imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model  pcp18(event='1') = newrace imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model medcost18 (event='1') = newrace imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;
