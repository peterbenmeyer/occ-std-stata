/* documentation of remapjob.do, in inequality-within-occs project:

Caller sets up these variables and scalar inputs:
 - scalar 'CPSDATA' is zero if data's from Census, one if from CPS
   (data from NLS or PSID could also have this category system but I have
    no experience with them)
 - variable or scalar input 'year' has a number between 1960 and 2010
   from this is created scalar 'Cencode' with 60, 70, 80, 90, or 100
 - existing variable input 'ocsrc' has the input occ category
 - variable output 'ocdest' created here has the standardized code
 - variable 'empstat' is in the source data set.  if 14 or 15, in 1990 the
   individual will be inferred to be in the armed forces.  The 14 or 15
   can appear in the Census but not in the CPS.

 This program is not designed to do a remapping of data with multiple
 years in it.  That would be trickier than this program is.
 This program just detects a year and runs with it.

  -- Peter B Meyer

6/02/06 posted on econterms.net/pbmeyer/research/occs/remapjob.do
4/17/07 comment in occ 479 now properly closed per Matias Scaglione.
7/24/07 fixed missing () when mapping to 905
8/18/07 handled 1970s occs 659 and 999
8/20/07 handled 1970s occ 775 -- 659 and 775 aren't proper, they're bugs in the data from ipums
8/20/07 switched from 'empstatd' name to 'empstat'
8/21/07 in post 2002-CPS, code 984 means armed forces. added that.
12/15/08  replace 873 by 874, to match 1990 census cats.
5/3/12 removed mistaken assignment of 2000 code 373 to category 427; bug discovered by Behzad Kianian of Philadelphia Fed
*/

#delimit ;  /* make ; the end-of-command delimiter for multiline commands */

gen int ocdest=.;        /* occupation; proposed_standard classification */

/* date ranges for occupation/industry definitions in CPS */
scalar Cencode60=0;
scalar Cencode70=0;
scalar Cencode80=0;
scalar Cencode00=0;

if (CPSDATA)
{;
  if (year >= 1968 & year < 1971)
    scalar Cencode60=1;
  if (year >= 1971 & year < 1983)
    scalar Cencode70=1;
  if (year >= 1983)
    scalar Cencode80=1;
  if (year >= 1991)
    scalar Cencode80=2;  /* there were a few redefinitions */
  if (year >= 1995)
    scalar Cencode80=4;  /*  in these years */
  if (year >= 2003)
  {;
    scalar Cencode00=1;
    scalar Cencode80=0;
  };
};

if (CENSUSDATA)  /* if the input data is from Census */
{;
  if (year==1960 | year==96)
    scalar Cencode60=1;
  if (year==1970 | year==97)
    scalar Cencode70=1;
  if (year==1980 | year == 98)
    scalar Cencode80=1;
  if (year==1990 | year == 99)
    scalar Cencode80=2;
  if (year==2000 | year == 100)
    scalar Cencode00=1;
};

/**** remap occupations ****/

/* Legislators */
replace ocdest=3 if
  (Cencode80 & ocsrc==3) |
  (Cencode00 & ocsrc==3);

/* Chief executives and public administrators */
replace ocdest=4 if
  (Cencode60 & ocsrc==270) |
  (Cencode80 & ocsrc==4) |
  (Cencode00 & ocsrc==1);

/* Financial managers */
replace ocdest=7 if
  (Cencode70 & ocsrc==202) |   /* bank officers and financial managers */
  (Cencode70 & ocsrc==210) |   /* credit and collection managers */
  (Cencode80 & ocsrc==7) |
  (Cencode00 & ocsrc==12);

/* Human resources and labor relations managers */
replace ocdest=8 if
  (Cencode80 & ocsrc==8) |
  (Cencode00 & ocsrc==13) ;

/* Managers and specialists in marketing, advertising and public relations */
replace ocdest=13 if
  (Cencode60 & ocsrc==163) |
  (Cencode70 & ocsrc==192) |
  (Cencode70 & ocsrc==231) |  /* sales managers and department heads in retail trade */
  (Cencode70 & ocsrc==233) |  /* sales managers, except retail trade */
  (Cencode80 & ocsrc==13) | (Cencode80 & ocsrc==197) |
  (Cencode00 & ((ocsrc==4)|(ocsrc==5)|(ocsrc==6))) |
  (Cencode00 & ocsrc==282) ;

/* Managers in education and related fields */
replace ocdest=14 if
  (Cencode60 & ocsrc==30) | /* college deans & presidents */
  (Cencode70 & ocsrc==235) |  /* college administrators */
  (Cencode70 & ocsrc==240) |  /* elementary and secondary school administrators */
  (Cencode80 & ocsrc==14) |
  (Cencode00 & ocsrc==23) ;

/* Managers of medicine and health operations */
replace ocdest=15 if
  (Cencode70 & ocsrc==212) |  /* health administrators */
  (Cencode80 & ocsrc==15) |
  (Cencode00 & ocsrc==35);

/* 1971-82   Postmaster and mail superintendents
   1968-70   Postmasters
   1983-2001 Postmasters and mail superintendents */
replace ocdest=16 if
  (Cencode60 & ocsrc==280)   |
  (Cencode70 & ocsrc==224)   |
  (Cencode80==1 & ocsrc==17) |
  (Cencode80>1 & ocsrc==16) |
  (Cencode00 & ocsrc==40) ;

/* Managers of food-serving and lodging establishments */
replace ocdest=17 if
  (Cencode70 & ocsrc==230) |
  (Cencode80>1 & ocsrc==17) |
  (Cencode00 & ocsrc==31) | (Cencode00 & ocsrc==34);

/* Managers of properties & real estate; superintendents; building managers */
replace ocdest=18 if
  (Cencode60 & ocsrc==262) |
  (Cencode70 & ocsrc==216) |
  (Cencode80==1 & ocsrc==16) |
  (Cencode80>1 & ocsrc==18) |
  (Cencode00 & ocsrc==41);

/* Funeral directors */
replace ocdest=19 if
  (Cencode60    & ocsrc==104) |
  (Cencode70    & ocsrc==211) |
  (Cencode80==1 & ocsrc==18) |
  (Cencode80>=2 & ocsrc==19) |
  (Cencode00 & ocsrc==32) ;

/* Managers of service organizations, n.e.c. */
replace ocdest=21 if
  (Cencode80>1 & ocsrc==21) |
  (Cencode00 & ocsrc==33) |    /* gaming managers */
  (Cencode00 & ocsrc==36) |    /* natural science managers */
  (Cencode00 & ocsrc==42) |
  (Cencode00 & ocsrc==72) ;    /* meeting & convention planners */

/* Managers and administrators, n.e.c. */
replace ocdest=22 if
  (Cencode60 & ocsrc==275) |  /* officials of societies and unions */
  (Cencode60 & ocsrc==290) |  /* managers, officials, and proprietors, n.e.c.*/
  (Cencode70 & ocsrc==195) |   /* research workers, not specified */
  (Cencode70 & ocsrc==196) |   /* professional and technical, allocated -- don't know if these exist */
  (Cencode70 & ocsrc==201) |  /* assessors, controllers, and treasurers in local public administration */
  (Cencode70 & ocsrc==220) |  /* office managers, n.e.c. */
  (Cencode70 & ocsrc==222) |  /* public officials and administrators, n.e.c. */
  (Cencode70 & ocsrc==223) |  /* officials of societies and unions */
  (Cencode70 & ocsrc==245) |
  (Cencode70 & ocsrc==246) |  /*managers and administrators, not farm, allocated */
  (Cencode80==1 & ocsrc==19) |
  (Cencode80>1 & ocsrc==22) |
  (Cencode80 & ocsrc==5)  |    /* Public officials and administrators */
  (Cencode00 & ((ocsrc==2)  |
     (ocsrc==10) |    /* administrative services managers */
     (ocsrc==11) |    /* computer and info systems managers */
     (ocsrc==14) |    /* industrial production managers */
     (ocsrc==22) |
     (ocsrc==30) |    /* engineering managers */
     (ocsrc==43) |    /* managers, all other */
     (ocsrc==60) |    /* cost estimators; oddly I can't find a better match */
     (ocsrc==430)));    /* supervisors of gaming workers */

/* Accountants and auditors */
replace ocdest=23 if
  (Cencode60 & ocsrc==0)  |
  (Cencode70 & ocsrc==1)  |
  (Cencode80 & ocsrc==23) |
  (Cencode00 & ocsrc==80) |
  (Cencode00 & ocsrc==93); /* tax examiners, collectors, revenue agents */

/* Insurance underwriters */
replace ocdest=24 if
  (Cencode80 & ocsrc==24) |
  (Cencode00 & ocsrc==86);

/* Other financial specialists */
replace ocdest=25 if
  (Cencode60 & ocsrc==253) |    /* "credit men" */
  (Cencode80 & ocsrc==25) |
  (Cencode00 & ((ocsrc==82) |  /* budget analysts */
    (ocsrc==83) |  /* credit analysts */
    (ocsrc==84) |  /* financial analysts */
    (ocsrc==85) |  /* personal financial advisors */
    (ocsrc==91) |  /* loan advisors and officers */
    (ocsrc==94) |  /* tax preparers */
    (ocsrc==95)));  /* other financial specialists */

/* Management analysts */
replace ocdest=26 if
  (Cencode80 & ocsrc==26) |
  (Cencode00 & ocsrc==71);

/* Personnel, HR, training, and labor relations specialists */
replace ocdest=27 if
  (Cencode80 & ocsrc==27) |
  (Cencode00 & ocsrc==62);

/* Purchasing agents and buyers, farm products */
replace ocdest=28 if
  (Cencode60 & ocsrc==251) |
  (Cencode70 & ocsrc==203) |
  (Cencode80 & ocsrc==28) |
  (Cencode00 & ocsrc==51);

/* Buyers, wholesale and retail trade */
replace ocdest=29 if
  (Cencode60 & ocsrc==250) |
  (Cencode70 & ocsrc==205) |
  (Cencode80 & ocsrc==29) |
  (Cencode00 & ocsrc==52);

/* Purchasing managers, agents and buyers, nec */
replace ocdest=33 if
  (Cencode60 & ocsrc==285) |
  (Cencode70 & ocsrc==225) |
  (Cencode80 & ((ocsrc==9) | (ocsrc==33)))  |
  (Cencode00 & ((ocsrc==15) | (ocsrc==53)));

/* Business and promotion agents */
replace ocdest=34 if
  (Cencode80 & ocsrc==34) |
  (Cencode00 & ocsrc==50);

/* Construction inspectors */
replace ocdest=35 if
  (Cencode70 & ocsrc==213) |  /* construction inspectors in public administration */
  (Cencode80 & ocsrc==35) |
  (Cencode00 & ocsrc==666);

/* Inspectors and compliance officers, outside constructions */
replace ocdest=36 if
  (Cencode60 & ocsrc==260) |
  (Cencode70 & ocsrc==215) |   /* inspectors, except construction, in public administration */
  (Cencode80 & ocsrc==36) |
  (Cencode00 & ((ocsrc==56) | (ocsrc==90)));

/* Management related jobs (e.g. support) */
replace ocdest=37 if
  (Cencode80 & ocsrc==37) |
  (Cencode00 & ocsrc==73);     /* other business operations specialists */

/* Architects */
replace ocdest=43 if
  (Cencode60 & ocsrc==13)  |
  (Cencode70 & ocsrc==2)   |
  (Cencode80 & ocsrc==43)  |
  (Cencode00 & ocsrc==130); /* Architects, exc.naval */

/* Aerospace engineers */
replace ocdest=44 if
  (Cencode60 & ocsrc==80) |
  (Cencode70 & ocsrc== 6) |
  (Cencode80 & ocsrc==44) |
  (Cencode00 & ocsrc==132);

/* Metallurgical and materials engineers, variously phrased */
replace ocdest=45 if
  (Cencode60 & ocsrc==90) |
  (Cencode70 & ocsrc==15) |
  (Cencode80 & ocsrc==45) |
  (Cencode00 & ocsrc==145);   /* materials engineers */

/* Petroleum and mining engineers */
replace ocdest=47 if
  (Cencode60 & ocsrc==91)  |
  (Cencode70 & ocsrc==21)  |
  (Cencode80 & ocsrc==47)  |
  (Cencode00 & ocsrc==152);   /* Petroleum, mining, mining safety, and geological engrs */

/* Chemical engineers */
replace ocdest=48 if
  (Cencode60 & ocsrc==81)  |
  (Cencode70 & ocsrc==10)  |
  (Cencode80 & ocsrc==48)  |
  (Cencode00 & ocsrc==135);
 
/* Civil engineers */
replace ocdest=53 if
  (Cencode60 & ocsrc==82)  |
  (Cencode70 & ocsrc==11)  |
  (Cencode80 & ocsrc==53)  |
  (Cencode00 & ocsrc==136);

/* Electrical engineers */
replace ocdest=55 if
  (Cencode60 & ocsrc==83) |
  (Cencode70 & ocsrc==12) |
  (Cencode80 & ocsrc==55) |
  (Cencode00 & ocsrc ==140) | /* computer hardware engrs */
  (Cencode00 & ocsrc ==141);  /* elect &electronic engrs */

/* Industrial engineers */
replace ocdest=56 if
  (Cencode60 & ocsrc==84) |
  (Cencode70 & ocsrc==13) |
  (Cencode80 & ocsrc==56) |
  (Cencode00 & ocsrc==143);    /* IEs, including health and safety */

/* Mechanical engineers */
replace ocdest=57 if
  (Cencode60 & ocsrc==85) |
  (Cencode70 & ocsrc==14) |
  (Cencode80 & ocsrc==57) |
  (Cencode00 & ocsrc==146);

/* Engineers not elsewhere classified , including
   agricultural, geological, petroleum, mining, nuclear, environmental,
   marine, naval, and sometimes safety (small categories) */
replace ocdest=59 if
  (Cencode60 & ((ocsrc==93))) |
  (Cencode70 & ((ocsrc==20) | (ocsrc==23))) |
  (Cencode80 & ((ocsrc==49))) |    /* nuclear engineer */
  (Cencode80 & ((ocsrc==46)|(ocsrc==54)|(ocsrc==58)|(ocsrc==59))) |
  (Cencode00 & ((ocsrc==133)|(ocsrc==134)|(ocsrc==142)|(ocsrc==144)|
   (ocsrc==150)|(ocsrc==151)|(ocsrc==152)|(ocsrc==153)));

/* Computer systems analysts, administrators, and scientists */
replace ocdest=64 if
  (Cencode70 & ocsrc==4) |
  (Cencode70 & ocsrc==5) |      /* computer specialists, nec */
  (Cencode80 & ocsrc==64) |
  (Cencode00 & ((ocsrc==104)|(ocsrc==106)|(ocsrc==110)|(ocsrc==111))) |
        /* Computer system administrators and support */
  (Cencode00 & ocsrc==100); /* Computer scientists and system analysts */

/* Operations and systems researchers and analysts  */
replace ocdest=65 if
  (Cencode70 & ocsrc==55) |
  (Cencode80 & ocsrc==65) |    /* OR & systems researchers and analysts */
  (Cencode00 & ocsrc==70) |    /* Logisticians */
  (Cencode00 & ocsrc==122);   /* Operations research analysts*/

/* Actuaries */
replace ocdest=66 if
  (Cencode70 & ocsrc==34) |
  (Cencode80 & ocsrc==66)  |
  (Cencode00 & ocsrc==120);

/* Statisticians */
replace ocdest=67 if
  (Cencode60 & ocsrc==174) |  /* statisticians and actuaries (mostly stats) */
  (Cencode70 & ocsrc==36) |
  (Cencode80 & ocsrc==67) |
  (Cencode00 & ocsrc==123);

/* Mathematical scientists and mathematicians */
replace ocdest=68 if
  (Cencode60 & ocsrc==135) | (Cencode70 & ocsrc==35) |
  (Cencode80 & ocsrc==68)  |
  (Cencode00 & ocsrc==121) |   /* mathematicians */
  (Cencode00 & ocsrc==124);    /* misc mathematical scientists */

/* Physicists and astronomers [but excluding astronomers in Cencode60] */
replace ocdest=69 if
  (Cencode60 & ocsrc==140) |
  (Cencode70 & ocsrc==053) |
  (Cencode80 & ocsrc==69)  |
  (Cencode00 & ocsrc==170);

