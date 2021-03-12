create table new_usbridges
select *
from usbridges2016
group by STATE_CODE_001, STRUCTURE_NUMBER_008;

alter table new_usbridges
add BRIDGE_ID int not null
primary key auto_increment first;

create table BRIDGE (
BRIDGE_ID int(8) not null,
STATE_CODE varchar(300) not null,
STRUCTURE_NUMBER varchar(300) not null,
YEAR_BUILT int,
YEAR_RECONSTRUCTED int,
SERVICE_TYPE text,
SERVICE_ON int,
SERVICE_UND int,
STRUCTURE_KIND int,
STRUCTURE_TYPE text,
NAVIGATION text,
CULVERT text,
primary key(BRIDGE_ID)
);

insert into BRIDGE(BRIDGE_ID, STATE_CODE, STRUCTURE_NUMBER, YEAR_BUILT, YEAR_RECONSTRUCTED, SERVICE_TYPE, SERVICE_ON, SERVICE_UND, STRUCTURE_KIND, STRUCTURE_TYPE, NAVIGATION, CULVERT) 
(select BRIDGE_ID, STATE_CODE_001, STRUCTURE_NUMBER_008, YEAR_BUILT_027, YEAR_RECONSTRUCTED_106, concat(SERVICE_ON_042A, SERVICE_UND_042B), SERVICE_ON_042A, SERVICE_UND_042B,STRUCTURE_KIND_043A,  STRUCTURE_TYPE_043B, NAVIGATION_038, CULVERT_COND_062 from new_usbridges);

create table LOCATION_DETAIL (
BRIDGE_ID int(8) not null,
HIGHWAY_DISTRICT text,
PLACE_CODE text,
COUNTY_CODE text,
LOCATION text,
LAT text,
LONGITUDE text,
primary key(BRIDGE_ID),
foreign key(BRIDGE_ID) references BRIDGE(BRIDGE_ID)
);

insert into LOCATION_DETAIL(BRIDGE_ID, HIGHWAY_DISTRICT, PLACE_CODE, COUNTY_CODE, LOCATION, LAT, LONGITUDE) 
(select BRIDGE_ID, HIGHWAY_DISTRICT_002, PLACE_CODE_004, COUNTY_CODE_003, LOCATION_009, LAT_016, LONG_017 from new_usbridges);

create table INSPECTIONS (
BRIDGE_ID int(8) not null,
DATE_OF_INSPECT int,
INSPECT_FREQ_MONTHS int,
CRITICAL_FEA_INSPECT varchar(300),
primary key(BRIDGE_ID),
foreign key(CRITICAL_FEA_INSPECT) references FEATURE_INSPECTION(CRITICAL_FEA_INSPECT)
);

insert into INSPECTIONS(BRIDGE_ID, DATE_OF_INSPECT, INSPECT_FREQ_MONTHS, CRITICAL_FEA_INSPECT) 
(select BRIDGE_ID, DATE_OF_INSPECT_090, INSPECT_FREQ_MONTHS_091, concat(FRACTURE_092A, UNDWATER_LOOK_SEE_092B, SPEC_INSPECT_092C) from new_usbridges);

create table FEATURE_INSPECTION (
CRITICAL_FEA_INSPECT varchar(300) not null,
FRACTURE text,
UNDWATER_LOOK_SEE text,
SPEC_INSPECT text,
primary key(CRITICAL_FEA_INSPECT)
);

insert into FEATURE_INSPECTION(CRITICAL_FEA_INSPECT, FRACTURE, UNDWATER_LOOK_SEE, SPEC_INSPECT) 
(select distinct concat(FRACTURE_092A, UNDWATER_LOOK_SEE_092B, SPEC_INSPECT_092C), FRACTURE_092A, UNDWATER_LOOK_SEE_092B, SPEC_INSPECT_092C from new_usbridges);

