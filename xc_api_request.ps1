[CmdletBinding()]
param (
    $operation,
    $content,
    $secret,
    $domain,
    $namespace,
    $method,
    $path,
    $filename
)

# Define the header variable
$header = @{
  'Content-Type' = $content
  'Authorization' = $secret
}

# Get the content of the JSON file
$body = Get-Content ".\$path\$filename.json"

# Get the asset name from the JSON file
if ('active_service_policies' -ine $operation) {
$assetname = $body | ConvertFrom-Json |
  Select-Object -ExpandProperty metadata |
  Select-Object -ExpandProperty name
}
  
# Get the request status
if ('active_service_policies' -ine $operation) {
Write-Verbose -Verbose "Checking for $operation named $assetname"
Try {
Invoke-WebRequest -Uri "https://$domain/api/config/namespaces/$namespace/$operation/$assetname" -Method get -Header $header
} Catch {
$status = $_.Exception.Response.StatusCode
}
}

# Create or update the asset based on the request status
if ('NotFound' -eq $status) {
Write-Verbose -Verbose "$assetname within $operation was not found and is being created"
Invoke-WebRequest -Uri "https://$domain/api/config/namespaces/$namespace/$operation" -Method post -Header $header -Body $body
} if ('active_service_policies' -eq $operation) {
Write-Verbose -Verbose "$operation was completed"
Invoke-WebRequest -Uri "https://$domain/api/config/namespaces/$namespace/$operation" -Method post -Header $header -Body $body
} else {
Write-Verbose -Verbose "$assetname within $operation was found and is being updated"
Invoke-WebRequest -Uri "https://$domain/api/config/namespaces/$namespace/$operation/$assetname" -Method $method -Header $header -Body $body
}

# Apply the Azure VNet site plan
if ('azure_vnet_sites' -eq $operation) {
Write-Verbose -Verbose "$assetname within $operation plan is being Applied"

# Wait for the Terraform plan to generate
Start-Sleep 30

# Make a POST request to apply the Terraform plan
Invoke-WebRequest -Uri "https://$domain/api/terraform/namespaces/system/terraform/azure_vnet_site/$assetname/run" -Method post -Header $header -Body '{"action": "APPLY"}'
}
