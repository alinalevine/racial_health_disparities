FILENAME REFFILE '/home/u44125038/sasuser.v94/P8123/chs_clean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=chs_clean;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=chs_clean; RUN;


/* pcp 18 */
proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace  (ref = first)   insure5 (ref = first)  imputed_povertygroup (ref = first)  birthsex (ref = first)  agegroup (ref = first)  education (ref = first)  /  param= ref;
model pcp18 (event='1') = newrace insure5 imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;

/* didntgetcare18 */


proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace  (ref = first)   insure5 (ref = first)  imputed_povertygroup (ref = first)  birthsex (ref = first)  agegroup (ref = first)  education (ref = first)  /  param= ref;
model didntgetcare18 (event='1') = newrace insure5 imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;

/* medcost18 */

proc surveylogistic data = chs_clean;
strata strata;
weight wt19_dual;
class newrace  (ref = first)   insure5 (ref = first)  imputed_povertygroup (ref = first)  birthsex (ref = first)  agegroup (ref = first)  education (ref = first)  /  param= ref;
model medcost18 (event='1') = newrace insure5 imputed_povertygroup birthsex agegroup education;
output out = predicted p = predprob;
run;
