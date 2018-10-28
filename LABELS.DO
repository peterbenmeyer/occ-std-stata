/* Stata program for inequality and personal computers */

#delimit ;  /* make ; the end-of-command delimiter for multiline commands */

capture label drop locccode;
label define locccode
     3  "Legislators"
     4  "Chief executives, public administrators";

/* For debugging it turns out to be better to add the labels one by one;
   then if there is a problem with one, Stata reports the problem more quickly
   than if they were in one long list */

label define locccode 7  "Financial managers", add;
label define locccode  8  "Human resources and labor relations managers", add;
label define locccode 13  "Marketing/adverting/PR mgrs/specialists", add;
label define locccode 14  "Managers in education", add;
label define locccode 15  "Medical and health managers", add;
label define locccode 16  "Postmasters and mail superintendents", add;
label define locccode 17  "Food and lodging establishment managers", add;
label define locccode 18  "Managers of buildings and properties", add;
label define locccode 19  "Funeral directors", add;
label define locccode 21  "Managers of service organizations n.e.c.", add;
label define locccode 22  "Managers, nec", add;  /* administrators, officials, proprietors, n.e.c. */
label define locccode 23  "Accountants and auditors", add;
label define locccode 24  "Insurance underwriters", add;
label define locccode 25  "Other financial specialists", add;
label define locccode 26  "Management analysts", add;
label define locccode 27  "Personnel/training/labor relations specialists", add;
label define locccode 28  "Buyers of farm products", add;
label define locccode 29  "Buyers in wholesale and retail trade", add;
label define locccode 33  "Purchasing managers, agents and buyers nec", add;
label define locccode 34  "Business and promotion agents", add;
label define locccode 35  "Construction inspectors", add;  /* could add real estate appraisers here */
label define locccode 36  "Inspectors/compliance officers exc construction", add;
label define locccode 37  "Management related support jobs", add;
label define locccode 43  "Architects", add;
label define locccode 44  "Aerospace engineers", add;
label define locccode 45  "Materials/metallurgical engrs", add;
label define locccode 47  "Petroleum/mining/geo engrs", add;
label define locccode 48  "Chemical engineers", add;
label define locccode 53  "Civil engineers", add;
label define locccode 55  "Electrical engineers", add;
label define locccode 56  "Industrial engineers", add;
label define locccode 57  "Mechanical engineers", add;
label define locccode 59  "Engineers n.e.c.", add;
label define locccode 64  "Computer analyst/scientists", add;
label define locccode 65  "Operations researchers and analysts", add;
label define locccode 66  "Actuaries", add;
label define locccode 67  "Statisticians", add;
label define locccode 68  "Mathematical scientists", add;  /* mathematical scientists & mathematicians */
label define locccode 69  "Physicists and astronomers", add;
label define locccode 73  "Chemists", add;   /* probably including biochemists before 1980 */
label define locccode 74  "Atmospheric and space scientists", add;  /* too small a category */
label define locccode 75  "Geologists", add;  /* "and geodesists", 1982- , "and geophysicists", 1968-70 */
label define locccode 76  "Physical scientists, nec", add;
label define locccode 77  "Agricultural and food scientists", add;
label define locccode 78  "Biological scientists", add;
label define locccode 79  "Foresters and conservation scientists", add;
label define locccode 83  "Medical scientists", add;
label define locccode 84  "Physicians", add;
    /* "medical and osteopathic" in Cencode70; sometimes includes surgeons */
label define locccode 85  "Dentists", add;
label define locccode 86  "Veterinarians", add;
label define locccode 87  "Optometrists", add;
label define locccode 88  "Podiatrists", add;
label define locccode 89  "Other health and therapy jobs", add;
label define locccode 95  "Registered nurses", add;
label define locccode 96  "Pharmacists", add;
label define locccode 97  "Dietitians and nutritionists", add;
label define locccode 98  "Respiratory therapists", add;
label define locccode 99  "Occupational therapists", add;
label define locccode 103 "Physical therapists", add;
label define locccode 104 "Speech therapists", add;
label define locccode 105 "Therapists n.e.c.", add;
label define locccode 106 "Physicians' assistants", add;
label define locccode 113 "Earth/environmental/marine science instructors", add;
            /* !@#$ note: at home it looks like there are approximately zero
               in these next three categories.  figure out, and combine */