create table APPRAISAL (
BRIDGE_ID int(8) not null,
STRUCTURAL_EVAL int,
UNDCLRENCE_EVAL text,
APPR_ROAD_EVAL int,
TRAFFIC_SAFETY varchar(300),
SCOUR_CRITICAL text,
OPR_RATING varchar(300),
INV_RATING varchar(300),
primary key(BRIDGE_ID),
foreign key(BRIDGE_ID) references BRIDGE(BRIDGE_ID),
foreign key(TRAFFIC_SAFETY) references SAFETY(TRAFFIC_SAFETY),
foreign key(OPR_RATING) references OPERATING(OPR_RATING),
foreign key(INV_RATING) references INVENTORY(INV_RATING)
);

insert into APPRAISAL(BRIDGE_ID, STRUCTURAL_EVAL, UNDCLRENCE_EVAL, APPR_ROAD_EVAL, TRAFFIC_SAFETY, SCOUR_CRITICAL, OPR_RATING, INV_RATING) 
(select BRIDGE_ID, STRUCTURAL_EVAL_067, UNDCLRENCE_EVAL_069, APPR_ROAD_EVAL_072, concat(RAILINGS_036A, TRANSITIONS_036B, APPR_RAIL_036C, APPR_RAIL_END_036D), SCOUR_CRITICAL_113, concat(OPR_RATING_METH_063, OPERATING_RATING_064), concat(INV_RATING_METH_065, INVENTORY_RATING_066) from new_usbridges);

create table OPERATING (
OPR_RATING varchar(300) not null,
OPR_RATING_METH int,
OPERATING_RATING double,
primary key(OPR_RATING)
);

insert into OPERATING(OPR_RATING, OPR_RATING_METH, OPERATING_RATING) 
(select distinct concat(OPR_RATING_METH_063, OPERATING_RATING_064), OPR_RATING_METH_063, OPERATING_RATING_064 from new_usbridges);

create table INVENTORY (
INV_RATING varchar(300) not null,
INV_RATING_METH int,
INVENTORY_RATING double,
primary key(INV_RATING)
);

insert into INVENTORY(INV_RATING, INV_RATING_METH, INVENTORY_RATING) 
(select distinct concat(INV_RATING_METH_065, INVENTORY_RATING_066), INV_RATING_METH_065, INVENTORY_RATING_066 from new_usbridges);

create table SAFETY (
TRAFFIC_SAFETY varchar(300) not null,
RAILINGS text,
TRANSITIONS text,
APPR_RAIL text,
APPR_RAIL_END text,
primary key(TRAFFIC_SAFETY)
);

insert into SAFETY(TRAFFIC_SAFETY, RAILINGS, TRANSITIONS, APPR_RAIL, APPR_RAIL_END) 
(select distinct concat(RAILINGS_036A, TRANSITIONS_036B, APPR_RAIL_036C, APPR_RAIL_END_036D), RAILINGS_036A, TRANSITIONS_036B, APPR_RAIL_036C, APPR_RAIL_END_036D from new_usbridges);

create table QUANTITIVE_DATA (
BRIDGE_ID int(8) not null,
DETOUR_KILOS int,
MAX_SPAN_LEN_MT double,
STRUCTURE_LEN_MT double,
CURB_SIDEWALK varchar(300),
ROADWAY_WIETH_MT double,
DECK_WIDTH_MT double,
APPR_WIDTH_MT double,
MEDIAN_CODE double,
DEGREES_SKEW int,
STRUCTURE_FLARED int,
MIN_VERT_CLR double,
HORR_CLR_MT double,
APPR_SPANS int,
VERT_CLR_OVER_MT double,
MIN_VERT_UNDERCLEAR varchar(300),
MIN_LAT_UNDERCLEAR varchar(300),
LEFT_LAT_UND_MT int,
primary key(BRIDGE_ID),
foreign key(BRIDGE_ID) references BRIDGE(BRIDGE_ID),
#foreign key(CURB_SIDEWALK) references SIDEWALK(CURB_SIDEWALK),
foreign key(MIN_VERT_UNDERCLEAR) references MIN_VERT(MIN_VERT_UNDERCLEAR),
foreign key(MIN_LAT_UNDERCLEAR) references MIN_LAT(MIN_LAT_UNDERCLEAR)
);

