

/*BADM class SAS notes*/
/* type your code in editor, to run your code: select the code and hit Running man at the top.*/
/*you can comment using  */
/*SAS does not execute the comments. */
/*WORK is a temporary library, everything in it will be deleted once you end your SAS session. So, you should save your data in a 
permanant library you created with libname command. 
Also save your sas code in your flash drive so you can reach it later.*/

/*Creating a library (BADM) in the folder located in " ... " */

libname BADM "\\tsclient\F\BADM742SAS" ;
run;


data A1 ;
set BADM.CRSP ;
if permno = 10001; 
year=year(date); 
month=month(date);
day=day(date);
weekday=weekday(date);
run ; 





Libname BADM "\\tsclient\D\BADM742SAS"; /* each command ends with a semi colon ; */
run; /* we put a run; end of each step we want to run. */






/*create a data set A_data from the orginal data set (CRSP) locate in BADM library. */
data A_data;
set  BADM.CRSP;
if permno =10051; /*conditional statement. Selects observations belongs to permno 10051. */
run; 


data A_data;
set BADM.CRSP;
year=year(date); /*exctracts year from date, */
month=month(date);/*exctracts month from date, */
week=weekday(date);/*exctracts weekday from date, */
day=day(date);      /*exctracts day from date, */


if year = 2018; /*only year 2018 is kept */
run;


data A_data;
set A_data;
run;

proc contents data =A_data; 
run; 

Proc print data= a_data (firstobs=10 obs=25); /*print the observations from 10 to 25 */
run;

proc print data =a_data (firstobs=10 obs=20);
var cusip comnam ret; /*print only these variables*/
run;

data b; /*new dataset created*/
set a; /*original datasey*/
keep cusip year month prc ret vol; /*keep only these variables.*/
run; 


/*Exercise use data CRSP and generate a new dataset
that contains following variables for year 2015: Cusip year month date ret vol shrout*/

data c;
set BADM.CRSP;
year= year(date);
month=month(date);
if year = 2015;
keep Cusip year month date ret vol shrout;
run;


proc means data = c; /*calculate descriptive statistics of specified varaible*/
var ret; /*list of variables */
run; 
 
proc means data = c n mean median std min p1 p5 p25 p50 p75 p95 p99 max ; /* detailed descriptive statistics*/
var ret;
run;

/*name the output variables*/

proc means data =c noprint;
var ret;
output out =cc 
n=nob
mean=ret_avg
median=red_med
min=ret_min
max=ret_max
std=ret_std
p99=ret_p99;
run;


data d;
set c;
month=month(date);
run;

proc sort data = d;
by month;
run;

proc means data = d noprint;
var ret;
by month;
output out=dd
n=nob 
mean=ret_avg
median=ret_md 
min=ret_min
max=ret_max
std=ret_std
p99=ret_p99;
run;

/* Midterm1 */
/*CREATING LIBRARY */
Libname BADM "\\files\users\dath\Documents\BADM742";
run;

/*Create a sample of NYSE listed common stock*/
data MT1 (replace=yes);
set BADM.CRSP;
if shrcd = 10 or shrcd =11;
if exchcd =1 or exchcd =2;
year = year(date);
month = month(date);
if 1995<year<2019;
run;

/*create a data set for Jan */
data jan (replace =yes);
set MT1;
if month=1;
mktval = prc*shrout;
if mktval >0;
if ret >-1;
keep permno year mktval;
run;

/*sort stocks in jan by year and market value*/
proc sort data = jan;
by year mktval;
run;

/*create 10 portfolios based on mktval in each year, name portfolios as port*/
proc rank data = jan out=ports groups=10;
ranks port;
var mktval;
by year;
run;

/*increase port value by 1 and only keep permno year port*/
data ports;
set ports;
port=port+1;
keep permno year port;
run;

/*sort main dataset by permno and year*/
proc sort data=mt1;
by permno year;
run;

/*sort ports1 dataset by permno and year*/
proc sort data=ports;
by permno year;
run;

/* combine datasets by permno and year; delete missing returns and port */
data all (replace =yes);
merge mt1 ports;
by permno year;
if ret = . or port = . then delete;
run;

/*Sort all dataset by year and port*/
proc sort data=all;
by month port;
run;

/*create a dataset that has mean returns for each portfolio in each year*/
proc means data = all noprint;
	var ret;
	by month port;
output out=results  mean=ret_port;
run;

/*Just keep the variables you need for your tests. year port ret_port*/
data results;
set results;
keep month port ret_port;
run;

/*create a dataset for portfolio 1, keep only year and portfolio return in the dataset */
data port1;
set results;
if port=1;
ret_p1=ret_port;
keep month ret_p1;
run;

/*sort portfolio 1 dataset by month*/
proc sort data=port1;
by month;
run;

/*create a dataset for portfolio 10, keep only year and portfolio return in the dataset */
data port10;
set results;
if port=10;
ret_p10=ret_port;
keep month ret_p10;
run;

/*sort portfolio 10 dataset by month*/
proc sort data=port10;
by month;
run;

/*PART TWO - REGRESSION */
/*create dummy variables */
data port1;
set port1;
if month =2 then d2 = 1;
	else d2=0;
if month =3 then d3 = 1;
	else d3=0;
if month =4 then d4 = 1;
	else d4=0;
if month =5 then d5 = 1;
	else d5=0;
if month =6 then d6 = 1;
	else d6=0;
if month =7 then d7 = 1;
	else d7=0;
if month =8 then d8 = 1;
	else d8=0;
if month =9 then d9 = 1;
	else d9=0;
if month =10 then d10 = 1;
	else d10=0;
if month =11 then d11 = 1;
	else d11=0;
if month =12 then d12 = 1;
	else d12=0;
run;

/*
data port10;
set port10;
array dummys {*} 3. d1 - d12;
do i=1 to 12;
dummys(month) = 0;
end;
dummys(1)=1;
run;
*/


data port10;
set port10;
if month =2 then d2 = 1;
	else d2=0;
if month =3 then d3 = 1;
	else d3=0;
if month =4 then d4 = 1;
	else d4=0;
if month =5 then d5 = 1;
	else d5=0;
if month =6 then d6 = 1;
	else d6=0;
if month =7 then d7 = 1;
	else d7=0;
if month =8 then d8 = 1;
	else d8=0;
if month =9 then d9 = 1;
	else d9=0;
if month =10 then d10 = 1;
	else d10=0;
if month =11 then d11 = 1;
	else d11=0;
if month =12 then d12 = 1;
	else d12=0;
run;

/* regression */
proc reg data = port1;
	model ret_p1 = d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12;
run;

