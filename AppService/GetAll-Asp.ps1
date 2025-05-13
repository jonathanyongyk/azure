param (
    [Parameter(Mandatory = $true)]
    [string]$subscriptionId
)

# Login to Azure
#Connect-AzAccount

# Set the subscription
Set-AzContext -SubscriptionId $subscriptionId

# Get the subscription details
$subscription = Get-AzContext

# Get all resource groups in the subscription
$resourceGroups = Get-AzResourceGroup

# Initialize an array to hold the results
$allAsp = @()
$allWebs = @()

foreach ($resourceGroup in $resourceGroups) {
    # Get all app service plans in the resource group
    $appServicePlans = Get-AzAppServicePlan -ResourceGroupName $resourceGroup.ResourceGroupName
        
    foreach ($appServicePlan in $appServicePlans) {
        $raw = (az appservice plan show --name $appServicePlan.Name -g $resourceGroup.ResourceGroupName) | out-string
        $asp = convertfrom-json $raw
        # Add the details to the allAsp array

        $osType = "Windows"
        if($appServicePlan.kind -eq "linux"){
            $osType = "linux"
        }
        elseif ($appServicePlan.kind -eq "app") {
            $osType = "windows"
        }
        else {
            $osType = $appServicePlan.kind
        }


        $allAsp += [PSCustomObject]@{
            SubscriptionId   = $subscription.Subscription.Id
            SubscriptionName = $subscription.Subscription.Name
            ResourceGroupName = $resourceGroup.ResourceGroupName
            ResourceName     = $appServicePlan.Name
            Location         = $appServicePlan.Location
            SkuName          = $appServicePlan.Sku.Name
            ZoneRedundant    = if ($asp.properties.ZoneRedundant) { "Enabled" } else { "Not Enabled" }
            OS               =  $osType
            InstanceCount    =  $appServicePlan.Sku.capacity      
            ResourceId       = $appServicePlan.Id                            
        }

        # Get all web apps in the app service plan
        $webApps = Get-AzWebApp -ResourceGroupName $resourceGroup.ResourceGroupName | Where-Object { $_.ServerFarmId -eq $appServicePlan.Id }

        foreach ($webApp in $webApps) {
            # Add the details to the allWebs array

            $allWebs += [PSCustomObject]@{
                ResourceGroupName = $resourceGroup.ResourceGroupName
                WebAppName       = $webApp.Name
                AppServicePlan   = $appServicePlan.Name
                WebAppState      = $webApp.State
                ResourceId       = $webApp.Id
            }
        }

    }
}

# Export the results to a CSV file
$allAsp | Export-Csv -Path "./appserviceplans.csv" 
$allWebs | Export-Csv -Path "./webapps.csv"