label define locccode 114 "Biology instructors", add; /* (apparently either secondary or postsecondary) */
label define locccode 115 "Chemistry instructors", add;
label define locccode 116 "Physics instructors", add;
label define locccode 118 "Psychology instructors", add;
label define locccode 119 "Economics instructors", add;
label define locccode 123 "History instructors", add; /* !#@$ a small category in 1980; not clear why */
label define locccode 125 "Sociology instructors", add;  /* !@#$ zero of these in 1980 census */
label define locccode 127 "Engineering instructors", add;
label define locccode 128 "Math instructors", add;  /* one of these in 1980 census */
label define locccode 139 "Education instructors", add;
label define locccode 145 "Law instructors", add;
label define locccode 147 "Theology instructors", add;
label define locccode 149 "Home economics instructors", add;
label define locccode 150 "Humanities instructors", add;
label define locccode 154 "Other academic subject instructors", add;
label define locccode 155 "Kindergarten and earlier school teachers", add;
label define locccode 156 "Primary school teachers", add;
label define locccode 157 "Secondary school teachers", add;
label define locccode 158 "Special education teachers", add;
label define locccode 159 "Other pre-college teachers", add;
label define locccode 163 "Vocational and educational counselors", add;
label define locccode 164 "Librarians", add;
label define locccode 165 "Archivists and curators", add;
label define locccode 166 "Economists", add;
label define locccode 167 "Psychologists", add;
label define locccode 168 "Sociologists", add;
label define locccode 169 "Social scientists n.e.c.", add;
label define locccode 173 "Urban and regional planners", add;
label define locccode 174 "Social workers", add;
label define locccode 175 "Recreation workers", add;
label define locccode 176 "Clergy and religious workers", add;
label define locccode 178 "Lawyers", add;
label define locccode 179 "Judges", add;
label define locccode 183 "Writers and authors", add;
label define locccode 184 "Technical writers", add;
label define locccode 185 "Designers", add;
label define locccode 186 "Musicians and composers", add;
label define locccode 187 "Actors directors and producers", add;
label define locccode 188 "Art and craft makers", add; 
  /* Artistic painters, sculptors, craft-artists, print-makers, and sometimes art teachers */
label define locccode 189 "Photographers", add;
label define locccode 193 "Dancers", add;  /* !@#$ and choreographers, but crap, only 3 in 1980 cens */
label define locccode 194 "Art and entertainment performers", add;
label define locccode 195 "Editors and reporters", add;
label define locccode 198 "Announcers", add;
label define locccode 199 "Athletes/sports instructors/referees", add;
label define locccode 200 "Professionals, n.e.c.", add;
label define locccode 203 "Clinical laboratory technologists", add;
label define locccode 204 "Dental hygienists", add;
label define locccode 205 "Health record technologists", add;
label define locccode 206 "Radiologic technologists", add;
label define locccode 207 "Licensed practical nurses", add;
label define locccode 208 "Health technologists and technicians, n.e.c.", add;
label define locccode 213 "Electrical eng techs", add;
label define locccode 214 "Engineering techs n.e.c.", add;
label define locccode 215 "Mech engrng techs", add;
label define locccode 217 "Drafters", add;
label define locccode 218 "Surveyors and mapping scientists and techs", add;
label define locccode 223 "Biological and ag techs", add;
label define locccode 224 "Chemical technicians", add;
label define locccode 225 "Other science technicians", add;
label define locccode 226 "Airplane pilots and navigators", add;
label define locccode 227 "Air traffic controllers", add;  /* !@#$ ZERO in 1980 census? */
label define locccode 228 "Broadcast equipment operators", add;
label define locccode 229 "Software developers", add;
label define locccode 233 "Programmers of machine tools", add;  /* numerically controlled */
label define locccode 234 "Legal assistants and paralegals", add;
label define locccode 235 "Technicians n.e.c.", add;
label define locccode 243 "Supervisors and proprietors of sales", add;
label define locccode 253 "Insurance sales occupations", add;  /* and brokers and underwriters */
label define locccode 254 "Real estate sales occupations", add;  /* e.g. "agents and brokers", pre-1983 */
label define locccode 255 "Financial sales occupations", add;
label define locccode 256 "Advertising and related sales jobs", add;
label define locccode 258 "Sales engineers", add;
label define locccode 274 "Sales occupations n.e.c.", add;
label define locccode 275 "Retail sales clerks", add;
label define locccode 276 "Cashiers", add;
label define locccode 277 "Door-to-door/street/news vendors", add;
label define locccode 283 "Sales demonstrators", add;
        /* !@#$ too small; should combine with 274 */
