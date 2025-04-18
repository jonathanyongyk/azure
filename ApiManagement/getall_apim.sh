az apim list --query "[].{resourceGroup:resourceGroup, resourceName:name, resourceId:id, sku:sku.name, zone:join(',',(zones || ['NA'])), noOfZone:length((zones || ['NA']))}" --output table
