# NOTE: This script must currently be executed from the solution dir (due to specs)
Param([string]$server, [string]$additionalSQL, [string] $appName)
$ErrorActionPreference = "Stop"

# Set location to the Solution directory
(Get-Item $PSScriptRoot).Parent.FullName | Push-Location

Import-Module .\build\exechelper.ps1

# Install .NET tooling

exec .\build\dotnet-cli-install.ps1
# Get cli tool
try
{
    exec "dotnet" "tool install EPiServer.Net.Cli --global --add-source http://nuget-dev.ep.se/nuget --version 1.0.0-inte-020024"
}
catch
{
   try
   {
    exec "dotnet" "tool update EPiServer.Net.Cli --global --add-source http://nuget-dev.ep.se/nuget --version 1.0.0-inte-020024"
   }
   catch
   {

   }
}
dotnet-episerver create-cms-database ".\src\Foundation\Foundation.csproj" -S "$server" $additionalSQL --database-name "$appName.Cms"

Pop-Location