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

-- join both the tables

select a.district, a.state, a.sex_ratio, b.population from data1 a inner join data2 b on a.district=b.district;

-- males and females

select d.state, sum(d.male) total_male, sum(d.female) total_female from
(select c.district, c.state, round(c.population/(1+c.sex_ratio),0) male, round((c.population*c.sex_ratio)/(1+c.sex_ratio),0) female from
(select a.district, a.state, a.sex_ratio/1000 sex_ratio, b.population from data1 a inner join data2 b on a.district=b.district) c) d group by state;

-- total literacy rate

select d.state, sum(d.literate_people) total_male, sum(d.illiterate_people) total_female from
(select c.district, c.state, round((literacy_ratio*population),0) literate_people, round(Population-(literacy_ratio*population),0) illiterate_people from
(select a.district, a.state, a.literacy/100 literacy_ratio, b.population from data1 a inner join data2 b on a.district=b.district) c) d group by state;

--population in previous year 

select sum(e.previous_population) total_male, sum(e.current_population) total_female from
(select d.state, sum(d.previous_population) previous_population, sum(d.current_population) current_population from
(select c.district, c.state, round((c.population/(1+c.growth)),0) previous_population, c.Population current_population from
(select a.district, a.state, a.growth growth, b.population from data1 a inner join data2 b on a.district=b.district) c)d  group by state) e;

-- Population vs Area

select (g.total_area/g.previous_population)  as previous_census_population_vs_area, (g.total_area/g.current_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from(
select '1' as keyy, n.* from( 
select sum(m.previous_population) previous_population, sum(m.current_population) current_population from
(select e.state, sum(e.previous_population) previous_population, sum(e.current_population) current_population from
(select d.district, d.state, round((d.population/(1+d.growth)),0) previous_population, d.Population current_population from
(select a.district, a.state, a.growth growth, b.population from data1 a inner join data2 b on a.district=b.district) d) e 
group by e.state)m)n) q inner join(

select '1' as keyy, z.* from( 
select sum(area_km2) total_area from Data2) z) r on q.keyy=r.keyy) g;


--window

output top 3 district from each state with highest literacy rate

select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from data1) a

where a.rnk in (1,2,3) order by state
