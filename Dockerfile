#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat 

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /application
EXPOSE  80 443


# Copy csproj and restore as distinct layers
COPY ["EmpApplication.csproj","./"]
RUN dotnet restore "./EmpApplication.csproj"

# Copy everything else and build
COPY . ./
WORKDIR /application/.
RUN dotnet build "EmpApplication.csproj" -c Release -o /application/build

FROM build AS publish
RUN dotnet publish "EmpApplication.csproj" -c Release -o /application/publish

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /application
COPY --from=publish /application/publish .
ENTRYPOINT ["dotnet", "EmpApplication.dll"].
