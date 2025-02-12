# Use official .NET SDK as a build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY MyWebAPI.csproj ./
RUN dotnet restore MyWebAPI.csproj

# Copy the entire project and build
COPY . ./
RUN dotnet publish MyWebAPI.csproj -c Release -o out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app/out .

# Expose necessary ports
EXPOSE 80
EXPOSE 443

# Set the entry point
ENTRYPOINT ["dotnet", "MyWebAPI.dll"]
