Select *
From COVID19DATABASE..CovidDeaths$
Where continent is not null
order by 3,4

--Select *
--From COVID19DATABASE..CovidVaccinations$
--order by 3,4

-- Select Data that we are going to use

Select Location,date, total_cases,new_cases,total_deaths,population
From COVID19DATABASE..CovidDeaths$
order by 1,2


--Looking at TOTAL CASES vs TOTAL Deaths
--Shows the likilihood of dying if you get infected
--DEATH PERCENTAGE IN A COUNTRY

Select Location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From COVID19DATABASE..CovidDeaths$
Where continent is not null
order by 1,2

--Looking at the Total Cases vs Population
--Shows what % of population got covid
--INFECTION RATE
Select Location,date,population,total_cases,(total_cases/population)*100 as Infection_Rate
From COVID19DATABASE..CovidDeaths$
Where continent is not null
order by 1,2

-- Looking at the countries with highest Infection rate compared to Population
--MAX INFECTION RATE
Select Location,population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population)*100) as Percent_Population_Infected
From COVID19DATABASE..CovidDeaths$
--Where location like '%States%'
Where continent is not null
Group by location, population
order by Percent_Population_Infected desc


--Let's BREAK THINGS DOWN BY CONTINENT
--Showing Continents with the highest death count per Population
Select Location,Max(cast(Total_deaths as int)) as Total_Death_Count
From COVID19DATABASE..CovidDeaths$
Where continent is null
Group by location
order by Total_Death_Count desc



--Showing Countries with the highest death count per Population
Select Location,Max(cast(Total_deaths as int)) as Total_Death_Count
From COVID19DATABASE..CovidDeaths$
Where continent is not null
Group by location
order by Total_Death_Count desc


--SHOWING CONTINENT WITH HIGHEST DEATH COUNT
Select continent,Max(cast(Total_deaths as int)) as Total_Death_Count
From COVID19DATABASE..CovidDeaths$
Where continent is not null
Group by continent
order by Total_Death_Count desc

--GLOBAL NUMBERS
--TOTAL CASES & TOTAL DEATHS IN THE WORLD

Select SUM(new_cases)as TOTAL_CASES,SUM(CAST (new_deaths as int))as TOTAL_DEATHS,SUM(CAST (new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From COVID19DATABASE..CovidDeaths$
Where continent is not null
order by 1,2

--LOOKING at Total Population vs Vaccinations 

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
From COVID19DATABASE..CovidDeaths$ dea
Join COVID19DATABASE..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	order by 1,2,3

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int))OVER(Partition by dea.Location ORDER by dea.location,dea.Date )as TOTAL_VACCINATIONS
From COVID19DATABASE..CovidDeaths$ dea
Join COVID19DATABASE..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date=vac.date
	Where dea.continent is not null
	order by 2,3

	--Using CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From COVID19DATABASE..CovidDeaths$ dea
Join COVID19DATABASE..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as Vac_Percentage
From PopvsVac



--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
TOTAL_VACCINATIONS numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(CAST(vac.new_vaccinations as int))OVER(Partition by dea.Location ORDER by dea.location,dea.Date )as TOTAL_VACCINATIONS
From COVID19DATABASE..CovidDeaths$ dea
Join COVID19DATABASE..CovidVaccinations$ vac
	On dea.location =vac.location
	and dea.date=vac.date
	Where dea.continent is not null
--where dea.continent is not null 
--order by 2,3

Select *, (TOTAL_VACCINATIONS/Population)*100 as Vac_Percentage
From #PercentPopulationVaccinated