label define locccode 303 "Office supervisors", add;
label define locccode 308 "Computer equipment operators", add;
label define locccode 313 "Secretaries and administrative assistants", add;
label define locccode 314 "Stenographers", add;
label define locccode 315 "Typists", add;
label define locccode 316 "Interviewers", add;
label define locccode 317 "Hotel clerks", add;
label define locccode 318 "Ticket agents, transport and reservation sales", add;
label define locccode 319 "Receptionists", add;  /* (and information clerks?) */
             /* Receptionists and information clerks */
label define locccode 323 "Information clerks, nec", add;
label define locccode 326 "Correspondence and order clerks", add;
label define locccode 328 "Human resources clerks, exc payroll&timekeeping", add;
label define locccode 329 "Library assistants", add;
label define locccode 335 "File clerks", add;
label define locccode 336 "Records clerks", add;
label define locccode 337 "Bookkeepers/accounting/auditing clerks", add;
label define locccode 338 "Payroll and timekeeping clerks", add;
label define locccode 343 "Cost and rate clerks", add;
label define locccode 344 "Billing clerks and related", add;
label define locccode 345 "Duplicating machine operators", add;
label define locccode 346 "Mail and paper handlers, exc postal service", add;
label define locccode 347 "Office machine operators", add;
label define locccode 348 "Telephone operators", add;
label define locccode 349 "Other telecom operators, usually telegraph", add;
label define locccode 354 "Postal clerks, usually excluding mail carriers", add;
label define locccode 355 "Mail carriers, for postal service", add;
label define locccode  356 "Mail clerks, outside of post office", add;
       /* !@#$ those three should be combined; first two seem to have
           zero members in 1980 census */
label define locccode 357 "Messengers and office helpers", add;
label define locccode 359 "Dispatchers", add;
label define locccode 361 "Inspectors, n.e.c.", add;
label define locccode 364 "Traffic, shipping, and receiving clerks", add;
label define locccode 365 "Stock and inventory clerks", add;
label define locccode 366 "Meter readers", add;
label define locccode 368 "Weighers/measurers/checkers/samplers", add;
label define locccode 373 "Production planning, recording, distributing jobs", add;
label define locccode 375 "Insurance adjusters, examiners, & investigators", add;
label define locccode 376 "Customer svc reps/investigators exc insurance", add;
label define locccode 377 "Eligibility clerks for government programs", add;
label define locccode 378 "Bill and account collectors", add;
label define locccode 379 "General office clerks", add;
label define locccode 383 "Bank tellers", add;
label define locccode 384 "Proofreaders", add;
label define locccode 385 "Data entry keyers", add;
label define locccode 386 "Statistical clerks", add;
label define locccode 387 "Teacher's aides", add;
label define locccode 389 "Administrative support jobs n.e.c.", add;
label define locccode 405 "Housekeepers, butlers, stewards, maids", add;
label define locccode 407 "Private household cleaners and servants", add;
label define locccode 415 "Supervisors of guards", add;
label define locccode 417 "Fire fighting, prevention and inspection jobs", add;
label define locccode 418 "Police and detectives", add;
                        /* including some private detectives and investigators */
label define locccode 423 "Sheriffs, bailiffs and jailers", add; /* and 'other law enforcement' */
label define locccode 425 "Crossing guards and bridge tenders", add;
label define locccode 426 "Guards/watchmen/doorkeepers/private police", add;
label define locccode 427 "Protective service occupations n.e.c.", add;
label define locccode 434 "Bartenders", add;
label define locccode 435 "Waiter/waitress", add;
label define locccode 436 "Cooks and chefs", add;
label define locccode 438 "Food counter and fountain workers", add;
label define locccode 439 "Kitchen workers nec", add;
label define locccode 443 "Assistant to waiter/waitress", add;
label define locccode 444 "Misc food preparation workers", add;
label define locccode 445 "Dental assistants", add;
label define locccode 446 "Health aides except nursing", add;
label define locccode 447 "Nursing aides/orderlies/attendants", add;
label define locccode 448 "Supervisors of cleaning/building svc workers", add;
label define locccode 453 "Janitors", add;
label define locccode 454 "Elevator operators", add;
label define locccode 455 "Pest control occupations", add;
label define locccode 456 "Supervisors of personal service jobs", add;
label define locccode 457 "Barbers", add;
label define locccode 458 "Hairdressers and cosmetologists", add;
label define locccode 459 "Attendants at amusement & recreation facilities", add;
label define locccode 461 "Guides", add;
label define locccode 462 "Ushers", add;
label define locccode 463 "Public transportation attendants", add;
label define locccode 464 "Baggage porters and bellhops", add;
label define locccode 465 "Welfare service aides", add;
label define locccode 468 "Child care workers", add;
label define locccode 469 "Personal service occupations n.e.c.", add;
label define locccode 473 "Farmers", add;
label define locccode 474 "Horticultural specialty farmers", add;
label define locccode 475 "Farm managers except horticultural farms", add;
label define locccode 476 "Managers of horticultural specialty farms", add;
label define locccode 479 "Farm workers", add;
label define locccode 483 "Marine life cultivation workers", add;
label define locccode 484 "Nursery (farming) workers", add;
     /* Miscellaneous agricultural workers, incl. animal breeders */