/* Chemists, excluding biochemists after 1983 */
replace ocdest=73 if 
  (Cencode60 & ocsrc==21) | 
  (Cencode70 & ocsrc==45) |
  (Cencode80 & ocsrc==73) |
  (Cencode00 & ocsrc==172);

/* Atmospheric and space scientists */
replace ocdest=74 if 
  (Cencode70 & ocsrc==043) |
  (Cencode80 & ocsrc==74 ) |
  (Cencode00 & ocsrc==171);

/* Geologists ["and geodesists", post 1982; "and geophysicists", 1968-70] */
replace ocdest=75 if
  (Cencode60 & ocsrc==134) |
  (Cencode70 & ocsrc==51)  |
  (Cencode80 & ocsrc==75)  |
  (Cencode00 & ocsrc==152) |
  (Cencode00 & ocsrc==174);    /* enviro scientists and geoscientists */

/* Physical scientists, n.e.c. */
replace ocdest=76 if
  (Cencode60 & ocsrc==145) |
  (Cencode70 & ocsrc==54) |  /* life and physical scientists, nec */
  (Cencode80 & ocsrc==76) |  /* physical scientists, nec */
  (Cencode00 & ocsrc==176);

/* Agricultural and food scientists */
replace ocdest=77 if
  (Cencode60 & ocsrc==130) |
  (Cencode70 & ocsrc==042) |
  (Cencode80 & ocsrc==77)  |
  (Cencode00 & ocsrc==160);

/* Biological scientists */
replace ocdest=78 if
  (Cencode60 & ocsrc==131) |
  (Cencode70 & ocsrc==44)  |
  (Cencode70 & ocsrc==52)  |  /* marine scientists */
  (Cencode80 & ocsrc==78)  |
  (Cencode00 & ocsrc==161);

/* Foresters and conservation scientists [or conservationists] */
replace ocdest=79 if
  (Cencode60 & ocsrc==103) |
  (Cencode70 & ocsrc==025) |
  (Cencode80 & ocsrc==79)  |
  (Cencode00 & ocsrc==164);

/* Medical scientists */
replace ocdest=83 if
  (Cencode80 & ocsrc==83) | 
  (Cencode00 & ocsrc==165);

/* Physicians  ["medical and osteopathic" in Cencode70;
                 mixed with surgeons in Cencode60 */
replace ocdest=84 if
  (Cencode60 & ocsrc==153) |  /* osteopaths */
  (Cencode60 & ocsrc==162) |
  (Cencode70 & ocsrc==065) |
  (Cencode80 & ocsrc==84)  |
  (Cencode00 & ocsrc==306);  /* Physicians and surgeons */

/* Dentists */
replace ocdest=85 if
  (Cencode60 & ocsrc== 71) |
  (Cencode70 & ocsrc== 62) |
  (Cencode80 & ocsrc== 85) |
  (Cencode00 & ocsrc==301);

/* Veterinarians */
replace ocdest=86 if
  (Cencode60 & ocsrc==194) |
  (Cencode70 & ocsrc==72)  |
  (Cencode80 & ocsrc==86)  |
  (Cencode00 & ocsrc==325);

/* Optometrists */
replace ocdest=87 if
  (Cencode60 & ocsrc==152) |
  (Cencode70 & ocsrc==063) |
  (Cencode80 & ocsrc==87)  |
  (Cencode00 & ocsrc==304);

/* Podiatrists */
replace ocdest=88 if
  (Cencode70 & ocsrc==71) |
  (Cencode80 & ocsrc==88) |
  (Cencode00 & ocsrc==312);

/* Other health and therapy jobs */
replace ocdest=89 if
  (Cencode60 & ocsrc==22) |   /* chiropractors */
  (Cencode60 & ocsrc==840) |  /* midwives (N=20) */
  (Cencode70 & ocsrc==61) |   /* chiropractors (N=168) */
  (Cencode70 & ocsrc==73) |   /* health practitioners, nec (N=15) */
  (Cencode70 & ocsrc==924) |  /* midwives */
  (Cencode80 & ocsrc==89) |   /* health diagnosing practitioners, nec */
  (Cencode00 & ocsrc==300) |  /* chiropractors */
  (Cencode00 & ocsrc==326);   /* other health diagnosis & treatment */

/* Registered nurses */
replace ocdest=95 if
  (Cencode60 & ocsrc==150) |
  (Cencode70 & ocsrc==75)  |
  (Cencode70 & ocsrc==923)  |  /* health trainers */
  (Cencode80 & ocsrc==95)  |
  (Cencode00 & ocsrc==313);

/* Pharmacists */
replace ocdest=96 if
  (Cencode60 & ocsrc==160) |
  (Cencode70 & ocsrc== 64) |
  (Cencode80 & ocsrc== 96) |
  (Cencode00 & ocsrc==305);

/* Dietitians & nutritionists */
replace ocdest=97 if
  (Cencode60 & ocsrc==73) |
  (Cencode70 & ocsrc==74) |
  (Cencode80 & ocsrc==97) |
  (Cencode00 & ocsrc==303);

/* Respiratory therapists */
replace ocdest=98 if
  (Cencode80 & ocsrc==98) |
  (Cencode00 & ocsrc==322);

/* Occupational therapists */
replace ocdest=99 if
  (Cencode80 & ocsrc== 99) |
  (Cencode00 & ocsrc==315) |
  (Cencode00 & ocsrc==361);    /* occ therapists assts and aides */

/* Physical therapists */
replace ocdest=103 if
  (Cencode80 & ocsrc==103) |
  (Cencode00 & ocsrc==316) |
  (Cencode00 & ocsrc==362);    /* phys therapists assts and aides */

/* Speech therapists */
replace ocdest=104 if
  (Cencode80 & ocsrc==104) |   /* speech therapists */
  (Cencode00 & ocsrc==314) |   /* audiologists */
  (Cencode00 & ocsrc==323);    /* speech language pathologists */

/* Therapists, n.e.c. */
replace ocdest=105 if
  (Cencode60 & ocsrc==193) |   /* therapists and healers, nec */
  (Cencode70 & ocsrc==76)  |   /* therapists */
  (Cencode70 & ocsrc==84)  |   /* therapist assistants */
  (Cencode80 & ocsrc==105) |   /* therapists, n.e.c. */
  (Cencode00 & ocsrc==320) |   /* radiation therapists */
  (Cencode00 & ocsrc==321) |   /* recreational therapists */
  (Cencode00 & ocsrc==324);    /* therapists, all other */

/* Physicians' assistants */
replace ocdest=106 if
  (Cencode80 & ocsrc==106) |
  (Cencode00 & ocsrc==311);

/* Earth, environmental, and marine science instructors at college level */
replace ocdest=113 if
  (Cencode60 & ocsrc==41) |  /* geology */
  (Cencode70 & ocsrc==103) | /* earth, marine, atmosphere, and space */
  (Cencode80 & ocsrc==113);  /* earth, environ, and marine sci teachers */

 /* Biological science teachers at college level */
replace ocdest=114 if
  (Cencode60 & ocsrc==32) |
  (Cencode70 & ocsrc==104) |
  (Cencode80 & ocsrc==114);

/* Chemistry teachers, postsecondary ["college level", pre-1983] */
replace ocdest=115 if
  (Cencode60 & ocsrc==34)  |
  (Cencode70 & ocsrc==105) |
  (Cencode80 & ocsrc==115);

/* Physics instructors or professors */
replace ocdest=116 if
  (Cencode60 & ocsrc==045) |
  (Cencode70 & ocsrc==110) |
  (Cencode80 & ocsrc==116);

/* Psychology instructors */
replace ocdest=118 if
  (Cencode60 & ocsrc==50) |  /* psych */
  (Cencode70 & ocsrc==114) | /* psych */
  (Cencode80 & ocsrc==118);  /* psych */

/* Economics instructors, college */
replace ocdest=119 if
  (Cencode60 & ocsrc==35)  |
  (Cencode70 & ocsrc==116)  |
  (Cencode80 & ocsrc==119);

/* History postsecondary teachers */
replace ocdest=123 if
  (Cencode70 & ocsrc==120) | 
  (Cencode80 & ocsrc==123);

/* Postsecondary teachers of sociology */
replace ocdest=125 if
  (Cencode70 & ocsrc==121) |
  (Cencode80 & ocsrc==125);

/* Engineering profs/instructors */
replace ocdest=127 if
  (Cencode60 & ocsrc==040) |
  (Cencode70 & ocsrc==111) |
  (Cencode80 & ocsrc==127);

/* Math instructors, college */
replace ocdest=128 if
  (Cencode60 & ocsrc==42)  |
  (Cencode60 & ocsrc==51)  |  /* stats */
  (Cencode70 & ocsrc==112) |
  (Cencode80 & ocsrc==128);

/* Postsecondary teachers of education */
replace ocdest=139 if
  (Cencode70 & ocsrc==125) |
  (Cencode80 & ocsrc==139);

/* Teachers of law, generally postsecondary */
replace ocdest=145 if
  (Cencode70 & ocsrc==132) |
  (Cencode80 & ocsrc==145);

/* Theology teachers, college */
replace ocdest=147 if
  (Cencode70 & ocsrc==133) |
  (Cencode80 & ocsrc==147);

/* Home economics postsecondary teachers */
replace ocdest=149 if
  (Cencode70 & ocsrc==131) |
  (Cencode80 & ocsrc==149);

/* Humanities profs/instructors, college, nec */
replace ocdest=150 if
  (Cencode60 & ocsrc==54);

/* Other academic subject instructors, mostly college */
replace ocdest=154 if
  (Cencode60 & ocsrc==31) | /* ag instructors */
  (Cencode60 & ocsrc==43) | /* medicine */
  (Cencode60 & ocsrc==52) | /* nat sci, nec */
  (Cencode60 & ocsrc==53) | /* soc sci */
  (Cencode60 & ocsrc==60) | /* n.e.c. */
  (Cencode70 & ocsrc==102) | /* ag teachers */
  (Cencode70 & ocsrc==113) | /* health specialities teachers */
  (Cencode70 & ocsrc==115) | /* biz and commerce */
  (Cencode70 & ocsrc==122) | /* soc sci, I think */
  (Cencode70 & ocsrc==123) | /* */
  (Cencode70 & ocsrc==124) | /* */
  (Cencode70 & ocsrc==126) | /* */
  (Cencode70 & ocsrc==130) | /* */
  (Cencode70 & ocsrc==134) | /* */
  (Cencode70 & ocsrc==135) | /* */
  (Cencode70 & ocsrc==140) | /* */
  (Cencode80 & (
   (ocsrc==117) |  /* nat sci */
   (ocsrc==124) |
   (ocsrc==126) |  /* soc sci */
   (ocsrc==129) |
   (ocsrc==133) |  /* medicine */
   (ocsrc==134) |
   (ocsrc==135) |
   (ocsrc==136) |  /* ag, I think */
   (ocsrc==137) | (ocsrc==138) |
   (ocsrc==143) | (ocsrc==144) |
   (ocsrc==146) | (ocsrc==148) |
   (ocsrc==153) | (ocsrc==154))) |
  (Cencode00 & ocsrc==220);

/* Kindergarten and earlier school teachers */
replace ocdest=155 if
  (Cencode70 & ocsrc==143) |
  (Cencode80 & ocsrc==155) |
  (Cencode00 & ocsrc==230);  /* preschool and kindergarten */

/* Primary school teachers */
replace ocdest=156 if
  (Cencode60 & ocsrc==182) |  /*elementary*/
  (Cencode70 & ocsrc==142) |
  (Cencode80 & ocsrc==156) |
  (Cencode00 & ocsrc==231);

/* Secondary school teachers */
replace ocdest=157 if
  (Cencode60 & ocsrc==183) |
  (Cencode70 & ocsrc==144) |
  (Cencode80 & ocsrc==157) |
  (Cencode00 & ocsrc==232);

/* Special education teachers */
replace ocdest=158 if
  (Cencode80 & ocsrc==158) |
  (Cencode00 & ocsrc==233);

/* Teachers, n.e.c. */
replace ocdest=159 if
  (Cencode60 & ocsrc==184) |  /*n.e.c.*/
  (Cencode70 & ocsrc==141) | /* */
  (Cencode70 & ocsrc==145) |
  (Cencode80 & ocsrc==159) |
  (Cencode00 & ocsrc==234) |
  (Cencode00 & ((ocsrc==254) | (ocsrc==255)));

/* Vocational and educational counselors */
replace ocdest=163 if
  (Cencode70 & ocsrc==174) |
  (Cencode80 & ocsrc==163) |
  (Cencode00 & ocsrc==200);

/* Librarians */
replace ocdest=164 if (Cencode60 & ocsrc==111)  |
  (Cencode70 & ocsrc==32)  |
  (Cencode80 & ocsrc==164) |
  (Cencode00 & ocsrc==243);

/* Archivists and curators */
replace ocdest=165 if
  (Cencode70 & ocsrc==33)  |
  (Cencode80 & ocsrc==165) |
  (Cencode00 & ocsrc==240);

/* Economists, market researchers, and survey researchers */
replace ocdest=166 if
  (Cencode60 & ocsrc==172) |
  (Cencode70 & ocsrc==91)  |
  (Cencode80 & ocsrc==166) |
  (Cencode00 & ocsrc==180) |   /* economists */
  (Cencode00 & ocsrc==181);    /* market and survey researcers */

/* Psychologists */
replace ocdest=167 if
  (Cencode60 & ocsrc==173) |
  (Cencode70 & ocsrc==93) |
  (Cencode80 & ocsrc==167) |
  (Cencode00 & ocsrc==182);

/* Sociologists */
replace ocdest=168 if
  (Cencode70 & ocsrc==094) |
  (Cencode80 & ocsrc==168) |
  (Cencode00 & ocsrc==183);    /* sociologists */

/* Social scientists, n.e.c. */
replace ocdest=169 if
  (Cencode60 & ocsrc==102) |  /* farm and home mgmt advisors */
  (Cencode60 & ocsrc==175) |  /* misc soc sci */
  (Cencode70 & ocsrc==24)  |
  (Cencode70 & ocsrc==26)  |
  (Cencode70 & ocsrc==92)  |  /* political scientists */
  (Cencode70 & ocsrc==96)  |  /* soc sci nec */
  (Cencode80 & ocsrc==169)  |
  (Cencode00 & ocsrc==186);   /* misc social scientists */

/* Urban and regional planners */
replace ocdest=173 if
  (Cencode70 & ocsrc==095) |
  (Cencode80 & ocsrc==173) |
  (Cencode00 & ocsrc==184);

/* Social workers */
replace ocdest=174 if
  (Cencode60 & ocsrc==171) |  /* social and welfare workers */
  (Cencode70 & ocsrc==100) |
  (Cencode80 & ocsrc==174) |
  (Cencode00 & ocsrc==201);

/* Recreation workers */
replace ocdest=175 if
  (Cencode60 & ocsrc==165) |
  (Cencode70 & ocsrc==101) |
  (Cencode80 & ocsrc==175) |
  (Cencode00 & ocsrc==462);

/* Clergy and religious workers */
replace ocdest=176 if
  (Cencode60 & ocsrc==23)  |
  (Cencode60 & ocsrc==170) |
  (Cencode70 & ocsrc==86)  |
  (Cencode70 & ocsrc==90)  |
  (Cencode80 & ocsrc==176) |
  (Cencode80 & ocsrc==177) |
  (Cencode00 & ocsrc==204) |
  (Cencode00 & ocsrc==205) |
  (Cencode00 & ocsrc==206);

/* Lawyers */
replace ocdest=178 if
  (Cencode60 & ocsrc==105) |
  (Cencode70 & ocsrc==31)  |
  (Cencode80 & ocsrc==178) |
  (Cencode00 & ocsrc==210);

/* Judges */
replace ocdest=179 if
  (Cencode70 & ocsrc==30)  |
  (Cencode80 & ocsrc==179) |
  (Cencode00 & ocsrc==211);  /* Judges, magistrates, and other judicial workers */

/* Writers and authors */
replace ocdest=183 if
  (Cencode60 & ocsrc==20) |
  (Cencode70 & ocsrc==181) |
  (Cencode80 & ocsrc==183) |
  (Cencode00 & ocsrc==285);

/* Technical writers */
replace ocdest=184 if
  (Cencode80 & ocsrc==184) |
  (Cencode00 & ocsrc==284);

/* Designers */
replace ocdest=185 if
  (Cencode60 & ocsrc==72) |
  (Cencode70 & ocsrc==183) |
  (Cencode70 & ocsrc==425) |  /* decorators and window dressers */
  (Cencode80 & ocsrc==185) |
  (Cencode00 & ocsrc==263);

