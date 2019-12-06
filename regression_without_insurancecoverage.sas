ods rtf file = "C:\Users\tjqja\Documents\Columbia\regression_jt3098.rtf"
		bodytitle startpage=yes;
* Import dataset;
proc import out=chs_clean
	datafile="C:\Users\tjqja\Documents\Columbia\P8123 Analysis of Health Surveys\Final Project\chs_clean.csv"
	dbms=csv replace;
	getnames=yes;
run;
proc format;
   value race 1 = "White Non-Hispanic"
   			  2 = "Black Non-Hispanic"
   			  3 = "Hispanic"
   			  4 = "Other Non-Hispanic";
   value age 1 = "18-44"
   			 3 = "45-64"
			 4 = "65+";
run;

data chs_clean;
	set chs_clean;
	format agegroup age.
		   newrace race.;
run;
* Regression fitting;
proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class insured(ref='2') newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model pcp18 (event='1') = newrace birthsex;
domain agegroup;
output out = predicted p = predprob;
run;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class insured(ref='2') newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model didntgetcare18 (event='1') = newrace birthsex;
domain agegroup;
output out = predicted p = predprob;
run;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class insured(ref='2') newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model didntgetcare18 (event='1') = newrace birthsex insured imputed_povertygroup education;
domain agegroup;
output out = predicted p = predprob;
run;

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class insured(ref='2') newrace(ref = first) imputed_povertygroup(ref = first)  birthsex(ref = first)  agegroup(ref = first)  education (ref = first)  /  param= ref;
model pcp18 (event='1') = newrace birthsex insured imputed_povertygroup education;
domain agegroup;
output out = predicted p = predprob;
run;

* Barplot making;
proc freq data=chs_clean;
    table agegroup* newrace * didntgetcare18/out=freq outpct;
	weight wt19_dual;
quit;

proc freq data=chs_clean;
    table agegroup* newrace * pcp18/out=freq2 outpct;
	weight wt19_dual;
quit;
 
 
proc sgpanel data=freq;
	panelby agegroup /columns = 3;
    vbar newrace /  
    response=pct_row  /* response= means SGPLOT will plot the summed the values */
    group=didntgetcare18;
    format race;   
	rowaxis label = "Proportion of Not Getting Care";
	colaxis label = "Race";
    run;

proc sgpanel data=freq2;
	panelby agegroup /columns = 3;
    vbar newrace /  
    response=pct_row  /* response= means SGPLOT will plot the summed the values */
    group=pcp18;
    format race; 
	rowaxis label = "Proportion of Having Usual Care Provider";
	colaxis label = "Race";	 
run;

ods rtf close;
