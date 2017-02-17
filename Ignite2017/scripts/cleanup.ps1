<#
  .SYNOPSIS 
	MSIgnite 2017 Demo - Cleanup script  
  .NOTES
  Version:        1.0
  Author:         Aaron Saikovski
  Creation Date:  20th January 2017
  Purpose/Change: Initial script development  
#>

Clear-Host

Set-StrictMode -Version 3
$ErrorActionPreference = "Stop"

Import-Module Azure -ErrorAction SilentlyContinue
Import-Module ../scripts/AzureHelper.psm1 -Force 

#Login to the correct subscription
./switch-subs.ps1 -Force

################################################################

#Variables
$ResourceGroupName = @("Demo1","Demo2","Demo2Precanned")


#Cleanup
foreach($rsg in $ResourceGroupName)
{
	DeleteResourceGroup -resourceGroupName $rsg
}