/* Musician or composer */
replace ocdest=186 if
  (Cencode60 & ocsrc==120) |
  (Cencode70 & ocsrc==185) |
  (Cencode80 & ocsrc==186) |
  (Cencode00 & ocsrc==275); /* Musicians, singers,and related workers */

/* Actors, directors, producers */
replace ocdest=187 if
  (Cencode60 & ocsrc== 10) | /* actor/director-past'83 */
  (Cencode70 & ocsrc==175) |
  (Cencode80 & ocsrc==187) |
  (Cencode00 & ocsrc==270) | /* Actors */
  (Cencode00 & ocsrc==271);  /* Producers & directors */

/* Art-makers: painters, sculptors, craft-artists, and print-makers,
   and sometimes art teachers */
replace ocdest=188 if
  (Cencode60 & ocsrc==14) |
  (Cencode70 & ocsrc==190) |
  (Cencode80 & ocsrc==188) |
  (Cencode00 & ocsrc==260);

/* Photographers */
replace ocdest=189 if
  (Cencode60 & ocsrc==161) |
  (Cencode70 & ocsrc==191) |
  (Cencode80 & ocsrc==189) |
  (Cencode00 & ocsrc==291);

/* Dancers */
replace ocdest=193 if
  (Cencode60 & ocsrc==70)  |
  (Cencode70 & ocsrc==182)  |
  (Cencode80 & ocsrc==193) |
  (Cencode00 & ocsrc==274); /* ... and choreographers */

/* Art/entertainment performers and related */
replace ocdest=194 if
  (Cencode60 & ocsrc==101) |
  (Cencode70 & ocsrc==194) |  /* writers, artists, and entertainers, n.e.c. */
  (Cencode80 & ocsrc==194) |
  (Cencode00 & ocsrc==276) |
  (Cencode00 & ocsrc==286);    /* misc media and communications wkrs */

/* Editors and reporters */
replace ocdest=195 if
  (Cencode60 & ocsrc==75) |
  (Cencode70 & ocsrc==184) |
  (Cencode80 & ocsrc==195) |
  (Cencode00 & ocsrc==281) |  /* News analysts,reporters,correspondents */
  (Cencode00 & ocsrc==283) |  /* Editors */
  (Cencode00 & ocsrc==292);   /* TV video, and motion picture camera */
                                 /* operators and editors -- yes, they go */
                                 /* here, according to the 1990-2000 table */
/* Announcers */
replace ocdest=198 if
  (Cencode70 & ocsrc==193) |  /* radio and tv announcers */
  (Cencode80 & ocsrc==198) |
  (Cencode00 & ocsrc==280);

/* Athletes, sports instructors, and officials */
replace ocdest=199 if
  (Cencode60 & ocsrc==15)  |   /* N=52 */
  (Cencode60 & ocsrc==180) |  /* sports instructors and officials, N=993 */
  (Cencode70 & ocsrc==180) |
  (Cencode80 & ocsrc==199) |
  (Cencode00 & ocsrc==272) | /* Athletes, coaches, umpires, and related */
  (Cencode00 & ocsrc==752);  /* commercial divers */

/* Professionals n.e.c. */
replace ocdest=200 if
  (Cencode60 & ocsrc==195);  /* prof & tech, nec */

/* Clinical laboratory technologists and technicians */
replace ocdest=203 if
  (Cencode60 & ocsrc==185) | /* medical and dental techs; possibly better fit is 208 or 678 */
  (Cencode70 & ocsrc== 80) |
  (Cencode80 & ocsrc==203) |
  (Cencode00 & ocsrc==330);

/* Dental hygenists */
replace ocdest=204 if
  (Cencode70 & ocsrc==081) |
  (Cencode80 & ocsrc==204) |
  (Cencode00 & ocsrc==331);

/* Health record technologists and technicians */
replace ocdest=205 if
  (Cencode70 & ocsrc==82) |
  (Cencode80 & ocsrc==205) |
  (Cencode00 & ocsrc==351);

/* Radiologic technologists and technicians */
replace ocdest=206 if
  (Cencode70 & ocsrc==083) |
  (Cencode80 & ocsrc==206) |
  (Cencode00 & ocsrc==332);

/* [Licensed] practical nurses */
replace ocdest=207 if
  (Cencode60 & ocsrc==842) |
  (Cencode70 & ocsrc==926) |
  (Cencode80 & ocsrc==207) |
  (Cencode00 & ocsrc==350);

/* Health technologists and technicians, n.e.c. */
replace ocdest=208 if
  (Cencode70 & ocsrc==85) |
  (Cencode80 & ocsrc==208) |
  (Cencode00 & ocsrc==340) |   /* emergency medical techs & paramedics */
  (Cencode00 & ocsrc==353) |
  (Cencode00 & ocsrc==354);

/* Electrical and electronic [engineering] technicians */
replace ocdest=213 if
  (Cencode60 & ocsrc==190) |
  (Cencode70 & ocsrc==153) |
  (Cencode80 & ocsrc==213);

/* Engineering technicians, n.e.c.  */
replace ocdest=214 if
  (Cencode70 & ocsrc==154) |
  (Cencode70 & ocsrc==162) |
  (Cencode80 & ocsrc==214) |
  (Cencode80 & ocsrc==216) |
  (Cencode00 & ocsrc==155) | /* Engineering technicians, except drafters */
  (Cencode00 & ocsrc==196);  /* life, physical, and soc sci techs -- */
                                /* oddly the Census 1990/2000 says most of */
                                /* those go here not to sci techs (225). */
/* Mechanical engineering technicians */
replace ocdest=215 if
  (Cencode70 & ocsrc==155) |
  (Cencode80 & ocsrc==215);

/* Drafters */
replace ocdest=217 if
  (Cencode60 & ocsrc==74)  |      /* draftsmen */
  (Cencode70 & ocsrc==152) |
  (Cencode80 & ocsrc==217) |
  (Cencode00 & ocsrc==154);   /* Drafters */

/* Surveyors, cartographers, mapping scientists and technicians */
replace ocdest=218 if
  (Cencode60 & ocsrc==181) |
  (Cencode60 & ocsrc==642) |  /* chainmen, rodmen, and axmen, surveying */
  (Cencode70 & ocsrc==161) |
  (Cencode80 & ocsrc==63)  |   /* Surveyors and mapping scientists */
  (Cencode80 & ocsrc==218) |
  (Cencode80 & ocsrc==867) |
  (Cencode00 & ocsrc==131) | /* Surv.., cart.., and photogrammetrists */
  (Cencode00 & ocsrc==156);  /* Surveying & mapping techs */

/* Biological and agricultural technicians */
replace ocdest=223 if
  (Cencode70 & ocsrc==150) | /* ag and bio techs */
  (Cencode80 & ocsrc==223) |
  (Cencode00 & ((ocsrc==190)|   /* ag and food science techs */
     (ocsrc==191)));

/* Chemical technicians */
replace ocdest=224 if
  (Cencode70 & ocsrc==151) |
  (Cencode80 & ocsrc==224) |
  (Cencode00 & ocsrc==192);

/* Other science technicians */
replace ocdest=225 if
  (Cencode60 & ocsrc==191) |
  (Cencode70 & ocsrc==156) |
  (Cencode80 & ocsrc==225) |   /* science technicians, n.e.c. */
  (Cencode00 & ocsrc==193);

/* Airplane pilots and navigators */
replace ocdest=226 if
  (Cencode60 & ocsrc==012) |
  (Cencode70 & ocsrc==163) |
  (Cencode70 & ocsrc==170) |   /* flight engineers */
  (Cencode80 & ocsrc==226) |
  (Cencode00 & ocsrc==903);

/* Air traffic controllers */
replace ocdest=227 if
  (Cencode70 & ocsrc==164) |
  (Cencode80 & ocsrc==227) |
  (Cencode00 & ocsrc==904);

/* Broadcast equipment operators */
replace ocdest=228 if
  (Cencode60 & ocsrc==164) |
  (Cencode70 & ocsrc==171) |  /* radio operators */
  (Cencode80 & ocsrc==228) |
  (Cencode00 & ocsrc==290) |   /* tho many map to technicians, n.e.c. */
  (Cencode00 & ocsrc==296); /* media and communications workers, all other */

/* Computer software developers */
replace ocdest=229 if
  (Cencode70 & ocsrc==3) |
  (Cencode80 & ocsrc==229) |
  (Cencode00 & ocsrc==101) | /* computer programmers */
  (Cencode00 & ocsrc==102); /* computer software engineers */

/* Programmers of numerically controlled machine tools */
replace ocdest=233 if
  (Cencode70 & ocsrc==172) |
  (Cencode80 & ocsrc==233) |
  (Cencode00 & ocsrc==790);

/* Legal assistants, paralegals, legal support, etc */
replace ocdest=234 if
  (Cencode80 & ocsrc==234) |
  (Cencode00 & ((ocsrc==214) | (ocsrc==215)));

/* Technicians, n.e.c. */
replace ocdest=235 if
  (Cencode60 & ocsrc==192) |
  (Cencode70 & ocsrc==165) |   /* embalmers */
  (Cencode70 & ocsrc==173) |   /* technicians, n.e.c. */
  (Cencode80 & ocsrc==235) |
  (Cencode00 & ocsrc==194);  /* nuclear technicians */

/* Supervisors and proprietors of sales jobs */
replace ocdest=243 if
  (Cencode60 & ocsrc==254) |
  (Cencode80 & ocsrc==243) |
  (Cencode00 & ((ocsrc==470)|(ocsrc==471)));    /* supvs of sales */

/* Insurance sales occupations
   pre-1983: Insurance agents, brokers and underwriters */
replace ocdest=253 if
  (Cencode60 & ocsrc==385) |
  (Cencode70 & ocsrc==265) |
  (Cencode80 & ocsrc==253) |
  (Cencode00 & ocsrc==481);

/* Real estate sales occupations ["agents and brokers", pre-1983] */
replace ocdest=254 if
  (Cencode60 & ocsrc==393) |
  (Cencode70 & ocsrc==270) |
  (Cencode70 & ocsrc==363) |/* Real estate appraisers */
  (Cencode80 & ocsrc==254) |
  (Cencode00 & ocsrc==81)  | /* Real estate appraisers */
  (Cencode00 & ocsrc==492);

/* Financial sales occupations */
replace ocdest=255 if
  (Cencode60 & ocsrc==395) | /* 1968-1982   Stock and bond sales agents */
  (Cencode70 & ocsrc==271) |
  (Cencode80 & ocsrc==255) | /* 1983- Securities & financial services sales occupations */
  (Cencode00 & ocsrc==482);

/* Advertising and related sales jobs */
replace ocdest=256 if
  (Cencode60 & ocsrc==380) | /* ad agents and sales */
  (Cencode70 & ocsrc==260) | /* ad agents and sales workers */
  (Cencode80 & ocsrc==256) | /* advertising and related sales occupations */
  (Cencode00 & ocsrc==480);

/* Sales engineers */
replace ocdest=258 if
  (Cencode60 & ocsrc==92) |
  (Cencode70 & ocsrc==022) |
  (Cencode80 & ocsrc==258) |
  (Cencode00 & ocsrc==493) ;

/* Sales occupations, n.e.c. */
/* n.e.c. sales and related, 263-274 in 1990 Census; includes auctioneers */
replace ocdest=274 if
  (Cencode60 & ocsrc==301) |
  (Cencode60 & ocsrc==381) |
  (Cencode60 & ocsrc==383) |
  (Cencode60 & ocsrc==394) |
  (Cencode70 & ocsrc==261) |
  (Cencode70 & ocsrc==280) |  /* salesmen and sales clerks, n.e.c. */
  (Cencode70 & ocsrc==281) |
  (Cencode70 & ocsrc==282) |
  (Cencode70 & ocsrc==284) |
  (Cencode70 & ocsrc==285) |
  (Cencode70 & ocsrc==296) |
  (Cencode80 & ocsrc==257) |
  (Cencode80 & ocsrc==259) |
  (Cencode80 & ocsrc==263) |
  (Cencode80 & ocsrc==264) |
  (Cencode80 & ocsrc==265) |
  (Cencode80 & ocsrc==266) |
  (Cencode80 & ocsrc==267) |
  (Cencode80 & ocsrc==268) |
  (Cencode80 & ocsrc==269) |
  (Cencode80 & ocsrc==274) |
  (Cencode80 & ocsrc==284) |
  (Cencode80 & ocsrc==285) |
  (Cencode00 & ((ocsrc==474)|(ocsrc==475)|(ocsrc==476)|(ocsrc==484) |
                (ocsrc==485) | (ocsrc==494) | (ocsrc==496)));

/* Retail sales clerks */
replace ocdest=275 if
  (Cencode70 & ocsrc==283) |
  (Cencode70 & ocsrc==314) |   /* counter clerks, except food */
  (Cencode80 & ocsrc==275) |
  (Cencode00 & ocsrc==476);

/* Cashiers */
replace ocdest=276 if
  (Cencode60 & ocsrc==312) |
  (Cencode70 & ocsrc==310) |
  (Cencode80 & ocsrc==276) |
  (Cencode00 & ocsrc==472) |
  (Cencode00 & ocsrc==513);  /* gaming cage workers (?) */

/* Door-to-door sales, street sales, and news vendors */
replace ocdest=277 if
  (Cencode60 & ocsrc==390) |
  (Cencode70 & ocsrc==264) |  /* hucksters and peddlers */
  (Cencode70 & ocsrc==266) |  /* newspaper carriers and vendors */
  (Cencode80 & ocsrc==277) |
  (Cencode80 & ocsrc==278) |
  (Cencode00 & ocsrc==495);

/* Demonstrators [and "promoters and models, sales", after 1983] */
replace ocdest=283 if
  (Cencode60 & ocsrc==382) |
  (Cencode70 & ocsrc==262) |
  (Cencode80 & ocsrc==283) |
  (Cencode00 & ocsrc==490);

/* Office supervisors */
replace ocdest=303 if
  (Cencode70 & ocsrc==312) |  /* clerical supervisors */
  (Cencode80 & ocsrc==303) |  /* supervisors, general office */
  (Cencode80 & ocsrc==305) |  /* supervisors, financial records processing !@#$ */
  (Cencode00 & ocsrc==500);    /* supvs of office/admin support work */

/* Computer and peripheral equipment operators */
replace ocdest=308 if
  (Cencode70 & ocsrc==343) |  /* computer and peripheral equipment operators */
  (Cencode70 & ocsrc==350) |  /* tabulating machine operators */
  (Cencode80 & ocsrc==304) |  /* supvs of computer operators */
  (Cencode80 & ocsrc==308) |  /* computer operators */
  (Cencode80 & ocsrc==309) |  /* peripheral equipment operators */
  (Cencode00 & ocsrc==580);

/* Secretaries */
replace ocdest=313 if
  (Cencode60 & ocsrc==342)  |
  (Cencode70 & ocsrc==370)  |
  (Cencode70 & ocsrc==371)  |
  (Cencode70 & ocsrc==372)  |
  (Cencode80 & ocsrc==313)  |
  (Cencode00 & ocsrc==570) ;
    /* Secretaries and administrative assistants */

/* Stenographers */
replace ocdest=314 if
  (Cencode60 & ocsrc==345) |
  (Cencode70 & ocsrc==376) |
  (Cencode80 & ocsrc==314);

/* Typists */
replace ocdest=315 if
  (Cencode60 & ocsrc==360) |
  (Cencode70 & ocsrc==391) |
  (Cencode80 & ocsrc==315) |
  (Cencode00 & ((ocsrc==582) |
    (ocsrc==583)));  /* desktop publishers; should be in editors! */
                        /* but the 1990/2000 re-cats data don't go that way */
/* Interviewers, enumerators, and surveyors */
replace ocdest=316 if
  (Cencode70 & ocsrc==320) |
  (Cencode80 & ocsrc==316) |
  (Cencode00 & ocsrc==523) | /* credit authorizers, checkers, & clerks */
  (Cencode00 & ocsrc==531) |
  (Cencode00 & ocsrc==534);  /* new accounts clerks */

/* Hotel clerks */
replace ocdest=317 if
  (Cencode80 & ocsrc==317) |
  (Cencode00 & ocsrc==530);

