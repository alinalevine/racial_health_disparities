


proc import out=chs_clean
	datafile="'/folders/myfolders/project/chs_clean_recode.csv'"
	dbms=csv replace;
	getnames=yes;
run;



/* pcp 18  including poverty and insurance and education */ 
proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
domain agegroup;
class newrace  (ref = first) generalhealth (ref = first) insured (ref = first)  imputed_povertygroup (ref = first)  birthsex (ref = first)  agegroup (ref = first)  education (ref = first)  /  param= ref;
model pcp18 (event='1') = newrace insured imputed_povertygroup education birthsex generalhealth;
output out = predicted p = predprob;
run;










/* pcp 18  removing poverty and insurance and education*/ 
proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
domain agegroup;
class newrace  (ref = first)   insure5 (ref = first)  generalhealth (ref = first) imputed_povertygroup (ref = first)  birthsex (ref = first)  agegroup (ref = first)  education (ref = first)  /  param= ref;
model pcp18 (event='1') = newrace birthsex generalhealth;
output out = predicted p = predprob;
run;


