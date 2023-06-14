-- DATA THAT WE ARE USING

SELECT*
FROM SQLPortfoglioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

-- SELECTING DATA THAT IM GONNA USE

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM SQLPortfoglioProject..CovidDeaths
order by 1,2

--TOTAL CASES VS TOTAL DEATHS

-- LOOKING DEATH PERCENTAGE
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM SQLPortfoglioProject..CovidDeaths
order by 1,2

-- DEATH PERCENTAGE IN 'ITALY'

SELECT Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM SQLPortfoglioProject..CovidDeaths
WHERE location = 'Italy' 
order by 1,2


-- TOTAL CASES VS POPOLATION
-- SHOWS PERCENTAGE OF POPOLATION THAT GOT COVID

SELECT Location, date,Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM SQLPortfoglioProject..CovidDeaths
WHERE location = 'Italy' 
order by 1,2


-- COUNTRIES THAT HIGHEST INFECTION RATE COMPARE TO POPOLATION
SELECT Location,Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentPopulationInfected
FROM SQLPortfoglioProject..CovidDeaths
GROUP BY Location,Population
order by PercentPopulationInfected desc

--- COUNTRIES WITH HIGHEST DEATH COUNT PER POPOLATION

SELECT *
FROM SQLPortfoglioProject..CovidDeaths
WHERE continent is not null
order by 3,4

SELECT Location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLPortfoglioProject..CovidDeaths
WHERE continent is not null
GROUP BY Location,Population
order by TotalDeathCount desc

--- LETS DO BY CONTINENT WITH HIGHEST DEATH COUNT
SELECT location,MAX(cast(total_deaths as int)) as TotalDeathCount
FROM SQLPortfoglioProject..CovidDeaths
WHERE continent is null
GROUP BY location
order by TotalDeathCount desc

--- TOTAL GLOBAL DEATH PERCENTAGE NUMBERS
SELECT SUM(new_cases)as total_cases, SUM( cast (new_deaths as int)) as total_deaths ,SUM(cast(New_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM SQLPortfoglioProject..CovidDeaths
WHERE continent is not null
order by 1,2


--- LETS VIEW THE OTHER TABLE 
SELECT*
FROM SQLPortfoglioProject..CovidVaccinations
WHERE continent is not null
ORDER BY 3,4
--- TOTAL POPULATION VS VACCINATIONS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM SQLPortfoglioProject..CovidDeaths as  dea
JOIN SQLPortfoglioProject..CovidVaccinations as vac
	ON  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- CTE
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM SQLPortfoglioProject..CovidDeaths as  dea
JOIN SQLPortfoglioProject..CovidVaccinations as vac
	ON  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac


---TEMP TABLE
drop table #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM SQLPortfoglioProject..CovidDeaths as  dea
JOIN SQLPortfoglioProject..CovidVaccinations as vac
	ON  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--- DATA FOR VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM SQLPortfoglioProject..CovidDeaths as  dea
JOIN SQLPortfoglioProject..CovidVaccinations as vac
	ON  dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


select *
From PercentPopulationVaccinated