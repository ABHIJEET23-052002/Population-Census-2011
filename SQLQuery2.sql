select * from Data1;
select * from Data2;

-- number of rows in our dataset

select count(*) from Data1;
select count(*) from Data2;

-- dataset for particular state;

select * from Data1 where State='Bihar' OR State='Jharkhand' ;

-- Know the total population of the india

select sum(Population) as population from Data2;

-- Know average percentage growth of india

select avg(growth)*100 as avg_growth from Data1;

-- Know average percentage growth of state

select state, avg(growth)*100 as avg_growth from Data1 group by state;

-- average sex ratio

select state, round(avg(Sex_Ratio),0) as avg_sex_ratio from Data1 group by state order by avg_sex_ratio desc; 

-- average literacy rate

select state, round(avg(Literacy),0) as avg_literacy from Data1 group by state having round(avg(Literacy),0) > 90 order by avg_literacy desc; 

-- top 3 states showing highest gowth ratio

select top 3 state, avg(growth)*100 as avg_growth from Data1 group by state order by avg_growth DESC ;

-- bottom 3 state in sex ratio

select top 3 state, round(avg(Sex_Ratio),0) as avg_sex_ratio from Data1 group by state order by avg_sex_ratio asc; 

-- top and bottom 3 state in literacy ratio

drop table if exists #topstates;
create table #topstates(
state nvarchar(255),
topstate float
)

insert into #topstates
select state, round(avg(Literacy),0) as avg_literacy_ratio from Data1 group by state order by avg_literacy_ratio desc;

select top 3* from #topstates order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates(
state nvarchar(255),
bottomstate float
)

insert into #bottomstates
select state, round(avg(Literacy),0) as avg_literacy_ratio from Data1 group by state order by avg_literacy_ratio desc;

select top 3* from #bottomstates order by #bottomstates.bottomstate asc;

--union operator

select * from (select top 3* from #topstates order by #topstates.topstate desc) a
union
select * from (select top 3* from #bottomstates order by #bottomstates.bottomstate asc) b;

--states staring with letter 

select distinct state from data1 where lower(state) like 'a%' or lower(state) like 'b%';

select distinct state from data1 where lower(state) like 'a%' or lower(state) like '%d';



