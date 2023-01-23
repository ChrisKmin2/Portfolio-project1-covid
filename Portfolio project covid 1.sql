--Select*
--from ['Covid DeathsFnl']
--order by 3,4


----Select*
----from ['Covid VacxFnl$']
----order by 3,4

--Select location, date, total_cases, total_deaths, population
--From ['Covid DeathsFnl']
--order by 1,2


----Likelihood of dying after contracting covid in your country

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from ['Covid DeathsFnl']
--where location= 'United states'
--order by 1,2

----Likelihood of dying after contracting covid in your country

--Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--from ['Covid DeathsFnl']
--where location= 'Kenya'
--order by 1,2


----Countries with highest infection rate compared to population
--Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
--From ['Covid DeathsFnl']
----Where location= 'United States'
--Group by location, population
--Order by PercentPopulationInfected


--Showing countries with Highest Death Count per Population

Select location, MAX(Total_deaths) as TotalDeathCount
From ['Covid DeathsFnl']
Where continent is not null
Group by location
Order by TotalDeathCount desc

--Showing continents with highest Deaths

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From ['Covid DeathsFnl']
Where continent is not null
Group by continent
Order by TotalDeathCount desc


--Global numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From ['Covid DeathsFnl']
Where continent is not null
Group by date
Order by 1,2



                    --JOINING TABLES IN SQL
					--then looking at population vs vaccination

Select deat.continent, deat.location, deat.date, deat.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by deat.location order by deat.location, deat.date) as RollingPeopleVaccinated
From ['Covid DeathsFnl'] deat
Join ['Covid VacxFnl$'] vac
    On deat.location=vac.location
	and deat.date=vac.date
where deat.continent is not null
order by 2,3;


  --USE CTE
With PopvsVac (Continent, location, date,population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select deat.continent, deat.location, deat.date, deat.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by deat.location order by deat.location, deat.date) as RollingPeopleVaccinated
From ['Covid DeathsFnl'] deat
Join ['Covid VacxFnl$'] vac
    On deat.location=vac.location
	and deat.date=vac.date
where deat.continent is not null
--order by 2,3
)

Select*
From PopvsVac


   --TEMP TABLE

Create Table  #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

insert into #PercentPopulationVaccinated

Select deat.continent, deat.location, deat.date, deat.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by deat.location order by deat.location, deat.date) as RollingPeopleVaccinated
From ['Covid DeathsFnl'] deat
Join ['Covid VacxFnl$'] vac
    On deat.location=vac.location
	and deat.date=vac.date
--where deat.continent is not null
----order by 2,3


Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



