--COVID DEMOGRAPHICS OF CANADA

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location = 'canada'
order by 1,2


--LOOKING AT COUNTRIES WITH HIGHEST INFECTED RATE BY POPULATION

select location,population,max(total_cases) as HighestInfectCount,max((total_cases/population))*100 as Infected
from CovidDeaths$

group by location,population
order by Infected desc

--SOHOWING THE COUNTRIES WITH THE HIGHEST DEATH PERCENTAGE PER POPULATION

select location,max(total_deaths) as Highestdeathcount,max((total_deaths/population))*100 as DeathPercentage
from CovidDeaths$
where continent is not null
group by location
order by DeathPercentage desc



--BREAKING IT DOWN INTO CONTINENT


select continent,max(total_deaths) as Highestdeathcount,
max((total_deaths/population))*100 as DeathPercentage
from CovidDeaths$
where continent is not null
group by continent
order by DeathPercentage desc


--SHOWING THE CONTINENTS WITH HIGHEST INFECTED RATE

select continent,max(total_cases) as HighestInfectCount,
max((total_cases/population))*100 as InfectedRate
from CovidDeaths$
where continent is not null
group by continent
order by InfectedRate desc

--GLOBAL NUMBER

select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths,
sum(new_deaths)/sum(new_cases) as DeathRate
from CovidDeaths$
where continent is not null
order by 1,2

--LOOKING AT CANADA's TOTAL POPULATION VS VACCINATION

with POPvsVAC (Continent,location,date,population,new_vaccinations,RollingNumberVaccinated)
as
(
Select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(b.new_vaccinations) over (partition by a.location order by a.location,a.date) as RollingNumberVaccinated
from CovidDeaths$   a
join CovidVaccinations$   b
on a.location=b.location
and a.date=b.date
where a.continent is not null and b.new_vaccinations is not null and a.location='Canada'
--order by 1,2
)
select *, (RollingNumberVaccinated/population)*100
from POPvsVAC



--TEMP TABLE


DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingNumberVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
Select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(b.new_vaccinations) over (partition by a.location order by a.location,a.date) as RollingNumberVaccinated
from CovidDeaths$   a
join CovidVaccinations$   b
on a.location=b.location
and a.date=b.date
where a.continent is not null and b.new_vaccinations is not null and a.location='Canada'
--order by 1,2

select *, (RollingNumberVaccinated/population)*100
from #PercentPopulationVaccinated


--CREATING VIEW TO STORE DATA

CREATE VIEW PercentPopulationVaccinated AS
 Select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(b.new_vaccinations) over (partition by a.location order by a.location,a.date) as RollingNumberVaccinated
from CovidDeaths$   a
join CovidVaccinations$   b
on a.location=b.location
and a.date=b.date
where a.continent is not null and b.new_vaccinations is not null and a.location='Canada'
--order by 1,2

SELECT*
FROM PercentPopulationVaccinated

