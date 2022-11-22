select * from coviddeaths;

select * from covidvaccinations
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population 
from coviddeaths
order by 1,2;

-- looking at total cases vs total deaths
-- shows likelihood of dying
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathPercent
from coviddeaths
order by 1,2;

-- looking at total vases vs population
-- shows what percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as PopulationPercent
from coviddeaths
order by 1,2;

-- now we'll find countries with highest infection rate compared to population
select location,  population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectedPopulationPercentage
from coviddeaths
Group by location , population
order by  InfectedPopulationPercentage desc;

-- finding countries with highest death count per population
select location, max(total_deaths) as TotalDeathCount
from coviddeaths
where location is not null
Group by location
order by TotalDeathCount desc;

-- finding continent with highest death count per population
select continent, max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
Group by continent
order by TotalDeathCount desc; 

-- global numbers
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_PCT
FROM CovidDeaths;

-- Global Numbers by Date
SELECT date,SUM(new_cases) as total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_PCT
FROM CovidDeaths
GROUP BY date
ORDER BY death_PCT desc;

-- COVID VACCINATION

SELECT * FROM covidvaccinations;

-- joining both the tables
SELECT * 
FROM CovidDeaths death
JOIN covidvaccinations vacination
ON death.date = vacination.date and death.location = vacination.location;

-- looking at total population vs vaccination
SELECT death.continent, death.location, death.date, death.population, death.new_vaccinations
FROM CovidDeaths as death
JOIN covidvaccinations vacination
ON death.date = vacination.date 
and death.location = vacination.location;

-- using partition
SELECT death.continent, death.location, death.date, death.population, death.new_vaccinations,
SUM(death.new_vaccinations) 
OVER (PARTITION BY death.location ORDER BY death.location, death.date) AS rolling_people_vac
FROM CovidDeaths as death
JOIN covidvaccinations vacination
ON death.date = vacination.date 
and death.location = vacination.location;
 

-- 2nd TEMP TABLE

-- DROP TABLE IF exists #Percent_pop_vac
-- CREATE TABLE #Percent_pop_vac (
-- continent CHAR(255),
-- location VARCHAR(225),
-- date DATE,
-- population INT,
-- new_vaccinations INT,
-- rolling_people_vac INT
-- )
-- INSERT INTO #Percent_pop_vac
-- SELECT dea.continent, dea.location, dea.date, dea.population,new_vaccinations, vac.new_vaccinations,
-- SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vac,
-- FROM CovidDeaths as dea
-- JOIN covidvaccinations vac
-- ON dea.date = vac.date and dea.location = vac.location
-- SELECT *, (rolling_people_vac/population)*100
-- FROM #Percent_pop_vac


-- creating views 
CREATE VIEW pct_pop AS 
SELECT location,MAX(total_deaths) AS Highest_death_infection, (MAX(total_deaths/population))*100 AS pct_death_rate,
MAX(total_cases) AS Highest_infection_rate, (MAX(total_cases/population))*100 AS pct_inf_rate
FROM CovidDeaths
GROUP BY location,population
ORDER BY pct_death_rate DESC ,pct_inf_rate DESC;

-- to see the view created
SELECT * FROM pct_pop;