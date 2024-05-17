--Creating View to store data for later visualizations
Create View VacPOP as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as TOTAL_VACCINATIONS
--, (RollingPeopleVaccinated/population)*100
From COVID19DATABASE..CovidDeaths$ dea
Join COVID19DATABASE..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 