label define locccode 485 "Supervisors of agricultural occupations", add;
label define locccode 486 "Gardeners/groundskeepers except on farms", add;
label define locccode 487 "Animal caretakers, except farm", add;
label define locccode 488 "Graders and sorters of agricultural products", add;
label define locccode 489 "Inspectors of agricultural products", add;
label define locccode 496 "Timber, logging, and forestry workers", add;
label define locccode 498 "Fishers and hunters and oystermen", add;
label define locccode 503 "Supervisors of mechanics and repairers", add;
label define locccode 505 "Automobile mechanics and their apprentices", add;
label define locccode 507 "Bus/truck/stationary engine mechanics", add;
label define locccode 508 "Aircraft engine mechanics", add;
label define locccode 509 "Small engine repairers", add;
label define locccode 514 "Auto body repairers and related", add;
label define locccode 516 "Farm and heavy equipment mechanics", add;
label define locccode 518 "Industrial machinery repair", add;
label define locccode 519 "Machinery maintenance occupations", add;
label define locccode 523 "Repairer of electrical industrial equipment", add;
label define locccode 525 "Data processing equipment repairers", add;
label define locccode 526 "Household appliance and power tools repairers", add;
label define locccode 527 "Telecom installers, repairers, and linemen", add;
label define locccode 533 "Misc electrical equipment repairers", add;
label define locccode 534 "Heating/air-cond/refrigeration mechanics", add;
label define locccode 535 "Precision makers/repairers/smiths", add;
                          /* Jewelers, watchmakers and repairers, goldsmiths, silversmiths,, add;
                             camera, watch, and musical instrument repairers */
