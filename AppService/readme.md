# Overview
This script list out all the App Service Plan in the given Azure subscription and all web apps in the App Service Plan.
The script was written to help me discover if a App Service Plan has Availability Zone enabled as part of my Azure resiliency project. But it can be enhanced/adapt to discover other properties of the App Service Plan and Web Apps or other Azure resources.

# Prerequisites
- Azure Powershell
- Azure CLI

Note
> Most of the scripts is written in Powershell except for the code to get the Zone Redundancy setting of the App Service Plan which is written in Azure CLI. The reason is Azure Powershell does not project this property.


## Install Azure Powershell
You can install Azure Powershell using *Install-PSResource -Name Az -Scope <AllUsers/CurrentUser>*


# Authentication
You need to run *Connect-AzAccount* to authenticate to Azure first before running this script. Alternatively, you can also uncomment the *Connect-AzAccount* command in the script to authenticate to Azure.

# Arguments
This script require one argument which is the subscription id. You may pass to the script via *-subscriptionId* argument.

# Output
The script will generate two CSV files in the current directory. The first file is the list of App Service Plan (**AppServicePlan.csv**) and the second file is the list of Web Apps in the App Service Plan (**WebApp.csv**).
You can then open the files in Excel for further analysis .

# Other options
You can also find the equivalant KQL in **getall_asp.kql** and **getall_webapp.kql** to run in Azure Resource Graph Explorer.


