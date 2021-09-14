#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Gateway.WebApi.csproj", "."]
RUN dotnet restore "./Gateway.WebApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Gateway.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Gateway.WebApi.csproj" -c Release -o /app/publish

FROM base AS final
EXPOSE 44382
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Gateway.WebApi.dll"]