/* Transportation, ticket, reservations agents (sales workers) */
replace ocdest=318 if
  (Cencode60 & ocsrc==354) |
  (Cencode70 & ocsrc==390) |
  (Cencode80 & ocsrc==318) |
  (Cencode00 & ocsrc==483) | /* travel agents */
  (Cencode00 & ocsrc==541);  /* reservation, transport, ticket agents & clerks */

/* Receptionists */
replace ocdest=319 if
  (Cencode60 & ocsrc==341) |
  (Cencode70 & ocsrc==364) |
  (Cencode80 & ocsrc==319) |
  (Cencode00 & ocsrc==540);   /* Receptionists and information clerks */

/* Information clerks, nec */
replace ocdest=323 if
  (Cencode80 & ocsrc==323) |
  (Cencode80 & ocsrc==325);  /* classified ad clerks */

/* Correspondence and order clerks */
replace ocdest=326 if
  (Cencode80 & ((ocsrc==326) | (ocsrc==327))) |
  (Cencode00 & ((ocsrc==521) | (ocsrc==535)));

/* Human resources clerks, except payroll and timekeeping */
replace ocdest=328 if
  (Cencode60 & ocsrc==154) |
  (Cencode70 & ocsrc==56) |   /* personnel and labor relations specialists */
  (Cencode80 & ocsrc==328) |
  (Cencode00 & ocsrc==536);

/* Library assistants */
replace ocdest=329 if
  (Cencode60 & ocsrc==302) |
  (Cencode70 & ocsrc==330) |
  (Cencode80 & ocsrc==329) |
  (Cencode00 & ocsrc==244) |   /* library technicians */
  (Cencode00 & ocsrc==532);

/* File clerks */
replace ocdest=335 if
  (Cencode60 & ocsrc==320) |
  (Cencode70 & ocsrc==325) |
  (Cencode80 & ocsrc==335) |
  (Cencode00 & ocsrc==526);

/* Records clerks */
replace ocdest=336 if
  (Cencode80 & ocsrc==336) |
  (Cencode00 & ocsrc==520) |  /* brokerage clerks */
  (Cencode00 & ocsrc==542);   /* info and rcord clerks, nec */

/* Bookkeepers, accounting, and auditing clerks */
replace ocdest=337 if
  (Cencode60 & ocsrc==310) |    /* bookkeepers */
  (Cencode70 & ocsrc==305) |   /* bookkeepers */
  (Cencode80 & ocsrc==337) |
  (Cencode00 & ocsrc==512);

/* Payroll and timekeeping clerks */
replace ocdest=338 if
  (Cencode60 & ocsrc==333) |
  (Cencode70 & ocsrc==360) |
  (Cencode80 & ocsrc==338) |
  (Cencode00 & ocsrc==514);

/* Cost and rate clerks (financial records processing) */
replace ocdest=343 if
  (Cencode80 & ocsrc==343);

/* Billing clerks and related financial records processing */
replace ocdest=344 if
  (Cencode70 & ocsrc==303) |
  (Cencode70 & ocsrc==341) |  /* bookeeping and billing machine operators */
  (Cencode70 & ocsrc==342) |  /* calculating machine operators */
  (Cencode80 & ocsrc==339) |
  (Cencode80 & ocsrc==344) |
  (Cencode00 & ocsrc==511);

/* Duplicating machine operators */
replace ocdest=345 if
  (Cencode70 & ocsrc==344) |
  (Cencode80 & ocsrc==345);

/* Mail and paper handlers, outside postal service; 1971-82.
   Mail preparing and paper handling machine operators, post 1983 */
replace ocdest=346 if (Cencode70 & ocsrc==332)   |
  (Cencode80 & ocsrc==346) |
  (Cencode00 & ocsrc==556);

/* Office machine operators, n.e.c. */
replace ocdest=347 if
  (Cencode60 & ocsrc==325) |
  (Cencode70 & ocsrc==355) |
  (Cencode80 & ocsrc==347) |
  (Cencode00 & ocsrc==590);    /* office machine operators */

/* Telephone or switchboard operators */
replace ocdest=348 if
  (Cencode60 & ocsrc==353) |
  (Cencode70 & ocsrc==385) |
  (Cencode80 & ocsrc==306) |   /* supvs */
  (Cencode80 & ocsrc==348) |
  (Cencode00 & ((ocsrc==501) | (ocsrc==502)));

/* Other telecom operators, usually telegraph */
replace ocdest=349 if
  (Cencode60 & ocsrc==352)   |
  (Cencode70 & ocsrc==384)   |
  (Cencode80 & ocsrc==349) |
  (Cencode80 & ocsrc==353) |    /* comm equpmnt nec */
  (Cencode00 & ocsrc==503);

/* Postal clerks, usually excluding mail carriers  */
replace ocdest=354 if
  (Cencode60 & ocsrc==340) |
  (Cencode70 & ocsrc==361) |
  (Cencode80 & ocsrc==354) |
  (Cencode00 & ocsrc==554);

/* Mail carriers, for postal service */
replace ocdest=355 if
  (Cencode60 & ocsrc==323) |
  (Cencode70 & ocsrc==331) |
  (Cencode80 & ocsrc==355) |
  (Cencode00 & ocsrc==555);

/* Mail clerks, outside of post office */
replace ocdest=356 if
  (Cencode60 & ocsrc==315) |    /* express messengers and mail clerks */
  (Cencode80 & ocsrc==356) |
  (Cencode00 & ocsrc==585);

/* Messengers [and, pre-1982, office helpers too] */
replace ocdest=357 if
  (Cencode60 & ocsrc==324) |
  (Cencode60 & ocsrc==351) |  /* telegraph messengers */
  (Cencode70 & ocsrc==333) |
  (Cencode70 & ocsrc==383) |  /* telegraph messengers */
  (Cencode80 & ocsrc==357) |
  (Cencode00 & ocsrc==551);

/* Dispatchers  (and sometimes starters of vehicles) */
replace ocdest=359 if
  (Cencode60 & ocsrc==314) |
  (Cencode70 & ocsrc==315) |
  (Cencode80 & ocsrc==359) |
  (Cencode00 & ocsrc==552);

/* Inspectors, n.e.c. */
replace ocdest=361 if
  (Cencode60 & ocsrc==450);   /* !@#$ break by industry */

/* Shipping and receiving clerks */
replace ocdest=364 if
  (Cencode60 & ocsrc==343) |  /* shipping and receiving clerks */
  (Cencode70 & ocsrc==374) |  /* shipping and receiving clerks */
  (Cencode80 & ocsrc==307) |  /* supvs of distrib, scheduling, and adjusting */
  (Cencode80 & ocsrc==364) |  /* traffic, shipping and receiving clerks */
  (Cencode00 & ((ocsrc==550) |   /* cargo and freight agents */
                (ocsrc==561)));  /* shipping, receiving, & traffic clerks */

/* Stock and inventory clerks */
replace ocdest=365 if
  (Cencode60 & ocsrc==350) |  /* stock clerks and store keepers */
  (Cencode70 & ocsrc==381) |  /* stock clerks and storekeepers */
  (Cencode80 & ocsrc==365) |
  (Cencode00 & ocsrc==515) |  /* procurement clerks */
  (Cencode00 & ocsrc==562);   /* stock clerks and order fillers */
                              /* almost half of the 562s should go into 877 */
/* Meter readers */
replace ocdest=366 if
  (Cencode70 & ocsrc==334) |
  (Cencode80 & ocsrc==366) |
  (Cencode00 & ocsrc==553);

 /* Weighers, measurers, checkers, */
replace ocdest=368 if
  (Cencode70 & ocsrc==392) | /* Weighers */
  (Cencode80 & ocsrc==368) | /* Weighers, measurers, and checkers */
               /* (material recording,  scheduling, and distributing clerks) */
  (Cencode00 & ocsrc==563); /* Weighers, measurers, checkers, samplers */

/* Expeditors ["and production controllers" 1968-1970;
   "(material recording, scheduling, and distributing clerks)"] */
replace ocdest=373 if
  (Cencode70 & ocsrc==323) |
  (Cencode80 & ocsrc==363) |   /* production coordinators */
  (Cencode80 & ocsrc==373) |
  (Cencode00 & ((ocsrc==16) | (ocsrc==560)));
       /* production, planning, and expediting clerks */

/* Insurance adjusters, examiners, and investigators */
replace ocdest=375 if
  (Cencode60 & ocsrc==321) |
  (Cencode70 & ocsrc==326) |
  (Cencode80 & ocsrc==375) |
  (Cencode00 & ocsrc==54) | /* claims adjusters, appraisers, */
                               /*  examiners, investigators */
  (Cencode00 & ocsrc==584);  /* insurance processing: policies and claims */

/* Customer service reps; investigators and adjusters, except insurance */
replace ocdest=376 if
  (Cencode70 & ocsrc==321) |  /* estimators and investigators, n.e.c. */
  (Cencode80 & ocsrc==376) |
  (Cencode00 & ocsrc==524) | /* customer service reps; not good fit */
                             /* but there isn't a simple service rep cat */
  (Cencode00 & ocsrc==533); /* loan interviewers and clerks */

/* Eligibility clerks for govt programs; social welfare */
replace ocdest=377 if
  (Cencode80 & ocsrc==377) |
  (Cencode00 & ocsrc==525);

/* Bill and account collectors */
replace ocdest=378 if
  (Cencode60 & ocsrc==313) |
  (Cencode70 & ocsrc==313) |
  (Cencode80 & ocsrc==378) |
  (Cencode00 & ocsrc==510);

/* General office clerks */
replace ocdest=379 if 
  (Cencode60 & ocsrc==370) |  /* clerical, nec.  bad job; this is 44000 */
                              /* people, when they have tiny clerical categories */
  (Cencode70 & ocsrc==395) |  /* not specified clerical workers */
  (Cencode70 & ocsrc==396) |  /* clerical and kindred, allocated */
  (Cencode80 & ocsrc==379) |
  (Cencode00 & ocsrc==586);

/* Bank tellers */
replace ocdest=383 if
  (Cencode60 & ocsrc==305) |
  (Cencode70 & ocsrc==301) |
  (Cencode80 & ocsrc==383) |
  (Cencode00 & ocsrc==516);

/* Proofreaders */
replace ocdest=384 if
  (Cencode70 & ocsrc==362) |
  (Cencode80 & ocsrc==384) |
  (Cencode00 & ocsrc==591);

/* Data entry keyers */
replace ocdest=385 if
  (Cencode70 & ocsrc==345) |   /* key punch operators */
  (Cencode80 & ocsrc==385) |
  (Cencode00 & ocsrc==581);

/* Statistical clerks */
replace ocdest=386 if
  (Cencode70 & ocsrc==375) |
  (Cencode80 & ocsrc==386) |
  (Cencode00 & ocsrc==592);

/* Teacher's aides */
replace ocdest=387 if
  (Cencode70 & ocsrc==382) |
  (Cencode80 & ocsrc==387) |
  (Cencode80>1 & ocsrc==467);   /* early childhood teacher's asst */

/* Administrative support jobs, nec */
replace ocdest=389 if
  (Cencode70 & ocsrc==311) |   /* clerical assistants */
  (Cencode70 & ocsrc==394) |   /* misc clerical workers */
  (Cencode80 & ocsrc==369) |  /* samplers */
  (Cencode80 & ocsrc==374) |  /* material recording, scheduling, and distributing clerks, nec */
  (Cencode80 & ocsrc==389) |
  (Cencode00 & ocsrc==522) |  /* court, municipal, and license clerks */
  (Cencode00 & ocsrc==593);   /* office/admin support, nec */

/* Housekeepers, maids, butlers, stewards, and lodging quarters cleaners
   inside or outside of private households */
replace ocdest=405 if
  (Cencode60 & ocsrc==802) |
  (Cencode60 & ocsrc==821) | /* boarding and lodging house keepers */
  (Cencode60 & ocsrc==823) | /* chambermaids and maids, except private hsehold*/
  (Cencode60 & ocsrc==824) | /* charwomen and cleaners */
  (Cencode60 & ocsrc==832) |
  (Cencode70 & ocsrc==901) |
  (Cencode70 & ocsrc==902) |
  (Cencode70 & ocsrc==931) |  /* Flight attendants (?? yes, according to 1990/2000 map) */
  (Cencode70 & ocsrc==940) |
  (Cencode70 & ocsrc==982) |
  (Cencode80 & ocsrc==405) |
  (Cencode80 & ocsrc==449) |
  (Cencode80 & ocsrc==950) |
  (Cencode00 & ocsrc==384) |  /* Flight attendants (?? yes, according to 1990/2000 map) */
  (Cencode00 & ocsrc==423);

/* Private household cleaners and servants */
replace ocdest=407 if
  (Cencode70 & ocsrc==984) |  /* ditto */
  (Cencode80 & ocsrc==407);

/* Supervisors, guards */
replace ocdest=415 if
  (Cencode80 & ocsrc==415) |
  (Cencode00 & ocsrc==373) ;

/* Fire fighting, prevention, inspection, including supervisors */
replace ocdest=417 if
  (Cencode60 & ocsrc==850) |  /* firemen (for fire protection) */
  (Cencode70 & ocsrc==961) |
  (Cencode80 & ocsrc==413) |
  (Cencode80 & ocsrc==416) |
  (Cencode80 & ocsrc==417) |
  (Cencode00 & ocsrc==372) |
  (Cencode00 & ocsrc==374) |
  (Cencode00 & ocsrc==375);

/* Police and detectives [sometimes only in "public service"] */
/* and including supervisors */
replace ocdest=418 if
  (Cencode60 & ocsrc==852) |  /* marshals and constables */
  (Cencode60 & ocsrc==853) |
  (Cencode70 & ocsrc==964) |
  (Cencode80 & ocsrc==6) |    /* administrators, protective services */
  (Cencode80 & ocsrc==414) |
  (Cencode80 & ocsrc==418) |
  (Cencode00 & ocsrc==371) |
  (Cencode00 & ocsrc==382) |
  (Cencode00 & ocsrc==385) | /* Police officers */
  (Cencode00 & ocsrc==386) |
  (Cencode00 & ocsrc==391);  /* Private detectives and investigators */

/* 1968-82 Sheriffs and bailiffs
   1983-   Sheriffs, bailiffs, and other law enforcement officers */
/* Correctional institution officers */
     /* bailiffs, correctional officers, and jailers */
replace ocdest=423 if
  (Cencode60 & ocsrc==854) |
  (Cencode70 & ocsrc==963) |
  (Cencode70 & ocsrc==965) |
  (Cencode80 & ((ocsrc==423) | (ocsrc==424))) |
  (Cencode00 & ((ocsrc==370) | (ocsrc==380))) |
  (Cencode00 & ocsrc==383);   /* fish and game wardens */

/* Crossing guards and bridge tenders */
replace ocdest=425 if
  (Cencode70 & ocsrc==960) |
  (Cencode80 & ocsrc==425) |
  (Cencode00 & ocsrc==394);

/* Guards [and "police, excluding public service" in 1971]
          [and "watchmen and doorkeepers" in 1968] */
replace ocdest=426 if
  (Cencode60 & ocsrc==851) |
  (Cencode70 & ocsrc==962) |
  (Cencode80 & ocsrc==426) |
  (Cencode00 & ocsrc==392);

/* Protective service occupations, n.e.c.
          [and "watchmen and doorkeepers" in 1968] */
/* removed ref to 2000 code 373 from here, 3 May 2012; thanks Behzad Kianian! */
replace ocdest=427 if
  (Cencode80 & ocsrc==427) |
  (Cencode00 & ocsrc==390) |
  (Cencode00 & ocsrc==395);

/* Bartenders */
replace ocdest=434 if
  (Cencode60 & ocsrc==815) |
  (Cencode70 & ocsrc==910) |
  (Cencode80 & ocsrc==434) |
  (Cencode00 & ocsrc==404);

/* Waiter/waitress */
replace ocdest=435 if
  (Cencode60 & ocsrc==875) |
  (Cencode70 & ocsrc==915) |
  (Cencode80 & ocsrc==435) |
  (Cencode00 & ocsrc==411);

/* Cooks, variously defined:  all, after 1983, including separately
   short order cooks and all others; all but private household ones in 68-82*/
replace ocdest=436 if
  (Cencode60 & ocsrc==825) |
  (Cencode70 & ocsrc==912) |
  (Cencode70 & ocsrc==981) |
  (Cencode80 & ocsrc==433) |      /* supvs of food prep and service */
  (Cencode80 & ocsrc==437) |      /* short order cooks */
  (Cencode80 & ocsrc==436) |     /* all but short order */
  (Cencode80 & ocsrc==404) |
  (Cencode00 & ((ocsrc==400) | (ocsrc==401) | (ocsrc==402)));

