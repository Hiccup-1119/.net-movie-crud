FROM mcr.microsoft.com/dotnet/aspnet:9.0-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 5156

ENV ASPNETCORE_URLS=http://+:5156

FROM mcr.microsoft.com/dotnet/sdk:9.0-nanoserver-1809 AS build
ARG configuration=Release
WORKDIR /src
COPY ["RazorPagesMovie.csproj", "./"]
RUN dotnet restore "RazorPagesMovie.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "RazorPagesMovie.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "RazorPagesMovie.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RazorPagesMovie.dll"]
