FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY ["microservice_template.csproj", "./"]

RUN dotnet restore "./microservice_template.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "microservice_template.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "microservice_template.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "microservice_template.dll"]