/* Food counter and fountain workers */
replace ocdest=438 if
  (Cencode60 & ocsrc==830) |   /* counter and fountain workers */
  (Cencode70 & ocsrc==914) |   /* food counter workers */
  (Cencode80 & ocsrc==438);

/* Kitchen workers in food preparation, post 1983
   1968-1970: Kitchen workers, n.e.c., except private household */
replace ocdest=439 if
  (Cencode60 & ocsrc==835) |
  (Cencode70 & ocsrc==913) |   /* dishwashers */
  (Cencode70 & ocsrc==916) |   /* food service, n.e.c. */
  (Cencode80 & ocsrc==439) |
  (Cencode00 & ocsrc==405);    /* combined food prep and serving workers */

/* Waiter/waitress's assistant */
replace ocdest=443 if
  (Cencode70 & ocsrc==911) |   /* busboys */
  (Cencode80 & ocsrc==443) |
  (Cencode00 & ocsrc==406) |   /* cafeteria counter attendants */
  (Cencode00 & ocsrc==412) |   /* food servers outside restaurants */
  (Cencode00 & ocsrc==413);    /* dining room / cafe / bar helpers */

/* Misc food prep workers */
replace ocdest=444 if
  (Cencode80 & ocsrc==444) |
  (Cencode00 & ocsrc==403) | /* food preparation workers */
  (Cencode00 & ocsrc==414) | /* dishwashers */
  (Cencode00 & ocsrc==416);  /* all other food prep and serving workers */

/* Dental assistants */
replace ocdest=445 if
  (Cencode70 & ocsrc==921) |
  (Cencode80 & ocsrc==445) |
  (Cencode00 & ocsrc==364);

/* Health aides, except nursing */
replace ocdest=446 if
  (Cencode60 & ocsrc==303) |
  (Cencode70 & ocsrc==922) |  /* health aides, except nursing */
  (Cencode80 & ocsrc==446) |
  (Cencode00 & ocsrc==365);

/* Nursing aides, orderlies, and attendants */
replace ocdest=447 if
  (Cencode60 & ocsrc==151) | /* nurses, student professional */
  (Cencode60 & ocsrc==810) | /* attendants, hospital and other institutions */
  (Cencode70 & ocsrc==925) |
  (Cencode80 & ocsrc==447) |
  (Cencode00 & ocsrc==360) | /* Nursing,psychiatric,& home health aides */
  (Cencode00 & ocsrc==461);

/* Supervisors of cleaning and building service workers */
replace ocdest=448 if
  (Cencode80 & ocsrc==448) |
  (Cencode00 & ocsrc==420);

/* Janitors */
replace ocdest=453 if
  (Cencode60 & ocsrc==834) |
  (Cencode70 & ocsrc==903) |
  (Cencode80 & ocsrc==453) |
  (Cencode00 & ocsrc==422);

/* Elevator operators */
replace ocdest=454 if
  (Cencode60 & ocsrc==831) |
  (Cencode70 & ocsrc==943) |
  (Cencode80 & ocsrc==454) |
  (Cencode00 & ocsrc==975);     /* misc material moving */

/* Pest control occupations */
replace ocdest=455 if 
  (Cencode80 & ocsrc==455) | 
  (Cencode00 & ocsrc==424);

/* Supervisors of personal service jobs */
replace ocdest=456 if
  (Cencode80 & ocsrc==456) |
  (Cencode00 & ocsrc==432);

/* Barbers */
replace ocdest=457 if
  (Cencode60 & ocsrc==814) |
  (Cencode70 & ocsrc==935) |
  (Cencode70 & ocsrc==945) |  /* personal service apprentices; census/ipums table shows they go here */
  (Cencode80 & ocsrc==457) |
  (Cencode00 & ocsrc==450);

/* Hairdressers and cosmetologists */
replace ocdest=458 if
  (Cencode60 & ocsrc==843) |
  (Cencode70 & ocsrc==944) |
  (Cencode80 & ocsrc==458) |
  (Cencode00 & ocsrc==451) |
  (Cencode00 & ocsrc==452);

/* Attendants, amusement and recreation facilities */
replace ocdest=459 if
  (Cencode60 & ocsrc==813) |
  (Cencode70 & ocsrc==932) |
  (Cencode80 & ocsrc==459) |
  (Cencode00 & ocsrc==440) |
  (Cencode00 & ocsrc==443);

/* Guides */
replace ocdest=461 if
  (Cencode80==1 & ocsrc==463) |
  (Cencode80>1 & ocsrc==461) |  /* remapped between 1980 and 1990 */
  (Cencode00 & ocsrc==454) ;

/* Ushers */   /* remapped in 1990 Census */
replace ocdest=462 if
  (Cencode60 & ocsrc==874) |
  (Cencode70 & ocsrc==953) |
  (Cencode80==1 & ocsrc==464) |
  (Cencode80>=2 & ocsrc==462) |
  (Cencode00 & ocsrc==442);

/* Public transportation attendants and inspectors */
replace ocdest=463 if
  (Cencode70 & ocsrc==704) | /* conductors and operators, urban rail transit */
  (Cencode80==1 & ocsrc==465) |
  (Cencode80>1 & ocsrc==463)  |
  (Cencode00 & ocsrc==455) |   /* Transportation attendants */
  (Cencode00 & ocsrc==941) ;   /* Transportation inspectors */

/* Baggage porters and bellhops.
   in 1968-71 "baggagemen, transportation" */
replace ocdest=464 if
  (Cencode60 & ocsrc==304) |
  (Cencode60 & ocsrc==841) |   /* porters */
  (Cencode70 & ocsrc==934) |
  (Cencode80==1 & ocsrc==466) |
  (Cencode80>1 & ocsrc==464) |
  (Cencode00 & ocsrc==453);

/* Welfare service aides */   /* remapped in 1990 Census */
replace ocdest=465 if
  (Cencode70 & ocsrc==954) |
  (Cencode80==1 & ocsrc==467) |
  (Cencode80>=2 & ocsrc==465) |
  (Cencode00 & ocsrc==202);

/* Child care, in or out of home */
replace ocdest=468 if
  (Cencode60 & ocsrc==801) |
  (Cencode70 & ocsrc==952) |  /* school monitors */
  (Cencode70 & ((ocsrc==942) | (ocsrc==980))) |
  (Cencode80 & ((ocsrc==406) | (ocsrc==468))) |
  (Cencode80>1 & ocsrc==466) |
  (Cencode00 & ocsrc==460) |
  (Cencode00 & ocsrc==464);    /* residential advisors */

/* Personal service occupations, nec */
replace ocdest=469 if
  (Cencode60 & ocsrc==420) | /* decorators and window dressers N=706*/
  (Cencode60 & ocsrc==804) |
  (Cencode60 & ocsrc==812) | /* attendants, professional and personal service, nec */
  (Cencode60 & ocsrc==820) | /* bootblacks */
  (Cencode60 & ocsrc==890) |
  (Cencode70 & ocsrc==933) |  /* attendants, personal service, n.e.c.  */
  (Cencode70 & ocsrc==941) | /* bootblacks */
  (Cencode70 & ocsrc==950) | /* housekeepers, except private household */
  (Cencode70 & ocsrc==976) |
  (Cencode70 & ocsrc==986) |
  (Cencode80 & ocsrc==469) |
  (Cencode00 & ocsrc==363) |  /* massage therapists */
  (Cencode00 & ocsrc==415) |  /* host/hostesses in restaurants/lounge/coffee shops */
  (Cencode00 & ocsrc==446) |  /* funeral service workers */
  (Cencode00 & ocsrc==465);

  /* Farmers ["(owners and tenants)", 1968-82; "except horticultural"post-82 */
replace ocdest=473 if
  (Cencode60 & ocsrc==200) |
  (Cencode70 & ocsrc==801) |
  (Cencode80 & ocsrc==473) |
  (Cencode00 & ocsrc==21);

/* Horticultural specialty farmers */
replace ocdest=474 if
  (Cencode80 & ocsrc==474);

/* Farm managers except for horticultural farms */
replace ocdest=475 if
  (Cencode60 & ocsrc==222) |  /* farm managers */
  (Cencode70 & ocsrc==802) |  /* farm managers */
  (Cencode70 & ocsrc==806) |  /* farmers and farm managers, allocated */
  (Cencode70 & ocsrc==821) |
  (Cencode80 & ocsrc==475) |
  (Cencode00 & ocsrc==20)  |
  (Cencode00 & ocsrc==602);   /* animal breeders */

/* Managers of horticultural specialty farms */
replace ocdest=476 if
  (Cencode80 & ocsrc==476);

/* Farm workers */
replace ocdest=479 if
  (Cencode60 & ocsrc==901) |  /* farm foremen */
  (Cencode60 & ocsrc==902) |  /* farm workers for wage */
  (Cencode60 & ocsrc==903) |  /* unpaid family farm laborers */
  (Cencode60 & ocsrc==905) |
                        /* self-employed farm service laborers. I don't*/
                        /* think any are actually in the data with this code */
                        /* that comment properly closed 4/17/2007 pbm */
  (Cencode70 & ocsrc==822) |
  (Cencode70 & ocsrc==823) |
  (Cencode70 & ocsrc==824) |
  (Cencode70 & ocsrc==846) |
  (Cencode80 & ocsrc==477) |  /* supervisors of farm workers */
  (Cencode80 & ocsrc==479) |
  (Cencode00 & ocsrc==434) | /* animal trainers */
  (Cencode00 & ocsrc==605);  /* misc agricultural workers */

/* Marine life cultivation workers */
replace ocdest=483 if
  (Cencode80 & ocsrc==483);

/* Nursery (farming) workers */
replace ocdest=484 if
  (Cencode80 & ocsrc==484);

/* Supervisors of agricultural occupations */
replace ocdest=485 if
  (Cencode80 & ocsrc==485) |
  (Cencode00 & ocsrc==421);  /* supvs of landscaping, lawn svc, groundskeeping */

/* Gardeners and groundskeepers, except on farms */
replace ocdest=486 if
  (Cencode60 & ocsrc==964) |
  (Cencode70 & ocsrc==755) |
  (Cencode80 & ocsrc==486) |
  (Cencode00 & ocsrc==425);

/* Animal caretakers, except farm */
replace ocdest=487 if
  (Cencode70 & ocsrc==740) |
  (Cencode80 & ocsrc==487) |
  (Cencode00 & ocsrc==435);

/* Graders and sorters of agricultural products */
replace ocdest=488 if
  (Cencode60 & ocsrc==654) | /* fruit, nut, & vegetable graders and packers */
  (Cencode80 & ocsrc==488) |
  (Cencode00 & ocsrc==604);

/* Inspectors of agricultural products */
replace ocdest=489 if
  (Cencode80 & ocsrc==489) |
  (Cencode00 & ocsrc==601);

/* Timber, logging, and forestry workers
   (which are different but the subcategories were too small to keep) */
replace ocdest=496 if
  (Cencode60 & ocsrc==444) |
  (Cencode60 & ocsrc==970) |
  (Cencode70 & ocsrc==450) |
  (Cencode70 & ocsrc==761) |
  (Cencode80 & ocsrc==494) |
  (Cencode80 & ocsrc==495) |
  (Cencode80 & ocsrc==496) |
  (Cencode00 & ocsrc==600) |
  (Cencode00 & ocsrc==612) |
  (Cencode00 & ocsrc==613);

/* Fishers and hunters and oystermen */
replace ocdest=498 if
  (Cencode60 & ocsrc==962) | (Cencode70 & ocsrc==752) |
  (Cencode80 & ocsrc==498) | (Cencode80 & ocsrc==499) |
  (Cencode00 & ocsrc==610) | (Cencode00 & ocsrc==611);

/* Supervisors of mechanics and repairers */
replace ocdest=503 if
  (Cencode80 & ocsrc==503) |
  (Cencode00 & ocsrc==700);

/* Automobile mechanics */
replace ocdest=505 if
  (Cencode60 & ocsrc==472) |
  (Cencode60 & ocsrc==601) |
  (Cencode70 & ocsrc==473) |
  (Cencode70 & ocsrc==474) |
  (Cencode80 & ocsrc==505) |
  (Cencode80 & ocsrc==506) |
  (Cencode00 & ocsrc==720);

/* Bus, truck, and stationary engine mechanics */
replace ocdest=507 if 
  (Cencode80 & ocsrc==507) |
  (Cencode00 & ocsrc==721);
        /* Bus and truck mechanics and diesel engine specialists */

/* Aircraft mechanics */
replace ocdest=508 if
  (Cencode60 & ocsrc==471) |
  (Cencode70 & ocsrc==471) |
  (Cencode80 & ocsrc==508) |
  (Cencode80 & ocsrc==515) |  /* aircraft mechanics, except engine */
  (Cencode00 & ocsrc==714);

/* Small engine repairers */
replace ocdest=509 if
  (Cencode80 & ocsrc==509) |
  (Cencode00 & ocsrc==724);

/* Auto body repairers and related */
replace ocdest=514 if
  (Cencode70 & ocsrc==472) | /* automobile body repairmen */
  (Cencode80 & ocsrc==514) |
  (Cencode00 & ((ocsrc==715) | (ocsrc==716)));

/* Heavy equipment mechanics and */
/* Farm equipment mechanics ["and repairers", 1971-82] */
replace ocdest=516 if
  (Cencode70 & ocsrc==480) | (Cencode70 & ocsrc==481) |
  (Cencode80 & ocsrc==516) | (Cencode80 & ocsrc==517) |
  (Cencode00 & ocsrc==722) | (Cencode00 & ocsrc==726);

/* Industrial machinery repair */
replace ocdest=518 if
  (Cencode80 & ocsrc==518) |
  (Cencode00 & ocsrc==733);

/* Machinery maintenance occupations */
replace ocdest=519 if
  (Cencode60 & ocsrc==461) |   /* loom fixers */
  (Cencode60 & ocsrc==692) |   /* oilers and greasers, except auto */
  (Cencode70 & ocsrc==483) |
  (Cencode70 & ocsrc==642) |   /* oilers and greasers, except auto */
  (Cencode80 & ocsrc==519) |
  (Cencode00 & ocsrc==735);

/* Repairer of electrical industrial equipment, e.g. electronic communication,
   transportation, and industrial equipment */
replace ocdest=523 if
  (Cencode60 & ocsrc==474) |  /* radio and tv mechanics and repair */
  (Cencode70 & ocsrc==485) |
  (Cencode80 & ocsrc==523) |
  (Cencode00 & ocsrc==710) |
  (Cencode00 & ocsrc==712);

/* Data processing equipment repairers */
replace ocdest=525 if
  (Cencode70 & ocsrc==475) |
  (Cencode80 & ocsrc==525) |
  (Cencode00 & ocsrc==701);  /* computer, automatic teller, office machine repairers */
        /* 701 might be splittable between 525 and 538 */

/* Household appliance and power tool repairers */
replace ocdest=526 if
  (Cencode70 & ocsrc==482) | /* household appliance and accessory installers and mechanics */
  (Cencode80 & ocsrc==526) |
  (Cencode00 & ocsrc==732);

/* Telecom installers, repairers, and linemen (telephones or their lines) */
replace ocdest=527 if
  (Cencode60 & ocsrc==453)   |
  (Cencode70 & ((ocsrc==552) | (ocsrc==554))) |
  (Cencode80 & ((ocsrc==527) | (ocsrc==529))) |
  (Cencode00 & ((ocsrc==702) | (ocsrc==742)));

/* Misc electrical and electronic equipment repairers */
replace ocdest=533 if
  (Cencode80 & ocsrc==533) |
  (Cencode00 & ocsrc==703) |
  (Cencode00 & ocsrc==705) |  /* installers and repairers of electronics on transportation equipment */
  (Cencode00 & ocsrc==711);

/* Heating, air conditioning, and refrigeration mechanics */
replace ocdest=534 if
  (Cencode60 & ocsrc==470) |
  (Cencode70 & ocsrc==470) |   /* air conditioning, heating, and refrig mechanics */
  (Cencode80 & ocsrc==534) |
  (Cencode00 & ocsrc==731);

/* Makers, repairers, and precision smiths of jewelry, watches, gold, silver,
   cameras, and musical instruments */