insert into QUANTITIVE_DATA
(BRIDGE_ID, DETOUR_KILOS, MAX_SPAN_LEN_MT, STRUCTURE_LEN_MT, 
CURB_SIDEWALK, ROADWAY_WIETH_MT, DECK_WIDTH_MT, APPR_WIDTH_MT, 
MEDIAN_CODE, DEGREES_SKEW, STRUCTURE_FLARED, MIN_VERT_CLR,
HORR_CLR_MT, APPR_SPANS, VERT_CLR_OVER_MT, MIN_VERT_UNDERCLEAR,
MIN_LAT_UNDERCLEAR, LEFT_LAT_UND_MT) 
(select BRIDGE_ID, DETOUR_KILOS_019, MAX_SPAN_LEN_MT_048,
STRUCTURE_LEN_MT_049, concat(LEFT_CURB_MT_050A, RIGHT_CURB_MT_050B),
ROADWAY_WIDTH_MT_051, DECK_WIDTH_MT_052, APPR_WIDTH_MT_032, MEDIAN_CODE_033,
DEGREES_SKEW_034, STRUCTURE_FLARED_035, MIN_VERT_CLR_010, HORR_CLR_MT_047,
APPR_SPANS_046, VERT_CLR_OVER_MT_053, concat(VERT_CLR_UND_REF_054A, VERT_CLR_UND_054B),
concat(LAT_UND_REF_055A, LAT_UND_MT_055B), LEFT_LAT_UND_MT_056
from new_usbridges);

create table SIDEWALK (
LEFT_CURB_MT double,
RIGHT_CURB_MT double
);

insert into SIDEWALK(LEFT_CURB_MT, RIGHT_CURB_MT) 
(select distinct LEFT_CURB_MT_050A, RIGHT_CURB_MT_050B from new_usbridges);

alter table SIDEWALK
add CURB_SIDEWALK int not null
primary key auto_increment first;

create table MIN_VERT (
MIN_VERT_UNDERCLEAR varchar(300) not null,
VERT_CLR_UND_REF text,
VERT_CLR_UND text,
primary key(MIN_VERT_UNDERCLEAR)
);

insert into MIN_VERT(MIN_VERT_UNDERCLEAR, VERT_CLR_UND_REF, VERT_CLR_UND) 
(select distinct concat(VERT_CLR_UND_REF_054A, VERT_CLR_UND_054B), VERT_CLR_UND_REF_054A, VERT_CLR_UND_054B from new_usbridges);

create table MIN_LAT (
MIN_LAT_UNDERCLEAR varchar(300) not null,
LAT_UND_REF text,
LAT_UND_MT text,
primary key(MIN_LAT_UNDERCLEAR)
);

insert into MIN_LAT(MIN_LAT_UNDERCLEAR, LAT_UND_REF, LAT_UND_MT) 
(select distinct concat(LAT_UND_REF_055A, LAT_UND_MT_055B), LAT_UND_REF_055A, LAT_UND_MT_055B from new_usbridges);

create table OTHER_QUALITATIVE (
BRIDGE_ID int(8) not null,
MAIN_UNIT_SPANS int,
APPR_SPANS int,
PROTECTIVE_SYSTEM varchar(300),
OPEN_CLOSED_POSTED text,
primary key(BRIDGE_ID),
foreign key(BRIDGE_ID) references BRIDGE(BRIDGE_ID),
foreign key(PROTECTIVE_SYSTEM) references SYSTEM_FOR_PROTECTION(PROTECTIVE_SYSTEM)
);

insert into OTHER_QUALITATIVE(BRIDGE_ID, MAIN_UNIT_SPANS, APPR_SPANS, PROTECTIVE_SYSTEM, OPEN_CLOSED_POSTED) 
(select BRIDGE_ID, MAIN_UNIT_SPANS_045, APPR_SPANS_046, concat(SURFACE_TYPE_108A, MEMBRANE_TYPE_108B, DECK_PROTECTION_108C), OPEN_CLOSED_POSTED_041 from new_usbridges);

create table SYSTEM_FOR_PROTECTION (
PROTECTIVE_SYSTEM varchar(300) not null,
SURFACE_TYPE text,
MEMBRANE_TYPE text,
DECK_PROTECTION text,
primary key(PROTECTIVE_SYSTEM)
);

