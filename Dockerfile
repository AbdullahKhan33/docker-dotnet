# Use the official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.sln . 
COPY MyWebAPI/*.csproj ./MyWebAPI/
RUN dotnet restore MyWebAPI/MyWebAPI.csproj

# Copy everything else and build
COPY . ./
WORKDIR /app/MyWebAPI
RUN dotnet publish -c Release -o out

# Create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build-env /app/MyWebAPI/out .

# Expose ports
EXPOSE 80
EXPOSE 443

# Set the entry point
ENTRYPOINT ["dotnet", "MyWebAPI.dll"]