replace ocdest=535 if
  (Cencode60 & ocsrc==451) |
  (Cencode60 & ocsrc==504) |  /* piano and organ tuners and repairers */
  (Cencode70 & ocsrc==453) |
  (Cencode70 & ocsrc==516) |
  (Cencode80 & ocsrc==535) |
  (Cencode80 & ocsrc==647) |
  (Cencode00 & ocsrc==743) |  /* precision instrument and equipment repairers */
  (Cencode00 & ocsrc==875);

/* Locksmiths and safe repairers */
replace ocdest=536 if
  (Cencode80 & ocsrc==536) |
  (Cencode00 & ocsrc==754);

/* Office machine repairers and mechanics */
replace ocdest=538 if
  (Cencode60 & ocsrc==473) |  /*office machine mechanics and repairers */
  (Cencode70 & ocsrc==484) |
  (Cencode80 & ocsrc==538);

/* Mechanical control and valve repairers */
replace ocdest=539 if
  (Cencode80 & ocsrc==539) |
  (Cencode00 & ocsrc==730);

/* Elevator installers and repairers */
replace ocdest=543 if
  (Cencode80 & ocsrc==543) |
  (Cencode00 & ocsrc==670);

/* Millwrights */
/*Millwrights are covered in the occupational statement for
Industrial machinery installation, repair, and maintenance workers. ...
www.bls.gov/oco/ocos196.htm */
replace ocdest=544 if
  (Cencode60 & ocsrc==491) |
  (Cencode70 & ocsrc==491) |  /* apprentice mechanics, except automobile */
  (Cencode70 & ocsrc==502) |
  (Cencode80 & ocsrc==544) |
  (Cencode00 & ocsrc==736);
                /* Industrial and refractory machinery mechanics */

/* Mechanics and repairers, n.e.c. */
replace ocdest=549 if
  (Cencode60 & ocsrc==475) | /* railroad and railcar mechanics and repairers */
  (Cencode60 & ocsrc==480) | /* mechanics and repairers, nec */
  (Cencode60 & ocsrc==610) |
  (Cencode60 & ocsrc==620) |
  (Cencode60 & ocsrc==621) |
  (Cencode70 & ocsrc==403) |  /* blacksmiths */
  (Cencode70 & ocsrc==486) |
  (Cencode70 & ocsrc==492) |  /* misc mechanics and repairers */
  (Cencode70 & ocsrc==495) |  /* mechanics and repairers, n.e.c. */
  (Cencode70 & ocsrc==571) |  /* craft apprentices, n.e.c. */
  (Cencode70 & ocsrc==572) |  /* apprentices, craft not specified */
  (Cencode70 & ocsrc==575) |  /* craftsmen and kindred, n.e.c. */
  (Cencode70 & ocsrc==586) |  /* craftsmen and kindred, allocated */
  (Cencode80 & ocsrc==547) |
  (Cencode80 & ocsrc==549) |
  (Cencode80==1 & ocsrc==864) |   /* helpers to mechanics and repairers */
  (Cencode00 & ocsrc==734) |
  (Cencode00 & ((ocsrc==755) | (ocsrc==756))) |
  (Cencode00 & ocsrc==762);

/* Supervisors of construction-type trade workers */
replace ocdest=558 if
  (Cencode80 & ((ocsrc==553)|(ocsrc==554)|(ocsrc==555) |
                (ocsrc==556)|(ocsrc==557)|(ocsrc==558))) |
  (Cencode00 & ocsrc==620);
/* there is a bias problem here that only in the later years supervisors are
   separated.  that biases the trend in inequality among electricians, say,
   as if it were falling when really a category has been separated. */

/* Brickmasons, stonemasons, tile setters, tile finishers & carpet installers,
   including apprentices for all of the above */
replace ocdest=563 if
  (Cencode60 & ((ocsrc==405)|(ocsrc==602)))  |
  (Cencode70 & ((ocsrc==410)|(ocsrc==411)|(ocsrc==420)|(ocsrc==560))) |
  (Cencode80 & ((ocsrc==563)|(ocsrc==564)|(ocsrc==565)|(ocsrc==566))) |
  (Cencode00 & ocsrc==622) | (Cencode00 & ocsrc==624) ;

/* Carpenters, including apprentices */
replace ocdest=567 if
  (Cencode60 & ocsrc==411) | (Cencode60 & ocsrc==603) |(Cencode60 & ocsrc==960) |
  (Cencode70 & ocsrc==415) | (Cencode70 & ocsrc==416) |
  (Cencode80 & ocsrc==567) | (Cencode80 & ocsrc==569) |
  (Cencode00 & ocsrc==623);

/* Drywall installers [and "lathers", 1971-82] */
replace ocdest=573 if
  (Cencode70 & ocsrc==615) |
  (Cencode80 & ocsrc==573) |
  (Cencode00 & ocsrc==633);

/* Electricians, including apprentices */
replace ocdest=575 if
  (Cencode60 & ((ocsrc==421) | (ocsrc==604))) |
  (Cencode70 & ((ocsrc==430) | (ocsrc==431))) |
  (Cencode80 & ((ocsrc==575) | (ocsrc==576))) |
  (Cencode00 & ((ocsrc==713) | (ocsrc==635)));

/* Electrical power installers and repairers */
replace ocdest=577 if
  (Cencode70 & ocsrc==433) |
  (Cencode80 & ocsrc==577) |
  (Cencode00 & ocsrc==704) |  /* electric motor, power tool, etc, repairers */
  (Cencode00 & ocsrc==741) |
  (Cencode00 & ocsrc==760);   /* signal and track switch repairers */

/* Painters, construction and maintenance */
replace ocdest=579 if
  (Cencode60 & ocsrc==495) |
  (Cencode70 & ocsrc==510) |  /* painters, construction and maint, except apprentices */
  (Cencode70 & ocsrc==511) |  /* painter apprentices */
  (Cencode80 & ocsrc==579) |
  (Cencode00 & ocsrc==642);

/* Paperhangers   (which I guess refers to wallpaper) */
replace ocdest=583 if
  (Cencode60 & ocsrc==501) |
  (Cencode70 & ocsrc==512) |
  (Cencode80 & ocsrc==583) |
  (Cencode00 & ocsrc==643);

/* Plasterers and plasterer apprentices */
replace ocdest=584 if
  (Cencode60 & ocsrc==505) |
  (Cencode70 & ((ocsrc==520) | (ocsrc==521))) |
  (Cencode80 & ocsrc==584) |
  (Cencode00 & ocsrc==646);

/* Plumbers, pipe fitters, steamfitters, and related apprentices */
replace ocdest=585 if
  (Cencode60 & ocsrc==510) |
  (Cencode60 & ocsrc==612) |
  (Cencode70 & ocsrc==522) | (Cencode70 & ocsrc==523) |
  (Cencode80 & ocsrc==585) | (Cencode80 & ocsrc==587) |
  (Cencode00 & ocsrc==644);

/* Concrete finishers, cement masons, terrazzo workers */
/* (terrazzo is the stones-in-mortar mix some floors are made of) */
replace ocdest=588 if
  (Cencode60 & ocsrc==413) | /* cement and concrete finishers */
  (Cencode70 & ocsrc==421) | /* cement and concrete finishers */
  (Cencode80 & ocsrc==588) |
  (Cencode00 & ocsrc==625);

/* Glaziers */
replace ocdest=589 if
  (Cencode60 & ocsrc==434) |
  (Cencode70 & ocsrc==445) |
  (Cencode80 & ocsrc==589) |
  (Cencode00 & ocsrc==636);

/* Insulation workers */
replace ocdest=593 if
  (Cencode60 & ocsrc==630) |   /* asbestos and insulation workers */
  (Cencode70 & ocsrc==601) |
  (Cencode80 & ocsrc==593) |
  (Cencode00 & ocsrc==640) |
  (Cencode00 & ocsrc==672);     /* hazardous material remover workers */

/* Paving, surfacing, and tamping equipment and grader, dozer, and scraper operators */
replace ocdest=594 if
  (Cencode70 & ocsrc==412) |  /* bulldozer operators */
  (Cencode80 & ocsrc==594) |
  (Cencode80 & ocsrc==855) |
  (Cencode00 & ocsrc==630);

/* Roofers ["and slaters", pre-1982] */
replace ocdest=595 if
  (Cencode60 & ocsrc==514) |
  (Cencode70 & ocsrc==534) |
  (Cencode80 & ocsrc==595) |
  (Cencode00 & ocsrc==651);

/* Sheet metal duct installers */
replace ocdest=596 if
  (Cencode80 & ocsrc==596) |
  (Cencode00 & ocsrc==652);

/* Structural metal workers */
replace ocdest=597 if
  (Cencode60 & ocsrc==523) |
  (Cencode70 & ocsrc==550) |
  (Cencode80 & ocsrc==597) |
  (Cencode00 & ocsrc==650) |  /* reinforcing iron and rebar workers */
  (Cencode00 & ocsrc==653) |  /* structural iron and steel wkrs */
  (Cencode00 & ocsrc==774);   /* structural metal fabricators and fitters */

/* Drillers of earth */
replace ocdest=598 if
  (Cencode70 & ocsrc==614) |
  (Cencode80 & ocsrc==598) |
  (Cencode00 & ocsrc==682);

/* Construction trades, n.e.c. */
replace ocdest=599 if
  (Cencode60 & ocsrc==613) |
  (Cencode70 & ocsrc==440) |  /* floor layers, except tile setters */
  (Cencode80 & ocsrc==599) |
  (Cencode00 & ocsrc==631) |  /* pile-driver operators */
  (Cencode00 & ocsrc==671) |  /* fence erectors */
  (Cencode00 & ocsrc==676);

/* Drillers of oil wells */
replace ocdest=614 if
  (Cencode80 & ocsrc==614) |
  (Cencode00 & ocsrc==680) |
  (Cencode00 & ocsrc==692);  /* roustabouts, oil and gas */

/* Explosives workers */
replace ocdest=615 if
  (Cencode60 & ocsrc==634) |  /* blasters and powderman */
  (Cencode70 & ocsrc==603) |  /* blasters */
  (Cencode80 & ocsrc==615) |
  (Cencode00 & ocsrc==683);

/* Miners */
replace ocdest=616 if
  (Cencode60 & ocsrc==685) |
  (Cencode70 & ocsrc==640) |
  (Cencode80 & ocsrc==616) |
  (Cencode00 & ocsrc==684);

/* Other mining occupations */
replace ocdest=617 if
  (Cencode80 & ocsrc==617) |
  (Cencode00 & ocsrc==691) |  /* roof bolters, mining */
  (Cencode00 & ocsrc==694);

/* Supervisors of production activities */
replace ocdest=628 if
  (Cencode60 & ocsrc==430) | /* foremen, nec ; !@#$ break by industry */
  (Cencode70 & ocsrc==441) | /* foremen, nec ; !@#$ break by industry */
  (Cencode80 & ocsrc==613) | /* supvs of extractive activities */
  (Cencode80>1 & ocsrc==628) |  /* 1990 supervisor of production occs */
  (Cencode80==1 & ocsrc==633) |  /* 1980 supervisor of production occs */
  (Cencode80==1 & ocsrc==863) |
  (Cencode00 & ocsrc==770);

/* Tool and die makers and die setters, including apprentices */
replace ocdest=634 if
  (Cencode60 & ocsrc==530) |
  (Cencode70 & ocsrc==562) |
  (Cencode70 & ocsrc==561) |
  (Cencode80 & ocsrc==634) |
  (Cencode80 & ocsrc==635) |
  (Cencode80 & ocsrc==655) |   /* misc precision metal workers */
  (Cencode00 & ocsrc==813);

/* Machinists */
replace ocdest=637 if
  (Cencode60 & ocsrc==465) |
  (Cencode60 & ocsrc==605) |
  (Cencode70 & ocsrc==461) |
  (Cencode70 & ocsrc==462) |   /* machinist apprentices */
  (Cencode80 & ocsrc==637) |
  (Cencode80 & ocsrc==639) |   /* machinist apprentices */
  (Cencode00 & ocsrc==803);

/* Boilermakers */
replace ocdest=643 if
  (Cencode60 & ocsrc==403) |
  (Cencode70 & ocsrc==404) |
  (Cencode80 & ocsrc==643) |
  (Cencode00 & ocsrc==621);

/* Precision grinders and filers (e.g. tool sharpening) */
replace ocdest=644 if
  (Cencode80 & ocsrc==644) |
  (Cencode00 & ocsrc==821);

/* Patternmakers and model makers [phrased variously:
    "Pattern and model makers, except paper" in Cencode60 and Cencode70, and
    "Patternmakers and model makers, metal" or
    "Patternmakers and model makers, wood" or
    "Patternmakers, lay-out workers, and cutters" in Cencode80 and beyond]*/
/* !@#$  possibly the inclusion of 676 is an error there, if that's paper;
   check how many of each type there are to get the counts right */
replace ocdest=645 if
  (Cencode60 & ocsrc==502) |
  (Cencode70 & ocsrc==514) |
  (Cencode80 & ocsrc==645) |
  (Cencode80 & ocsrc==656) |
  (Cencode80 & ocsrc==676) |
  (Cencode00 & ocsrc==806) |
  (Cencode00 & ocsrc==844) |  /* fabric and apparel patternmakers */
  (Cencode00 & ocsrc==852);   /* wooden model makers and patternmakers */

/* Lay-out workers */
replace ocdest=646 if
  (Cencode70 & ocsrc==540) |  /* shipfitters */
  (Cencode80 & ocsrc==646) |
  (Cencode00 & ocsrc==816);

/* Engravers  ["except photoengravers" 1968-1982; "metal" only, post-1983] */
replace ocdest=649 if
  (Cencode60 & ocsrc==424) |
  (Cencode70 & ocsrc==435) |
  (Cencode80 & ocsrc==649) |
  (Cencode00 & ocsrc==891); /* Etchers and engravers */

/* 1968- Tinsmiths, coppersmiths, and sheet metal workers
   1971- Sheet metal workers and tinsmiths
   1983- Sheet metal workers  */
replace ocdest=653 if
  (Cencode60 & ocsrc==525) |
  (Cencode60 & ocsrc==614) |
  (Cencode70 & ocsrc==535) |
  (Cencode70 & ocsrc==536) |
  (Cencode80 & ocsrc==653) |
  (Cencode80 & ocsrc==654);

/* Cabinet makers and bench carpenters */
replace ocdest=657 if
  (Cencode60 & ocsrc==410) |  /* cabinet makers */
  (Cencode70 & ocsrc==413) |  /* cabinet makers */
  (Cencode80 & ocsrc==657) |  /* cabinet makers and bench carpenters */
  (Cencode00 & ocsrc==850);

/* Furniture and wood finishers */
replace ocdest=658 if
  (Cencode70 & ocsrc==443) |
  (Cencode80 & ocsrc==658) |
  (Cencode00 & ocsrc==851);

/* Other precision woodworkers */
replace ocdest=659 if
  (Cencode80 & ocsrc==659);  /* other precision woodworkers */

/* these two below combine into one category in 2000 */

/* Dressmakers/seamstresses */
replace ocdest=666 if
  (Cencode60 & ocsrc==651) | 
  (Cencode70 & ocsrc==613) |
  (Cencode80 & ocsrc==666) |
  (Cencode00 & ocsrc==835);

/* Tailors */
replace ocdest=667 if
  (Cencode60 & ocsrc==524) |
  (Cencode70 & ocsrc==551) |
  (Cencode80 & ocsrc==667);

/* Upholsterers */
replace ocdest=668 if
  (Cencode60 & ocsrc==535) |
  (Cencode70 & ocsrc==401) |  /* auto accessories installers */
  (Cencode70 & ocsrc==563) |
  (Cencode80 & ocsrc==668) |
  (Cencode00 & ocsrc==845);

/* Shoe repairers */
replace ocdest=669 if
  (Cencode70 & ocsrc==542) |
  (Cencode80 & ocsrc==669) |
  (Cencode00 & ocsrc==833);

/* Other precision apparel and fabric workers */
replace ocdest=674 if
  (Cencode60 & ocsrc==432) |  /* furriers */
  (Cencode60 & ocsrc==705) |  /* sewers and stitchers, manufacturing */
  (Cencode60 & ocsrc==680) |  /* milliners (workers on women's hats) */
  (Cencode70 & ocsrc==444) |
  (Cencode70 & ocsrc==636) |  /* milliners (workers on women's hats) */
  (Cencode80 & ocsrc==674);