insert into SYSTEM_FOR_PROTECTION(PROTECTIVE_SYSTEM, SURFACE_TYPE, MEMBRANE_TYPE, DECK_PROTECTION) 
(select distinct concat(SURFACE_TYPE_108A, MEMBRANE_TYPE_108B, DECK_PROTECTION_108C), SURFACE_TYPE_108A, MEMBRANE_TYPE_108B, DECK_PROTECTION_108C from new_usbridges);

create table IMPROVEMENT (
BRIDGE_ID int(8) not null,
TYPE_OF_WORK varchar(300),
IMP_LEN_MT text,
BRIDGE_IMP_COST text,
ROADWAY_IMP_COST text,
TOTAL_IMP_COST text,
YEAR_OF_IMP text,
FUTURE_ADT int,
YEAR_OF_FUTURE_ADT text,
primary key(BRIDGE_ID),
foreign key(BRIDGE_ID) references BRIDGE(BRIDGE_ID),
foreign key(TYPE_OF_WORK) references IMPROVEMENT_WORK(TYPE_OF_WORK)
);

insert into IMPROVEMENT(BRIDGE_ID, TYPE_OF_WORK, IMP_LEN_MT, 
BRIDGE_IMP_COST, ROADWAY_IMP_COST, TOTAL_IMP_COST, YEAR_OF_IMP, 
FUTURE_ADT, YEAR_OF_FUTURE_ADT) 
(select BRIDGE_ID, concat(WORK_PROPOSED_075A, WORK_DONE_BY_075B), 
IMP_LEN_MT_076, BRIDGE_IMP_COST_094, ROADWAY_IMP_COST_095, TOTAL_IMP_COST_096,
YEAR_OF_IMP_097, FUTURE_ADT_114, YEAR_OF_FUTURE_ADT_115 from new_usbridges);

create table IMPROVEMENT_WORK (
TYPE_OF_WORK varchar(300) not null,
WORK_PROPOSED text,
WORK_DONE_BY text,
primary key(TYPE_OF_WORK)
);

insert into IMPROVEMENT_WORK (TYPE_OF_WORK, WORK_PROPOSED, WORK_DONE_BY) 
(select distinct concat(WORK_PROPOSED_075A, WORK_DONE_BY_075B), WORK_PROPOSED_075A, WORK_DONE_BY_075B from new_usbridges);

create table NAVIGATION_DATA (
BRIDGE_ID int(8) not null,
NAV_VERT_CLR_MT double,
NAV_HORR_CLR_MT double,
PIER_PROTECTION text,
MIN_NAV_CLR_MT text,
primary key(BRIDGE_ID)
);

insert into NAVIGATION_DATA(BRIDGE_ID, NAV_VERT_CLR_MT, NAV_HORR_CLR_MT, PIER_PROTECTION, MIN_NAV_CLR_MT) 
(select BRIDGE_ID, NAV_VERT_CLR_MT_039, NAV_HORR_CLR_MT_040, PIER_PROTECTION_111, MIN_NAV_CLR_MT_116 from new_usbridges);

create table NONCULVERT_DATA (
BRIDGE_ID int(8) not null,
DECK_COND text,
SUPERSTRUCTURE_COND text,
SUBSTRUCTURE_COND text,
primary key(BRIDGE_ID)
);

insert into NONCULVERT_DATA(BRIDGE_ID, DECK_COND, SUPERSTRUCTURE_COND, SUBSTRUCTURE_COND) 
(select BRIDGE_ID, DECK_COND_058, SUPERSTRUCTURE_COND_059, SUBSTRUCTURE_COND_060 from new_usbridges);

create table STATE (
STATE_CODE varchar(300) not null,
STATE_NAME text,
POPULATION double,
AREA double,
ABBREVIATION text,
primary key(STATE_CODE)
);

-- question 1
select * from (select STATE_CODE, YEAR_BUILT, count(*) as cnt
			   from BRIDGE
               where YEAR_BUILT != 0
			   group by STATE_CODE, YEAR_BUILT) as a,
