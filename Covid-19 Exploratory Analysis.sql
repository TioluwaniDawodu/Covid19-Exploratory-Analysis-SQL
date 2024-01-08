show databases;
use portfolio;
show tables;
select * from coviddeaths
where continent != '';
select * from covidvaccination;

#Exploratory Analyis using canada as a case study
select location,date,total_cases,new_cases,total_deaths
from coviddeaths
where location = 'Canada'
order by total_cases asc;
-- first case was on the 26th of january 2020
-- Canada recored it most cases on the 2nd of april 2021 which was 998,208
-- Canada recorded its most deaths on the 22nd of october 2020 which was 9,977


#looking at total cases vs total deaths
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where location = 'Canada'
order by DeathPercentage asc;
-- shows likelihood of dying if gotten covid
-- lowest percentage was 26th of january 2020 to 8th of march 2020. 0 deaths recorded
-- All time high on the 28th of may 2020 which was 8.58%

#total cases vs population
select location,date,Population,total_cases,(total_cases/Population)*100 as PercentPopulationInfected
from coviddeaths
where location = 'Canada';
-- Shows what percentage of population got covid

#looking at the country with highest infection rate compared to population
select location,Population,max(total_cases) as HighestInfectionCount,max((total_cases/Population))*100 as PercentPopulationInfected
from coviddeaths
where continent != ''
group by location,Population
order by PercentPopulationInfected desc;
-- Andorra has the highest infection count compared to population
-- USA among top 10

#looking at the countries with the highest death count per population
select location,max(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent != ''
group by location
order by TotalDeathCount desc;
-- United states has the highest death count

#let us break things down by continent
select continent,max(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent != ''
group by continent
order by TotalDeathCount desc;

#showing continents with the highesr death counts
select continent,max(cast(total_deaths as unsigned)) as TotalDeathCount
from coviddeaths
where continent != ''
group by continent
order by TotalDeathCount desc;

#Global Numbers
select date,sum(new_cases) as total_cases,sum(cast(new_deaths as unsigned)) as total_deaths,sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent != ''
group by date
order by DeathPercentage asc;


#looking at total population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from coviddeaths as dea
inner join covidvaccination as vac
where dea.location = vac.location
and dea.date = vac.date
and dea.continent != ''
and dea.location = 'Canada';
-- Canada Started vaccinations on the 15th of December 2020 which was quite early due to waiting of the vaccine.

#Let us get the cummulative total 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as unsigned)) 
over(partition by dea.location order by dea.location,dea.date)as cummulativePeopleVaccinated
from coviddeaths as dea
inner join covidvaccination as vac
where dea.location = vac.location
and dea.date = vac.date
and dea.continent != ''
and dea.location = 'Canada';


#let us use CTE to get the percentage cummulative so we know the total percentage of people vaccinated in canada
with popvsvac (continent,location,date,population,new_vaccinations,cummulativePeopleVaccinated) 
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as unsigned)) 
over(partition by dea.location order by dea.location,dea.date)as cummulativePeopleVaccinated
from coviddeaths as dea
inner join covidvaccination as vac
where dea.location = vac.location
and dea.date = vac.date
and dea.continent != ''
and dea.location = 'Canada'
)
select *,(cummulativePeopleVaccinated/population)*100 from popvsvac;
-- with this dataset, only 35.5% of canada's population has been vaccinated as at the 30th of april,2021



