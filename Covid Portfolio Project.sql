Select *
from [Portfolio Project]..CovidDeaths$
order by 3,4

--Select *
--from [Portfolio Project]..CovidVaccinations$
--order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project]..CovidDeaths$
order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths$
where location like '%states%'
order by 1,2


--total case vs population
---who contracted covid

Select location, date, total_cases, total_deaths, (total_deaths/population)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths$
--where location like '%states%'
order by 1,2


--Countries with highest infection rate compared to population


Select Location, Population, MAX(total_cases) AS HighestInfectionCount, max(total_deaths/population)*100 as PercentPopulationInfected
from [Portfolio Project]..CovidDeaths$
--where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



--Showing Countries with Highest death count

Select Location, MAX(cast(total_deaths as bigint)) as totaldeathcount
from [Portfolio Project]..CovidDeaths$
--where location like '%states%'
where continent is not null
Group by Location
order by totaldeathcount desc

--breweak down by continent

Select location, MAX(cast(total_deaths as int)) as totaldeathcount
from [Portfolio Project]..CovidDeaths$
--where location like '%states%'
where continent is null
Group by location
order by totaldeathcount desc


--continents with the highest  death count per population


--global numbers

Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [Portfolio Project]..CovidDeaths$
--where location like '%states%'
where continent is not null
--group by date
order by 1,2




--looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE A CTE

With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select  distinct dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
from PopvsVac
where new_vaccinations is not null
and RollingPeopleVaccinated is not null
order by date





--temp table
Drop table if exists #PercentPopulationVaccinated 
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--create view to store data for later visualizations




Create View PercentPopulatedVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulatedVaccinated