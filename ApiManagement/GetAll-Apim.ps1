param (
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [string]$Path = $null
)

# Login to Azure
#Write-Host "Logging in to Azure..."
#Connect-AzAccount -ErrorAction Stop

# Set the subscription context
#Write-Host "Setting subscription context to $SubscriptionId..."
#Set-AzContext -SubscriptionId $SubscriptionId -ErrorAction Stop

# Get the subscription details
$subscription = Get-AzContext

# Get all API Management instances in the subscription
Write-Host "Retrieving all API Management instances in subscription $SubscriptionId..."
$apimInstances = Get-AzApiManagement

$allApimInstances = @()

# Output the results
if ($apimInstances) {
    $apimInstances | ForEach-Object {
        $allApimInstances += [PSCustomObject]@{
            SubscriptionId   = $subscription.Subscription.Id
            SubscriptionName = $subscription.Subscription.Name
            ResourceGroup    = $_.ResourceGroupName
            ResourceName     = $_.Name
            Location         = $_.Location
            SkuName          = $_.Sku
            AvailabilityZone = $_.Zone -join ','
            NoOfAvailabilityZone = $_.Zone.Count
            ResourceId       = $_.Id
        }
    }
} else {
    Write-Host "No API Management instances found in subscription $SubscriptionId."
}


# Export the results to a CSV file if the path is provided
if ($Path) {
    $allApimInstances | Export-Csv -Path $Path
} else {
    $allApimInstances
}