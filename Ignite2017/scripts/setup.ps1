<#
  .SYNOPSIS 
	MSIgnite 2017 Demo - Setup Script  
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
$ResourceGroupName = 'Demo2'
$ResourceGroupLocation = 'Australia Southeast'

#Template basepath
[string]$baseScriptPath = [System.IO.Directory]::GetParent([System.IO.Directory]::GetParent($MyInvocation.MyCommand.Path))

################################################################

#region TAGS
function TagResourceGroup{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True)]
		[string] $TargetRSG
	)

	[string]$scriptVersion = '1.0.0.0'

	
	#Add tags	
	AddResourceGroupTags -resourceGroupName $targetrsg -resourceGroupTags @{Customer="MSIgniteDemo";Environment="DEMO";ScriptVersion=$scriptVersion}
	
}
#endregion TAGS

################################################################

#Create ResourceGroup & Tag
DeployResourceGroup -resourceGroupName $ResourceGroupName -resourceGroupLocation $ResourceGroupLocation
TagResourceGroup -TargetRSG $ResourceGroupName 

################################################################

#Create Storageaccount
$templateFile = "$baseScriptPath\storage-account\storageaccount.json"
$params = @{storageAccountType="Standard_LRS";storageAccountCount=1;storageAccountSuffix="ign";environment="Test";buildDate="14/02/2017";buildBy="AaronS"}

New-AzureRmResourceGroupDeployment -Name ((Get-ChildItem $templateFile).BaseName + '-' + ((Get-Date).ToUniversalTime()).ToString('MMdd-HHmm')) `
									   -ResourceGroupName $ResourceGroupName `
									   -TemplateFile $templateFile `
									   -TemplateParameterObject $params `
									   -Force
################################################################