(select STATE_CODE, max(cnt) as max_count 
 from (select STATE_CODE, YEAR_BUILT, count(*) as cnt
       from BRIDGE
       where YEAR_BUILT != 0
	   group by STATE_CODE, YEAR_BUILT) as c
 group by STATE_CODE) as b
where a.STATE_CODE=b.STATE_CODE and a.cnt=b.max_count;

-- question 2
delete from IMPROVEMENT where TOTAL_IMP_COST='';

select type_class, avg(TOTAL_IMP_COST) average
from
(
    select case when STRUCTURE_TYPE = '01' then 'concrete'
                when STRUCTURE_TYPE = '02' then 'concrete continuous'
                when STRUCTURE_TYPE = '03' then 'steel'
                when STRUCTURE_TYPE = '04' then 'steel continuous'
                when STRUCTURE_TYPE = '05' then 'Prestressed concrete'
                when STRUCTURE_TYPE = '06' then 'Prestressed concrete continuous'
                when STRUCTURE_TYPE = '07' then 'Wood or Timber'
				when STRUCTURE_TYPE = '08' then 'Masonry'
				when STRUCTURE_TYPE = '09' then 'Aluminum, Wrought Iron, or Cast Iron'
                else 'Others'
           end as type_class, 
           TOTAL_IMP_COST
    from (select STRUCTURE_TYPE, TOTAL_IMP_COST
		  from (BRIDGE as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by type_class;

delete from NONCULVERT_DATA where DECK_COND='N';

select deck_condition, avg(TOTAL_IMP_COST) average
from
(
    select case when DECK_COND = '1' then 'IMMINENT FAILURE'
                when DECK_COND = '2' then 'CRITICAL'
                when DECK_COND = '3' then 'SERIOUS'
                when DECK_COND = '4' then 'POOR'
                when DECK_COND = '5' then 'FAIR'
                when DECK_COND = '6' then 'SATISFACTORY'
                when DECK_COND = '7' then 'GOOD'
				when DECK_COND = '8' then 'VERY GOOD'
				when DECK_COND = '9' then 'EXCELLENT'
                when DECK_COND = '0' then 'FAILED'
           end as deck_condition, 
           TOTAL_IMP_COST
    from (select DECK_COND, TOTAL_IMP_COST
		  from (NONCULVERT_DATA as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by deck_condition;

delete from NONCULVERT_DATA where SUPERSTRUCTURE_COND='N';

select superstructure_condition, avg(TOTAL_IMP_COST) average
from
(
    select case when SUPERSTRUCTURE_COND = '1' then 'IMMINENT FAILURE'
                when SUPERSTRUCTURE_COND = '2' then 'CRITICAL'
                when SUPERSTRUCTURE_COND = '3' then 'SERIOUS'
                when SUPERSTRUCTURE_COND = '4' then 'POOR'
                when SUPERSTRUCTURE_COND = '5' then 'FAIR'
                when SUPERSTRUCTURE_COND = '6' then 'SATISFACTORY'
                when SUPERSTRUCTURE_COND = '7' then 'GOOD'
				when SUPERSTRUCTURE_COND = '8' then 'VERY GOOD'
				when SUPERSTRUCTURE_COND = '9' then 'EXCELLENT'
                when SUPERSTRUCTURE_COND = '0' then 'FAILED'
           end as superstructure_condition, 
           TOTAL_IMP_COST
    from (select SUPERSTRUCTURE_COND, TOTAL_IMP_COST
		  from (NONCULVERT_DATA as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by superstructure_condition;

delete from NONCULVERT_DATA where SUBSTRUCTURE_COND='N';

select substructure_condition, avg(TOTAL_IMP_COST) average
from
(
    select case when SUBSTRUCTURE_COND = '1' then 'IMMINENT FAILURE'
                when SUBSTRUCTURE_COND = '2' then 'CRITICAL'
                when SUBSTRUCTURE_COND = '3' then 'SERIOUS'
                when SUBSTRUCTURE_COND = '4' then 'POOR'
                when SUBSTRUCTURE_COND = '5' then 'FAIR'
                when SUBSTRUCTURE_COND = '6' then 'SATISFACTORY'
                when SUBSTRUCTURE_COND = '7' then 'GOOD'
				when SUBSTRUCTURE_COND = '8' then 'VERY GOOD'
				when SUBSTRUCTURE_COND = '9' then 'EXCELLENT'
                when SUBSTRUCTURE_COND = '0' then 'FAILED'
           end as substructure_condition, 
           TOTAL_IMP_COST
    from (select SUBSTRUCTURE_COND, TOTAL_IMP_COST
		  from (NONCULVERT_DATA as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by substructure_condition;

select length_range, avg(TOTAL_IMP_COST) average
from
(
    select case when STRUCTURE_LEN_MT <= 10.0 then '-10'
				when STRUCTURE_LEN_MT <= 100.0 and STRUCTURE_LEN_MT > 10.0 then '10-100'
                when STRUCTURE_LEN_MT <= 200.0 and STRUCTURE_LEN_MT > 100.0 then '100-200'
                when STRUCTURE_LEN_MT <= 500.0 and STRUCTURE_LEN_MT > 200.0 then '200-500'
                when STRUCTURE_LEN_MT <= 800.0 and STRUCTURE_LEN_MT > 500.0 then '500-800'
                when STRUCTURE_LEN_MT <= 1000.0 and STRUCTURE_LEN_MT > 800.0 then '800-1000'
				when STRUCTURE_LEN_MT <= 2000.0 and STRUCTURE_LEN_MT > 1000.0 then '1000-2000'
                when STRUCTURE_LEN_MT <= 2000.0 and STRUCTURE_LEN_MT > 1000.0 then '1000-2000'
                when STRUCTURE_LEN_MT <= 3000.0 and STRUCTURE_LEN_MT > 2000.0 then '2000-3000'
                when STRUCTURE_LEN_MT <= 4000.0 and STRUCTURE_LEN_MT > 3000.0 then '3000-4000'
                when STRUCTURE_LEN_MT <= 5000.0 and STRUCTURE_LEN_MT > 4000.0 then '4000-5000'
                when STRUCTURE_LEN_MT <= 6000.0 and STRUCTURE_LEN_MT > 5000.0 then '5000-6000'
                when STRUCTURE_LEN_MT <= 7000.0 and STRUCTURE_LEN_MT > 6000.0 then '6000-7000'
                when STRUCTURE_LEN_MT <= 8000.0 and STRUCTURE_LEN_MT > 7000.0 then '7000-8000'
                when STRUCTURE_LEN_MT <= 9000.0 and STRUCTURE_LEN_MT > 8000.0 then '8000-9000'
                when STRUCTURE_LEN_MT <= 10000.0 and STRUCTURE_LEN_MT > 9000.0 then '7000-8000'
                else '+10000'
           end as length_range, 
           TOTAL_IMP_COST
    from (select STRUCTURE_LEN_MT, TOTAL_IMP_COST
		  from (QUANTITIVE_DATA as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by length_range
order by length_range;

select if_watery, avg(TOTAL_IMP_COST) average
from
(
    select case when NAVIGATION = 'N' then 'No water'
                else 'Watery'
           end as if_watery, 
           TOTAL_IMP_COST
    from (select NAVIGATION, TOTAL_IMP_COST
		  from (BRIDGE as t1), (IMPROVEMENT as t2)
          where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != '') as a
) dt
group by if_watery;

select STATE_CODE, avg(TOTAL_IMP_COST) average
from (BRIDGE as t1), (IMPROVEMENT as t2)
where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != ''
group by STATE_CODE;

select SERVICE_ON, avg(TOTAL_IMP_COST) average
from (BRIDGE as t1), (IMPROVEMENT as t2)
where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != ''
group by SERVICE_ON
order by SERVICE_ON;

select SERVICE_UND, avg(TOTAL_IMP_COST) average
from (BRIDGE as t1), (IMPROVEMENT as t2)
where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != ''
group by SERVICE_UND
order by SERVICE_UND;

select SERVICE_TYPE, avg(TOTAL_IMP_COST) average
from (BRIDGE as t1), (IMPROVEMENT as t2)
where t1.BRIDGE_ID=t2.BRIDGE_ID and TOTAL_IMP_COST != ''
group by SERVICE_TYPE
order by SERVICE_TYPE;

-- question 3
select * from (select YEAR_BUILT, STRUCTURE_TYPE, count(*) as cnt
			   from BRIDGE
			   group by YEAR_BUILT, STRUCTURE_TYPE) as a,
(select YEAR_BUILT, max(cnt) as max_count 
 from (select YEAR_BUILT, STRUCTURE_TYPE, count(*) as cnt
       from BRIDGE
	   group by YEAR_BUILT, STRUCTURE_TYPE) as c
 group by YEAR_BUILT) as b
where a.YEAR_BUILT=b.YEAR_BUILT and a.cnt=b.max_count
order by a.YEAR_BUILT;

select * from (select YEAR_BUILT, STRUCTURE_KIND, count(*) as cnt
			   from BRIDGE
			   group by YEAR_BUILT, STRUCTURE_KIND) as a,
(select YEAR_BUILT, max(cnt) as max_count 
 from (select YEAR_BUILT, STRUCTURE_KIND, count(*) as cnt
       from BRIDGE
	   group by YEAR_BUILT, STRUCTURE_KIND) as c
 group by YEAR_BUILT) as b
where a.YEAR_BUILT=b.YEAR_BUILT and a.cnt=b.max_count
order by a.YEAR_BUILT;

select * from (select YEAR_BUILT, BRIDGE.STATE_CODE, ABBREVIATION, count(*) as cnt
			   from BRIDGE, STATE
               where BRIDGE.STATE_CODE = STATE.STATE_CODE and YEAR_BUILT != 0
			   group by YEAR_BUILT, BRIDGE.STATE_CODE) as a,
(select YEAR_BUILT, max(cnt) as max_count 
 from (select YEAR_BUILT, STATE_CODE, count(*) as cnt
       from BRIDGE
       where YEAR_BUILT != 0
	   group by YEAR_BUILT, STATE_CODE) as c
 group by YEAR_BUILT) as b
where a.YEAR_BUILT=b.YEAR_BUILT and a.cnt=b.max_count
order by a.YEAR_BUILT;

select YEAR_BUILT, count(*) as cnt
from BRIDGE
group by YEAR_BUILT
order by YEAR_BUILT;

select * from (select YEAR_BUILT, SERVICE_ON, count(*) as cnt
			   from BRIDGE
               where YEAR_BUILT != 0
			   group by YEAR_BUILT, SERVICE_ON) as a,
(select YEAR_BUILT, max(cnt) as max_count 
 from (select YEAR_BUILT, SERVICE_ON, count(*) as cnt
       from BRIDGE
       where YEAR_BUILT != 0
	   group by YEAR_BUILT, SERVICE_ON) as c
 group by YEAR_BUILT) as b
where a.YEAR_BUILT=b.YEAR_BUILT and a.cnt=b.max_count
order by a.YEAR_BUILT;

select * from (select YEAR_BUILT, SERVICE_UND, count(*) as cnt
			   from BRIDGE
               where YEAR_BUILT != 0
			   group by YEAR_BUILT, SERVICE_UND) as a,
(select YEAR_BUILT, max(cnt) as max_count 
 from (select YEAR_BUILT, SERVICE_UND, count(*) as cnt
       from BRIDGE
       where YEAR_BUILT != 0
	   group by YEAR_BUILT, SERVICE_UND) as c
 group by YEAR_BUILT) as b
where a.YEAR_BUILT=b.YEAR_BUILT and a.cnt=b.max_count
order by a.YEAR_BUILT;

select STATE_CODE, STRUCTURE_TYPE, count(*) as cnt
from BRIDGE
group by STATE_CODE, STRUCTURE_TYPE
order by STATE_CODE, STRUCTURE_TYPE;

select STRUCTURE_TYPE, count(*)
from BRIDGE
where STRUCTURE_TYPE != ''
group by STRUCTURE_TYPE
order by STRUCTURE_TYPE;