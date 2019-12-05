
FILENAME REFFILE '/folders/myfolders/project/chs_clean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=chs_clean2;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=chs_clean2; RUN;



/*relabeling variables*/

DATA  chs_clean3;
   SET chs_clean2;
   LABEL  didntgetcare18  ="Didn't Get Needed Care"
          newrace    ="Race"
          agegroup = "Age Category"
          birthsex = "Sex"
          education = "Highest Education Attained"
          imputed_neighpovgroup4_1317 = "Neighborhood Poverty Level"
          insure5 = "Insurance Type"
          medcost18 = "Didn't Get Needed Care Due to Cost"
          insured = "Has Insurance"
          pcp18 = "Under Primary Care Provider";
RUN;




proc format;
   value race
   1 = "White Non-Hispanic"
   2 = "Black Non-Hispanic"
   3 = "Hispanic"
   4 = "Asian/Pacific"
   5 = "Other Non-Hispanic"
   ;
run;



PROC CONTENTS DATA=auto2;
RUN;


/* bar chart of ability to get medical care by race*/

proc freq data=chs_clean;
    table agegroup* newrace * didntgetcare18/out=freq outpct;
	weight wt19_dual;
quit;
 
 
proc sgpanel data=freq;
	panelby agegroup /columns = 3;
    vbar newrace /  
    response=pct_row  /* response= means SGPLOT will plot the summed the values */
    group=didntgetcare18;
    format race race.;   
run;
       
       
/* bar chart of ability to get medical care due to cost be race*/

proc freq data=chs_clean3;
    table newrace * medcost18/out=freq_cost outpct;
quit;
 
 
 
proc sgplot data=freq_cost;
    vbar newrace /  
        response=pct_row  /* response= means SGPLOT will plot the summed the values */
        group=medcost18;
       yaxis label='Percent of People WHo did not get needed care in 2018 Due to Cost' labelattrs=(size=12);
       format race;
       run;
 
/* bar chart has a primary care provider */


proc freq data=chs_clean3;
    table newrace * pcp18/out=freq_primary outpct;
quit;
 
 
proc sgplot data=freq_primary;
    vbar newrace /  
        response=pct_row  /* response= means SGPLOT will plot the summed the values */
        group = pcp18;
       yaxis label='Percent of People With Primary Care Provider In 2018' labelattrs=(size=12);
       format race;
       run;
       
       
       
       

/* bar chart has a primary care provider */


proc freq data=chs_clean3;
    table newrace * insure5/out=freq_insure outpct;
quit;
 
 
proc sgplot data=freq_insure;
    vbar newrace /  
        response=pct_row  /* response= means SGPLOT will plot the summed the values */
        group = insure5;
       yaxis label='INsurance Types By Race' labelattrs=(size=12);
       format race;
       run;
       
       
/* insured vs. uninsured */

proc freq data=chs_clean3;
    table newrace * insured/out=freq_insured_or_uninsured outpct;
quit;
 
 
proc sgplot data=freq_insured_or_uninsured;
    vbar newrace /  
        response=pct_row  /* response= means SGPLOT will plot the summed the values */
        group = insured;
       yaxis label='Percent of People Insured By Race' labelattrs=(size=12);
       format race;
       run;
       
       
       

