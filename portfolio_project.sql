SELECT *
FROM covid_data.covid_deaths
ALTER TABLE `covid_data`.`covid_deaths` 
CHANGE COLUMN `date` `fecha` TEXT NULL DEFAULT NULL ;



-- Select data that we are going to be using.

SELECT location, fecha, total_cases, new_cases, total_deaths, population
FROM covid_data.covid_deaths
ORDER BY 1,2

-- Looking at Total_cases vs Total_deaths
-- Shows likelyhood of dying if you contract COVID in your country 

SELECT location, fecha, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM covid_data.covid_deaths
WHERE location = 'Argentina'
ORDER BY 1,2

-- Change format in cell fecha to date.

alter table covid_data.covid_deaths
modify fecha date,


update covid_data.covid_deaths
set fecha = str_to_date(fecha, "%d/%m/%Y")

select NULLIF(continent,'') as EmptyStringNULL from covid_data.covid_deaths


UPDATE covid_data.covid_deaths 
SET continent = NULL 
WHERE continent = ''

-- Looking Total Cases vs Population
-- Shows what percentage of population got COVID.
SELECT location, fecha, total_cases, population, (total_cases/population)*100 AS cases_percentage
FROM covid_data.covid_deaths
WHERE location = 'BOLIVIA'
ORDER BY 1,2

-- Looking at Countries with highest Infection Rates compared to Population
SELECT location, population, MAX(total_cases) as Highest_infection_count, MAX((total_cases/population))*100 as Percent_Population_Infected
FROM covid_data.covid_deaths
-- WHERE location = 'BOLIVIA'
GROUP BY Location, population
ORDER BY Percent_Population_Infected desc

-- Showing continent with highest Death Count per Population
SELECT continent, MAX(cast(Total_deaths as unsigned)) as Total_death_count
FROM covid_data.covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY Total_death_count desc

-- Showing countries with highest Death Count per Population
SELECT location, MAX(cast(Total_deaths as unsigned)) as Total_death_count
FROM covid_data.covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_death_count desc


-- Showing dates with highest Death Count per Population
SELECT fecha, MAX(cast(Total_deaths as unsigned)) as Total_death_count
FROM covid_data.covid_deaths
WHERE continent IS NOT NULL
GROUP BY fecha
ORDER BY fecha desc


--




-- Global numbers

SELECT fecha, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
FROM covid_data.covid_deaths
WHERE continent IS NOT NULL
GROUP BY fecha
ORDER BY fecha asc

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths,SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
FROM covid_data.covid_deaths
WHERE continent IS NOT NULL
ORDER BY fecha asc

-- 

-- Looking at Total Population vs Total Vaccinations

SELECT dea.continent, dea.location, dea.fecha, dea.population, vac.people_vaccinated
FROM covid_data.covid_deaths dea
JOIN covid_data.covid_vaccinations vac
	On dea.location = vac.location
    and dea.fecha = vac.fecha
-- WHERE dea.location = 'Argentina'  
ORDER BY fecha asc

-- Vacunation percentage per date

SELECT dea.continent, dea.location, dea.fecha, dea.population, vac.new_vaccinations, vac.people_vaccinated,
(vac.people_vaccinated/population)*100 as vacunation_percentage
FROM covid_data.covid_deaths dea
JOIN covid_data.covid_vaccinations vac
	On dea.location = vac.location
    and dea.fecha = vac.fecha
WHERE dea.location = 'argentina'
ORDER BY dea.fecha asc


-- Looking at acumulated_vaccinations_per_date

SELECT dea.continent, dea.location, dea.fecha, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as unsigned)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.fecha) as acumulado_vacuna
FROM covid_data.covid_deaths dea
JOIN covid_data.covid_vaccinations vac
	On dea.location = vac.location
    and dea.fecha = vac.fecha
WHERE dea.continent = 'africa' and dea.location = 'Algeria'
ORDER BY dea.fecha asc