/* Hand molders, shapers, grinders, and polishers,
and other hand work; see 786, 787, 793
except jewelers */
replace ocdest=675 if
  (Cencode70 & ocsrc==546) |  /* stone cutters and carvers */
  (Cencode80 & ocsrc==675) |
  (Cencode80 & ocsrc==786) |  /* !@#$ study again */
  (Cencode80 & ocsrc==787) |  /* !@#$ study again */
  (Cencode80 & ocsrc==793) |  /* !@#$ study again */
  (Cencode80 & ocsrc==794) |  /* !@#$ study again */
  (Cencode80 & ocsrc==795) |  /* !@#$ study again */
  (Cencode00 & ocsrc==892);

/* Optical goods workers
   1968-1982:  Opticians, and lens grinders and polishers */
replace ocdest=677 if
  (Cencode60 & ocsrc==494) |
  (Cencode70 & ocsrc==506) |
  (Cencode80 & ocsrc==677) |
  (Cencode00 & ocsrc==352);

/* possibly combine 677 & 678 based on 1990/2000 mapping */

/* Dental laboratory technicians
   [and medical appliance technicians, after 1983] */
replace ocdest=678 if
  (Cencode70 & ocsrc==426) |
  (Cencode80 & ocsrc==678) |
  (Cencode00 & ocsrc==341) |
  (Cencode00 & ocsrc==876);

/* Bookbinders */
replace ocdest=679 if
  (Cencode60 & ocsrc==404) |
  (Cencode70 & ocsrc==405) |
  (Cencode80 & ocsrc==679) |
  (Cencode00 & ocsrc==823);

/* Other precision and craft workers */
replace ocdest=684 if
  (Cencode60 & ocsrc==545) |  /* craftspersons, nec */
  (Cencode80 & ocsrc==684) |
  (Cencode00 & ocsrc==812);   /* multiple machine tool setters, operators, and tenders, metal and plastic */

/* Butchers and meat cutters */
replace ocdest=686 if
  (Cencode60 & ocsrc==675) | /* meat cutters outside slaughter&packing houses */
  (Cencode70 & ocsrc==631) |
  (Cencode70 & ocsrc==633) |
  (Cencode80 & ocsrc==686) |
  (Cencode00 & ocsrc==781);

/* Bakers */
replace ocdest=687 if
  (Cencode60 & ocsrc==401) |
  (Cencode70 & ocsrc==402) |
  (Cencode80 & ocsrc==687) |
  (Cencode00 & ocsrc==780);

/* Batch food makers */
replace ocdest=688 if
  (Cencode80 & ocsrc==688) |
  (Cencode00 & ocsrc==784);

/* Adjusters and calibrators */
replace ocdest=693 if
  (Cencode80 & ocsrc==693);

/* Water and sewage treatment plant operators */
replace ocdest=694 if
  (Cencode80 & ocsrc==694) |
  (Cencode00 & ocsrc==862);

/* Power plant operators */
replace ocdest=695 if
  (Cencode60 & ocsrc==701) |
  (Cencode70 & ocsrc==525) | /* power station operators */
  (Cencode80 & ocsrc==695) |
  (Cencode00 & ocsrc==860);

/* Stationary engineers (plant and system operators) */
replace ocdest=696 if
  (Cencode60 & ocsrc==520) |
  (Cencode70 & ocsrc==545) |
  (Cencode80 & ocsrc==696) |
  (Cencode00 & ocsrc==861);

/* Other plant and system operators */
replace ocdest=699 if
  (Cencode80 & ocsrc==699) |  /* misc plant and system opers */
  (Cencode00 & ocsrc==863);

/* Lathe, milling, and turning machine operatives */
replace ocdest=703 if
  (Cencode60 & ocsrc==452) |
  (Cencode70 & ocsrc==454) |
  (Cencode70 & ocsrc==652) |   /* Lathe and milling machine operatives */
  (Cencode70 & ocsrc==653) |   /* Precision machine operatirves, n.e.c. */
  (Cencode80 & ocsrc==705) |   /* Milling and planing machine operatives */
  (Cencode80 & ((ocsrc==703) | (ocsrc==704))) |
        /* Lathe and turning machine set-up and operators */
  (Cencode00 & ocsrc==801) |
  (Cencode00 & ocsrc==802);   /* milling and planing machine setters, operators, and tenders, metal and other */

/* 1971-82  Punch and stamping press operatives
   1983-    Punching and stamping press machine operators */
replace ocdest=706 if
  (Cencode70 & ocsrc==656) |
  (Cencode80 & ocsrc==706) |
  (Cencode00 & ocsrc==795);

/* 1968  Rollers and roll hands, metal
   1971  Rollers and finishers, metal
   1983-   Rolling machine operators */
replace ocdest=707 if
  (Cencode60 & ocsrc==513) |
  (Cencode70 & ocsrc==533) |
  (Cencode80 & ocsrc==707) |
  (Cencode00 & ocsrc==794);

/* Drilling and boring machine operators */
replace ocdest=708 if
  (Cencode70 & ocsrc==650) |  /* drill press operatives */
  (Cencode80 & ocsrc==708) |
  (Cencode00 & ocsrc==796);
  /* drilling and boring machine tool setters, operators, and tenders, metal and plastic */

/* Grinding, abrading, buffing, & polishing machine operators */
replace ocdest=709 if
  (Cencode60 & ocsrc==521) |
  (Cencode60 & ocsrc==653) | /* filers, grinders, and polishers of metal */
  (Cencode70 & ocsrc==621) | /* filers, polishers, sanders, and buffers */
  (Cencode70 & ocsrc==651) |
  (Cencode80 & ocsrc==709) |
  (Cencode00 & ocsrc==800);

/* Forge and hammer operators */
replace ocdest=713 if
  (Cencode60 & ocsrc==402) |  /* blacksmiths.  N=295 */
  (Cencode60 & ocsrc==431) |
  (Cencode70 & ocsrc==442) |
  (Cencode80 & ocsrc==713) |
  (Cencode00 & ocsrc==793);

/* Fabricating machine operators, n.e.c. */
replace ocdest=717 if
  (Cencode70 & ocsrc==660) |  /* riveters and fasteners */
  (Cencode80 & ocsrc==717);

/* Molders, their apprentices, and molding and casting machine operators */
replace ocdest=719 if
  (Cencode60 & ocsrc==492) |
  (Cencode70 & ((ocsrc==503) | (ocsrc==504))) |
  (Cencode80 & ocsrc==719) |
  (Cencode00 & ((ocsrc==810) | (ocsrc==892)));

/* Metal platers, and operators of metal plating machines */
replace ocdest=723 if 
  (Cencode70 & ocsrc==635) |
  (Cencode80 & ocsrc==723) |
  (Cencode00 & ocsrc==820);

/* Heat treating equipment operators */
replace ocdest=724 if
  (Cencode60 & ocsrc==435) |
  (Cencode70 & ocsrc==446) |
  (Cencode70 & ocsrc==626) |  /* heaters, metal */
  (Cencode80 & ocsrc==724) |
  (Cencode00 & ocsrc==815);

/* Wood lathe, routing, and planing machine operators */
replace ocdest=726 if 
  (Cencode80 & ocsrc==726) |
  (Cencode00 & ocsrc==822);

/* Sawing machine operators ["Sawyers" before 1982] */
replace ocdest=727 if
  (Cencode60 & ocsrc==704) |
  (Cencode70 & ocsrc==662) |
  (Cencode80 & ocsrc==727) |
  (Cencode00 & ocsrc==853);

/* Shaping and joining machine operators (woodworking) */
replace ocdest=728 if
  (Cencode80 & ocsrc==728);

/* Nail and tacking machine operators  (woodworking) */
replace ocdest=729 if
  (Cencode80 & ocsrc==729) |
  (Cencode00 & ocsrc==854);

/* Other woodworking machine operators */
replace ocdest=733 if
  (Cencode80 & ocsrc==733) |
  (Cencode00 & ocsrc==855);

/* Printing machine operators, n.e.c. */
replace ocdest=734 if
  (Cencode60 & ocsrc==512) |
  (Cencode60 & ocsrc==615) |
  (Cencode70 & ocsrc==423) |  /* printing traces apprentices, n.e.c. */
  (Cencode70 & ocsrc==434) |  /* electrotypers and stereotypers */
  (Cencode70 & ocsrc==530) |
  (Cencode70 & ocsrc==531) |  /* printing press apprentices */
  (Cencode80 & ocsrc==734) |  /* printing machine operators */
  (Cencode80 & ocsrc==737) |  /* misc printing machine operators */
  (Cencode00 & ocsrc==824);

/* Photoengravers and lithographers */
replace ocdest=735 if
  (Cencode60 & ocsrc==423) |  /* electrotypers and stereotypers */
  (Cencode60 & ocsrc==503) |
  (Cencode70 & ocsrc==515) |
  (Cencode80 & ocsrc==735);

/* data from census 2000 suggests 735 and 736 could be combined sensibly
   and that one of them is small, otherwise */

/* Typesetters and compositors */
replace ocdest=736 if
  (Cencode60 & ocsrc==414) | /* compositors and typesetters */
  (Cencode70 & ocsrc==422) | /* compositors and typesetters, except apprentices */
  (Cencode80 & ocsrc==736) |
  (Cencode00 & ocsrc==825) |
  (Cencode00 & ocsrc==826);

/* 1971-82    Winding operatives, n.e.c.
   1983-2001  Winding and twisting machine operators (textile/apparel) */
replace ocdest=738 if
  (Cencode70 & ocsrc==672) |  /* spinners, twisters, and winders */
  (Cencode70 & ocsrc==681) |
  (Cencode80 & ocsrc==738) |
  (Cencode00 & ocsrc==842);

/* Textile operatives: knitting, looping, taping, and weaving machine opers */
replace ocdest=739 if
  (Cencode60 & ocsrc==673) | /* Knitters, loopers, and toppers, textile */
  (Cencode60 & ocsrc==720) | /* weavers, textile */
  (Cencode70 & ocsrc==671) | /* Knitters, loopers, and toppers */
  (Cencode70 & ocsrc==673) | /* weavers */
  (Cencode80 & ocsrc==739) | /* Knitting, looping, taping, & weaving machine operators */
  (Cencode00 & ocsrc==841);

/* Textile cutting machine operators */
replace ocdest=743 if
  (Cencode80 & ocsrc==743) |
  (Cencode00 & ocsrc==840);

/* Textile sewing machine operators */
replace ocdest=744 if
  (Cencode70 & ocsrc==663) |   /* sewers and stitchers */
  (Cencode80 & ocsrc==744) |
  (Cencode00 & ocsrc==832);

/* Shoemaking machine operators */
replace ocdest=745 if
  (Cencode60 & ocsrc==515) |  /* shoe making and repair; */
                              /* possibly splittable into this and 669 !@#$ */
  (Cencode70 & ocsrc==664) |
  (Cencode80 & ocsrc==745) |
  (Cencode00 & ocsrc==834);

/* Pressing machine operators (textiles and clothing) */
replace ocdest=747 if
  (Cencode80 & ocsrc==747) |
  (Cencode00 & ocsrc==831);

/* Laundry workers */
replace ocdest=748 if
  (Cencode60 & ((ocsrc==674) | (ocsrc==803))) |
        /* Household laundresses; laundry & dry cleaning operatives */
  (Cencode70 & ((ocsrc==611) | (ocsrc==630) | (ocsrc==983))) |
        /* Clothing ironers & pressers; launderers, private household;
           laundry and dry cleaning operatives, n.e.c. */
  (Cencode80 & ((ocsrc==403) | (ocsrc==748))) |
        /* Launderers and ironers, private household   (n=0?)  and
           Laundering and dry cleaning machine operators (n=1600) */
  (Cencode00 & ocsrc==830);  /* Launderers and ironers */

/* Misc textile machine operators */
replace ocdest=749 if
  (Cencode60 & ocsrc==710) |   /* spinners, textile */
  (Cencode70 & ocsrc==670) |   /* carding, lapping, and combing operatives */
  (Cencode70 & ocsrc==674) | /* textile operatives, n.e.c. */
  (Cencode80 & ocsrc==749) |
  (Cencode00 & ocsrc==836) | /* textile bleaching & dyeing machine operators */
  (Cencode00 & ocsrc==846);

/* Cementing and gluing machine operators */
replace ocdest=753 if
  (Cencode80 & ocsrc==753) |
  (Cencode00 & ocsrc==885);

/* Packaging and filling operators; packers and wrappers except meat
   and produce; packers and wrappers, n.e.c. */
replace ocdest=754 if
  (Cencode60 & ocsrc==693) |
  (Cencode70 & ocsrc==604) |  /* bottling and canning operatives */
  (Cencode70 & ocsrc==643) |
  (Cencode80 & ocsrc==754) |
  (Cencode00 & ocsrc==880);

/* Extruding, forming, and compressing machine operators */
replace ocdest=755 if
  (Cencode80 & ocsrc==755) |
  (Cencode80 & ocsrc==758) |
  (Cencode00 & ocsrc==792) |
  (Cencode00 & ocsrc==843) |
  (Cencode00 & ocsrc==872);

/* Mixing and blending machine operatives */
replace ocdest=756 if
  (Cencode60 & ocsrc==652) |   /* dyers */
  (Cencode70 & ocsrc==620) |   /* dyers */
  (Cencode70 & ocsrc==641) |
  (Cencode80 & ocsrc==756) |
  (Cencode00 & ocsrc==865);    /* crushing, grinding, polishing, mixing, and blending workers */

/* Separating, filtering, and clarifying machine operators */
replace ocdest=757 if
  (Cencode80 & ocsrc==757) |
  (Cencode00 & ocsrc==864);

/* Painting machine operators */
replace ocdest=759 if
  (Cencode60 & ocsrc==694) | /* painters except construction and maintenance */
  (Cencode70 & ocsrc==644) | /* painters of manufactured articles */
  (Cencode80 & ocsrc==759) | /* paint and paint spraying machine operators */
  (Cencode00 & ocsrc==881);

/* Roasting and baking machine operators, food */
replace ocdest=763 if
  (Cencode80 & ocsrc==763) |
  (Cencode00 & ocsrc==783);

/* Washing, cleaning, and pickling machine operators */
replace ocdest=764 if
  (Cencode80 & ocsrc==764) |
  (Cencode00 & ocsrc==886);

/* Folding machine operators (paper goods processing) */
replace ocdest=765 if
  (Cencode80 & ocsrc==765) |
  (Cencode00 & ocsrc==893);
 
/* Furnace, kiln, and oven operators, apart from food */
replace ocdest=766 if
  (Cencode60 & ocsrc==670) | /* furnacemen, smelters, and pourers */
  (Cencode60 & ocsrc==672) | /* heaters of metal */
  (Cencode60 & ocsrc==712) | /* stationary firemen */
  (Cencode70 & ocsrc==622) | /* metal furnace tenders, smelters, and pourers */
  (Cencode70 & ocsrc==666) | /* furnace tenders and stokers, except metal */
  (Cencode80 & ocsrc==766) |
  (Cencode00 & ocsrc==804) |
  (Cencode00 & ocsrc==873);

/* Crushing and grinding machine operators */
replace ocdest=768 if
  (Cencode60 & ocsrc==490) |  /* millers of grain, etc */
  (Cencode70 & ocsrc==501) |
  (Cencode80 & ocsrc==768);

/* Slicing and cutting machine operators, outside textiles */
replace ocdest=769 if
  (Cencode70 & ocsrc==612) |  /* cutting operatives, n.e.c. */
  (Cencode80 & ocsrc==769) |
  (Cencode00 & ocsrc==785) |
  (Cencode00 & ocsrc==871);

/* Motion picture projectionists */
replace ocdest=773 if
  (Cencode60 & ocsrc==493) |
  (Cencode70 & ocsrc==505) |
  (Cencode80 & ocsrc==773) |
  (Cencode00 & ocsrc==441);

/* Photographic process workers */
replace ocdest=774 if
  (Cencode60 & ocsrc==695) |
  (Cencode70 & ocsrc==645) |
  (Cencode80 & ocsrc==774) |
  (Cencode00 & ocsrc==883);