label define locccode 536 "Locksmiths and safe repairers", add;
label define locccode 538 "Office machine repairers and mechanics", add;
label define locccode 539 "Mechanical control and valve repairers", add;
label define locccode 543 "Elevator installers and repairers", add;
label define locccode 544 "Millwrights", add;   /* Industrial and refractory machinery mechanics */
label define locccode 549 "Mechanics and repairers, n.e.c.", add;
label define locccode 558 "Supervisors of construction-type trade workers", add;
label define locccode 563 "Masons, tile setters, and carpet workers", add;
label define locccode 567 "Carpenters", add;
label define locccode 573 "Drywall installers", add;
label define locccode 575 "Electricians", add;
label define locccode 577 "Electrical power installers and repairers", add;
label define locccode 579 "Painters in construction and maintenance", add;
label define locccode 583 "Paperhangers", add;
label define locccode 584 "Plasterers", add;
label define locccode 585 "Plumbers, pipe fitters, & steamfitters", add;
label define locccode 588 "Concrete finishers and cement masons", add;
label define locccode 589 "Glaziers", add;
label define locccode 593 "Insulation workers", add;
label define locccode 594 "Paving/surfacing/tamping eqpmnt opers", add;
label define locccode 595 "Roofers", add;
label define locccode 596 "Sheet metal duct installers", add;
label define locccode 597 "Structural metal workers", add;
label define locccode 598 "Drillers of earth", add;
label define locccode 599 "Construction trades, n.e.c.", add;
label define locccode 614 "Drillers of oil wells", add;
label define locccode 615 "Explosives workers", add;
label define locccode 616 "Miners", add;
label define locccode 617 "Other mining jobs", add;
/*     label define locccode 623 "Garage workers and gas station attendants", add;*/
label define locccode 628 "Supervisors of production work", add;
label define locccode 634 "Tool and die makers and die setters", add;
label define locccode 637 "Machinists", add;
label define locccode 643 "Boilermakers", add;
label define locccode 644 "Precision grinders and filers", add;
label define locccode 645 "Patternmakers and model makers", add;  /* and sometimes lay-out workers */
label define locccode 646 "Lay-out workers", add;
label define locccode 649 "Engravers", add;
label define locccode 653 "Tinsmiths/coppersmiths and sheet metal workers", add;
label define locccode 657 "Cabinet makers and bench carpenters", add;
label define locccode 658 "Furniture and wood finishers", add;
label define locccode 659 "Other precision wood workers", add;
label define locccode 666 "Dressmakers/seamstresses", add;
label define locccode 667 "Tailors", add;
label define locccode 668 "Upholsterers", add;
label define locccode 669 "Shoe repairers", add;
label define locccode 674 "Other precision apparel and fabric workers", add;
label define locccode 675 "Hand molders and shapers except jewelers", add;
label define locccode 677 "Optical goods workers", add;
label define locccode 678 "Dental laboratory technicians", add;
label define locccode 679 "Bookbinders", add;
/*     label define locccode 683 "Electrical and electronic equipment assemblers", add; */
label define locccode 684 "Other precision and craft workers", add;
label define locccode 686 "Butchers and meat cutters", add;
label define locccode 687 "Bakers", add;
label define locccode 688 "Batch food makers", add;
label define locccode 693 "Adjusters and calibrators", add;
label define locccode 694 "Water and sewage treatment plant operators", add;
label define locccode 695 "Power plant operators", add;
label define locccode 696 "Plant and system operators", add;  /* "Stationary engineers" */
label define locccode 699 "Other plant and system operators", add;
label define locccode 703 "Lathe/milling/turning machine operators", add;
label define locccode 706 "Punch and stamping press operators", add;
label define locccode 707 "Rollers and roll hands, metal", add;
label define locccode 708 "Drilling and boring machine operators", add;
label define locccode 709 "Grinding/abrading/buffing/polishing machine opers", add;
label define locccode 713 "Forge and hammer operators", add;
label define locccode 717 "Fabricating machine operators, n.e.c.", add;
label define locccode 719 "Molders and casting machine operators", add;
label define locccode 723 "Metal platers", add;
label define locccode 724 "Heath treating equipment operators", add;
label define locccode 726 "Wood lathe/routing/planing machine operators", add;
                          /* !@#$ probably should be combined with 703 because 726 is small */
label define locccode 727 "Sawyers and sawing machine operators", add;
label define locccode 728 "Wood shaping/joining machine operators", add;
label define locccode 729 "Nail/tacking machine operators (wood work)", add;
label define locccode 733 "Other woodworking machine operators", add;
label define locccode 734 "Printing machine operators, n.e.c.", add;
label define locccode 735 "Photoengravers and lithographers", add; /* and in 2000, Etchers and engravers */
label define locccode 736 "Typesetters and compositors", add;
label define locccode 738 "Winding/twisting textile machine operators", add;
label define locccode 739 "Textile operatives", add;
  /* Knitters, loopers, toppers, and taping, & weaving machine operators */
label define locccode 743 "Textile cutting machine operators", add;
label define locccode 744 "Textile sewing machine operators", add;
label define locccode 745 "Shoemaking machine operators", add;
label define locccode 747 "Pressing machine operators", add;  /* textiles and clothing */
label define locccode 748 "Laundry workers", add;
label define locccode 749 "Misc textile machine operators", add;
label define locccode 753 "Cementing and gluing machine operators", add;
label define locccode 754 "Packing and filling operators and wrappers", add;
label define locccode 755 "Extruding and forming machine operators", add;
label define locccode 756 "Mixing and blending machine operatives", add;
label define locccode 757 "Separating/filtering/clarifying machine opers", add;
label define locccode 759 "Painting machine operators", add;
label define locccode 763 "Roasting and baking machine operators, food", add;
    /* too few, generally */
label define locccode 764 "Washing/cleaning/pickling machine operators", add;
label define locccode 765 "Folding machine operators", add;  /* paper goods processing */
label define locccode 766 "Furnace/kiln/oven operators apart from food", add;
label define locccode 768 "Crushing and grinding machine operators", add;
label define locccode 769 "Slicing and cutting machine operators", add;
label define locccode 773 "Motion picture projectionists", add;
label define locccode 774 "Photographic process workers", add;
label define locccode 779 "Machine operators, n.e.c.", add;
label define locccode 783 "Welders and cutters", add;  /*  ["flame-cutters" pre-1982] */
label define locccode 784 "Solderers", add; /* [and "brazers", after 1983 */
label define locccode 785 "Assemblers", add;
label define locccode 789 "Hand painting, coating, & decorating jobs", add;
label define locccode 796 "Checkers, examiners, and inspectors, n.e.c.", add;
label define locccode 799 "Production testers/samplers exc agriculture", add;
   /* "Graders, and sorters" usually */