/* Machine operators, nec */
replace ocdest=779 if
  (Cencode60 & ocsrc==775) |  /* weavers, textile */
  (Cencode70 & ocsrc==690) |  /* machine operatives n.e.c. */
  (Cencode70 & ocsrc==692) |  /* maching operatives, not specific */
  (Cencode70 & ocsrc==694) |  /* misc operatives */
  (Cencode70 & ocsrc==695) |  /* operatives, not specified */
  (Cencode70 & ocsrc==696) |  /* operatives, except transport, allocated */
  (Cencode80 & ocsrc==673) |  /* fabric patternmakers */
  (Cencode80 & ocsrc==777) |
  (Cencode80 & ocsrc==714) |   /* operators of numerically controlled machines (a tiny group) */
  (Cencode80 & ocsrc==715) |   /* misc metal, plastic, stone, and glass working machine operators */
  (Cencode80 & ocsrc==725) |   /* misc metal and plastic processing machine operators */
  (Cencode80 & ocsrc==779) |
  (Cencode80 & ocsrc==798) |  /* production testers */
  (Cencode00 & ocsrc==884) | /* semiconductor processing jobs */
  (Cencode00 & ocsrc==890) | /* cooling and freezing equipment operators and tenders */
  (Cencode00 & ocsrc==894) | /* tire builders */
  (Cencode00 & ocsrc==896);  /* other production workers incl semic */
                             /* processors, cooling and freezing operators */

/* Welders and cutters ["flame-cutters" pre-1982] */
replace ocdest=783 if
  (Cencode60 & ocsrc==721) |
  (Cencode70 & ocsrc==680) |
  (Cencode80 & ocsrc==783) |
  (Cencode00 & ocsrc==814);

/* Solderers [and "brazers", after 1983] */
replace ocdest=784 if
  (Cencode70 & ocsrc==665) |
  (Cencode80 & ocsrc==784);
    /* there are many more 'welders' than 'solderers' so 2000 category
       814 is a better match to category 783 than to this one */

/* Assemblers (e.g. of electrical equipment) */
replace ocdest=785 if
  (Cencode60 & ocsrc==631) |
  (Cencode70 & ocsrc==602) |
  (Cencode80 & ocsrc==636) |  /* precision assemblers, metal */
  (Cencode80 & ocsrc==683) |
  (Cencode80 & ocsrc==785) |
  (Cencode00 & ((ocsrc==771) | (ocsrc==772)|(ocsrc==773) | (ocsrc==775)));

/* Hand painting, coating, and decorating occupations */
replace ocdest=789 if
  (Cencode70 & ocsrc==543) |  /* sign painters and letterers */
  (Cencode80 & ocsrc==789);
 
/* Production checkers and inspectors */
replace ocdest=796 if
  (Cencode60 & ocsrc==643) |  /* checkers, examiners, and inspectors, nec */
  (Cencode70 & ocsrc==452) |  /* inspectors, n.e.c. */
  (Cencode70 & ocsrc==610) |  /* checkers, examiners, and inspectors, manufacturing */
  (Cencode80 & ocsrc==689) |  /* inspectors, testers, and graders */
  (Cencode80 & ocsrc==796) |   /* production inspectors, checkers,& examiners */
  (Cencode80 & ocsrc==797);   /* production testers */

 /* Graders and sorters, phrased differently in each period:
     ["Grader, dozer, and scraper operators"  1983-1992   and
      "Graders and sorters, exc. agricultural" post-1991  and
      "Graders and sorters, manufacturing"     in 1968-82 and
      "Graders, and sorters (production testers/samplers), exc.
        agricultural" after 1982]  */
replace ocdest=799 if
  (Cencode60 & ocsrc==671) |
  (Cencode70 & ocsrc==624) |  /* graders and sorters, manufacturing */
  (Cencode70 & ocsrc==625) |  /* produce graders and packers, except factory and farm */
  (Cencode80 & ocsrc==799) |  /* graders and sorters, except agricultural */
  (Cencode00 & ocsrc==874);

/* Supervisors of transportation; of motor vehicle operators */
replace ocdest=803 if
  (Cencode80 & ocsrc==803) |
  (Cencode80>1 & ocsrc==864) |  /* supvs of equipment handling and cleaning */
  (Cencode00 & ocsrc==900);

/* Truck drivers, tractor equipment operators, and delivery workers */
replace ocdest=804 if
  (Cencode60 & ((ocsrc==650) | (ocsrc==715)|
     (ocsrc==971) |             /* teamsters */
     (ocsrc==972))) |           /* truck driver helpers */
  (Cencode70 & ocsrc==705) |
  (Cencode70 & ocsrc==706) |  /* forklift and tow motor operatives */
  (Cencode70 & ocsrc==715) |
  (Cencode70 & ocsrc==763) |
  (Cencode80 & ((ocsrc==804) |   /* "heavy" trucks */
    (ocsrc==805) |   /* "light" trucks */
    (ocsrc==806) |   /* "driver-sales" wrkrs */
    (ocsrc==856))) | /* "industrial truck and tractor equipment operators" */
  (Cencode00 & ((ocsrc==751) | (ocsrc==913) | (ocsrc==960)));
        /* Driver/Sales workers and truck drivers */

/* Bus drivers */
replace ocdest=808 if
  (Cencode60 & ocsrc==641) |
  (Cencode70 & ocsrc==703) |
  (Cencode80 & ocsrc==808) |
  (Cencode00 & ocsrc==912);

/* Taxi cab drivers and chauffeurs, and motor transport, nec */
replace ocdest=809 if
  (Cencode60 & ocsrc==714) |
  (Cencode70 & ocsrc==714) |
  (Cencode80 & ocsrc==809) |
  (Cencode80 & ocsrc==814) |
  (Cencode00 & ocsrc==911) |  /* ambulance drivers, not counting emergency medical techs */
  (Cencode00 & ocsrc==914) |
  (Cencode00 & ocsrc==915);

/* Parking lot attendants */
replace ocdest=813 if
  (Cencode70 & ocsrc==711) |
  (Cencode80 & ocsrc==813) |
  (Cencode00 & ocsrc==935);

/* Railroad conductors and yardmasters */
replace ocdest=823 if
  (Cencode60 & ocsrc==252) |   /* railroad conductors */
  (Cencode60 & ocsrc==645) |   /* bus and street railway conductors */
  (Cencode70 & ocsrc==226) |
  (Cencode80 & ocsrc==823) |
  (Cencode00 & ocsrc==924);

/* Locomotive operating occupations - engineers and firemen */
replace ocdest=824 if
  (Cencode60 & ocsrc==454) |   /* engineers */
  (Cencode60 & ocsrc==460) |   /* firemen */
  (Cencode60 & ocsrc==691) |  /* motormen for street,subway,& elevated railways */
  (Cencode70 & ocsrc==455) |   /* engineers */
  (Cencode70 & ocsrc==456) |   /* firemen */
  (Cencode70 & ocsrc==710) |   /* motormen in factories, mines, logging camps; 
                        or, rail vehicle operators, n.e.c.  sources differ */
  (Cencode80 & ocsrc==824) |
  (Cencode80 & ocsrc==826) |
  (Cencode00 & ocsrc==920) | /* locomotive engineers and operators */
  (Cencode00 & ocsrc==926); /* subway, streetcar, and other rail transport jobs */

/* Cencode70   Railroad brake operators, couplers, and switch operators
   Cencode80   Railroad brake, signal, and switch operators */
replace ocdest=825 if
  (Cencode60 & ocsrc==640) | /* railroad brakemen */
  (Cencode60 & ocsrc==713) | /* railroad switchmen */
  (Cencode70 & ocsrc==712) | /* brake operators &couplers */
  (Cencode70 & ocsrc==713) | /* Railroad switch operators */
  (Cencode80 & ocsrc==825) |
  (Cencode00 & ocsrc==923) ;

/* Sailors, deck hands, ship captains, mates, and engineers */
replace ocdest=829 if
  (Cencode60 & ocsrc==265) |
  (Cencode60 & ocsrc==703) |
  (Cencode70 & ocsrc==221) |  /* ship officers, pilots, and pursers */
  (Cencode70 & ocsrc==661) |
  (Cencode70 & ocsrc==701) |  /* boat operators */
  (Cencode80 & ocsrc==497) |
  (Cencode80 & ocsrc==828) | (Cencode80 & ocsrc==829) |
  (Cencode80 & ocsrc==833) |
  (Cencode00 & ((ocsrc==930) | (ocsrc==931) | (ocsrc==933)));

/* Water transport infrastructure tenders; also crossing guards */
replace ocdest=834 if
  (Cencode60 & ocsrc==635) |   /* boatmen, canalmen, and lock tenders */
  (Cencode60 & ocsrc==860) |   /* watchmen (crossing) and bridge tenders */
  (Cencode80 & ocsrc==834) |  /* bridge, lock, and lighthouse tenders */
  (Cencode00 & ocsrc==934);   /* bridge and lock tenders */

/* Operating engineers (of construction equipment) */
replace ocdest=844 if
  (Cencode70 & ocsrc==436) |  /* excavating, grading, and road machine operators */
  (Cencode80 & ocsrc==844) |
  (Cencode00 & ocsrc==632);

/* Crane, tower, hoist, and winch operators 1983 and on.
   Crane, derrick, and hoist operators 1968-1982 */
replace ocdest=848 if
  (Cencode60 & ocsrc==415) |
  (Cencode70 & ocsrc==424) |
  (Cencode80 & ((ocsrc==848) | (ocsrc==849))) |
  (Cencode00 & ocsrc==951) | /* crane and tower operators */
  (Cencode00 & ocsrc==956);  /* hoist and winch operators */

/* Excavating and loading machine operators */
replace ocdest=853 if
  (Cencode60 & ocsrc==425) |
  (Cencode80 & ocsrc==853) | /* excavating and loading machine operators */
  (Cencode00 & ocsrc==952); /* dredge, excavating, and loading machine operators */

/* Misc material moving occs */
replace ocdest=859 if
  (Cencode60 & ocsrc==690) | /* motormen at mines, factories, logging camps */
  (Cencode70 & ocsrc==726) | /* transport equipment operatives, allocated */
  (Cencode80 & ocsrc==843) | /* supvs of material moving operators */
  (Cencode80 & ocsrc==859) | /* misc material moving occs */
  (Cencode00 & ocsrc==965) | /* pumping station operators */
  (Cencode00 & ocsrc==973);  /* shuttle car operators */

/* Helpers, construction */
replace ocdest=865 if
  (Cencode80 & ocsrc==865) |
  (Cencode00 & ocsrc==761);

/* Helpers, surveyors */
replace ocdest=866 if
  (Cencode70 & ocsrc==605) | /* chainment, rodmen, and axemen, surveying */
  (Cencode80 & ocsrc==866) |
  (Cencode00 & ocsrc==660);

/* Construction laborers */
replace ocdest=869 if
  (Cencode70 & ocsrc==750) |  /* carpenters' helpers */
  (Cencode70 & ocsrc==751) |
  (Cencode80 & ocsrc==869) |
  (Cencode00 & ocsrc==626) |
  (Cencode00 & ocsrc==673) |  /* highway maintenance workers */
  (Cencode00 & ocsrc==693);   /* helpers to extraction workers */

/* Production helpers */   /* changed from 873 to 874 on 12/15/2008 */
replace ocdest=874 if
  (Cencode80 & ocsrc==873) |
  (Cencode80 & ocsrc==874) |
  (Cencode00 & ocsrc==895);

/* Garbage collectors */
replace ocdest=875 if
  (Cencode70 & ocsrc==754) |
  (Cencode80 & ocsrc==875) |
  (Cencode00 & ocsrc==972);
    /* cen 2000: "Refuse and recyclable material collectors" */

/* Materials movers:  Stevedores, longshore workers,
   longshore equipment operators */
replace ocdest=876 if
  (Cencode60 & ocsrc==965) | (Cencode70 & ocsrc==760) |
  (Cencode80 & ((ocsrc==845) | (ocsrc==876))) |
  (Cencode00 & ((ocsrc==950)|(ocsrc==974)));

/* Stock handlers [and baggers, post-1982] */
replace ocdest=877 if
  (Cencode70 & ocsrc==762) |
  (Cencode80 & ocsrc==877) |
  (Cencode00 & ocsrc==962);

/* Machine feeders and offbearers */
replace ocdest=878 if
  (Cencode80 & ocsrc==878) |
  (Cencode00 & ocsrc==963);

/* Freight, stock, and materials handlers */
replace ocdest=883 if
  (Cencode60 & ocsrc==973) |  /* warehousemen, nec */
  (Cencode70 & ocsrc==753) |  /* freight and materials handlers */
  (Cencode80 & ocsrc==883) |  /* freight, stock, and materials handlers, nec */
  (Cencode00 & ocsrc==942);  /* misc transport workers, incl bridge/lock tenders */

/* Garage and service station related occupations */
replace ocdest=885 if
  (Cencode60 & ocsrc==632) |
  (Cencode70 & ocsrc==623) |
  (Cencode80 & ocsrc==885) |
  (Cencode00 & ocsrc==936);

/* Vehicle washers and equipment cleaners */
replace ocdest=887 if
  (Cencode60 & ocsrc==963) |  /* garage laborers and car washers and greasers */
  (Cencode70 & ocsrc==764) |
  (Cencode80 & ocsrc==887) |
  (Cencode00 & ocsrc==961);

/* Packers and packagers, by hand */
replace ocdest=888 if
  (Cencode70 & ocsrc==634) |  /* meat wrappers, retail */
  (Cencode80 & ocsrc==888) |
  (Cencode00 & ocsrc==964);

/* Laborers outside construction */
replace ocdest=889 if
  (Cencode60 & ocsrc==985) |
  (Cencode70 & ocsrc==770) |   /* warehousemen, n.e.c. */
  (Cencode70 & ocsrc==780) |   /* misc laborers */
  (Cencode70 & ocsrc==785) |   /* laborers, not specfied */
  (Cencode70 & ocsrc==796) |   /* nonfarm laborers, allocated */
  (Cencode80>1 & ocsrc==868) |
  (Cencode80>1 & ocsrc==874) |
  (Cencode80 & ocsrc==889) |
  (Cencode00 & ocsrc==674) |
  (Cencode00 & ocsrc==675) |
  (Cencode00 & ocsrc==962);

/* All military ; definition matches IPUMS's occ1950 */
replace ocdest=905 if
  (empstat == 14 | empstat == 15) |
  (Cencode60 & (ocsrc==555)) |
        /* CPS does not have this but Cen 1960 says */
        /*  "former member of the armed forces" -- yes, see */
        /*  http://www.ipums.umn.edu/usa/volii/96occup.html */
        /* note:  many Cencode60==990's have the empstat== 14 or 15 */
  (Cencode70 & (ocsrc==580)) |
  (Cencode80 & ((ocsrc==903)|(ocsrc==904)|(ocsrc==905)))  |
  (Cencode00 & ((ocsrc==980)|(ocsrc==981)|(ocsrc==982)|(ocsrc==983)|(ocsrc==984)));

/* Unemployed */
replace ocdest=991 if
  (Cencode70 & ocsrc==991) |
  (Cencode00 & ocsrc==992);

/* Not known */  /* I did not study this, just copied from occ1950 !@#$ */
                 /* removed 962 (2000) from this list because it's a dupe */
replace ocdest=999 if
  (empstat~=14 & empstat~=15) &    /* not armed forces, and ... */
  ((Cencode60 & ocsrc==990) |
   (Cencode60 & ocsrc==995) |
   (Cencode60 & ocsrc==999) | /* these come up in the CPS */
   (Cencode70 & ocsrc==0)   |
   (Cencode70 & ocsrc==659) | /* not documented, but IPUMS has one in 1977 CPS; covered 8/18/2007 */
   (Cencode70 & ocsrc==775) | /* not documented, but IPUMS has 5 in 1971-5 CPSes; covered 8/20/2007 */
   (Cencode70 & ocsrc==995) |
   (Cencode70 & ocsrc==999) | /* "no occupation" in 1971-75 in CPS */
   (Cencode80 & ocsrc==0)   | /* observed and handled 8/20/07; ind=0 for these too */
   (Cencode80 & ocsrc==909) |
   (Cencode00 & ocsrc==0));

tab ocsrc if ocdest==. | ocdest==0;

assert ocdest ~= 0;
assert ocdest ~= .;
gen tst1 = occ1950 == 595;
gen tst2 = ocdest == 905;
capture assert tst1 == tst2;

* !! there are three cases in 1970 CPS of people with job 555 (former armed forces)
* !! which are mapped to 'unknown' in occ1950.  I could do that but it seems
* !! like this is reasonable too.  I'm remaining open.

list if tst1 ~= tst2;
drop tst1 tst2;

compress;

exit;