label define locccode 803 "Supervisors of motor vehicle operators", add;
label define locccode 804 "Truck drivers/tractor eqpt opers/delivery wkrs", add;
label define locccode 808 "Bus drivers", add;
label define locccode 809 "Taxi cab drivers and chauffeurs", add;
label define locccode 813 "Parking lot attendants", add;
label define locccode 823 "Railroad conductors and yardmasters", add;
label define locccode 824 "Locomotive operating occupations", add; /* engineers and firemen */
label define locccode 825 "Railroad brake, signal, and switch operators", add;
label define locccode 829 "Boat operators except fishing", add;
 /*Sailors, deck hands, ship captains, mates, engineers not on fishing boats*/
label define locccode 834 "Water transport infrastructure tenders", add;
label define locccode 844 "Operating engineers in construction", add;
label define locccode 848 "Crane, tower, derrick, hoist, winch operators", add;
label define locccode 853 "Excavating and loading machine operators", add;
label define locccode 859 "Misc material moving jobs", add;
label define locccode 865 "Helpers in construction", add;
label define locccode 866 "Helpers to surveyors", add;
label define locccode 869 "Construction laborers", add;
label define locccode 873 "MISTAKE", add;
label define locccode 874 "Production helpers", add;   /* misnumbered 873 in ver1 fixed 14 May 06 */
label define locccode 875 "Refuse and recyclable material collectors", add;
label define locccode 876 "Materials movers, stevedores/longshore workers", add;
label define locccode 877 "Stock handlers and baggers", add;
label define locccode 878 "Machine feeders and offbearers", add;
label define locccode 883 "Freight, stock, and materials handlers", add;
label define locccode 885 "Garage & service station related jobs", add;
label define locccode 887 "Vehicle washers and equipment cleaners", add;
label define locccode 888 "Packers and packagers, by hand", add;
label define locccode 889 "Laborers outside construction", add;
label define locccode 905 "Military", add;
label define locccode 991 "Unemployed", add;
label define locccode 999 "Job unknown or not otherwise classified", add;

capture label drop linds;
label define linds 0 "Other industries"
                  1 "Computing equipment (ind 01)"
                  2 "Electrical equipment / supplies"
                  3 "NEC electronic equipment / supplies"
                  4 "Office and accounting machines"
                            /* includes computers to 1971 */
                  5 "Radio, TV and comm equipment"
                  6 "Telephone, wire and radio"
                  7 "Telegraph and other"
                  8 "Scientific/control equipment"
                  9 "Engineering/architectural services"
                 10 "Electrical goods (ind 10)"
                 11 "Electric light/power (ind 11)"
                 12 "Professional equipmnt/supplies"
                 20 "Aircraft and parts (ind 20)"
                 21 "Cutlery, tools, hardware"
                 22 "Florists (ind 22)"
                 23 "Hospitals (ind 23)"
                 24 "Insurance (ind 24)"
                 25 "Legal services (ind 25)"
                 26 "Libraries (ind 26)"
                 27 "Newspaper publishing (ind 27)"
                 28 "Photography equipment/supplies"
                 29 "Trucking service (ind 29)"
                 51 "Automobile manufacture (ind 51)"
                 52 "Banking (ind 52)"
                 53 "Motor vehicle wholesale (ind 53)"
                 54 "Motor vehicle retail (ind 54)"
                 55 "Barber shop (ind 55)";

capture label drop lstate;
label define lstate 1 "MA, ME, NH, RI, VT"
                    2 "CT"
                    3 "NY"
                    4 "NJ"
                    5 "PA"
                    6 "OH"
                    7 "IN"
                    8 "IL"
                    9 "MI, WI"
                   10 "MN, IA, MO, ND SD NE, KS"
                   11 "VA, MD, DE"
                   12 "DC"
                   13 "NC, SC, GA"
                   14 "FL"
                   15 "KY, TN"
                   16 "AL, MS"
                   17 "AR, OK, LA"
                   18 "TX"
                   19 "CO, UT, MT, ID, WY, NV, NM"
                   20 "WA, OR, AK, HI"
                   21 "CA";

/* end of program */
