# Azure DevOps Variables
[CmdletBinding()]
param (
    $operation,
    $secret,
    $domain,
    $namespace,
    $content,
    $method,
    $path,
    $filename
)

# Nested Variables
$header = @{
    'Content-Type' = $content
    'Authorization' = $secret
}
$body = Get-Content ".\$path\$filename.json"

# Fetch assetname from Json
$assetname = $body | convertfrom-json | Select-Object -ExpandProperty metadata | Select-Object -ExpandProperty name

# Get Request Status
Write-Verbose -Verbose "Checking for $operation named $assetname"
Try {
Invoke-WebRequest -Uri https://$domain/api/config/namespaces/$namespace/$operation/$assetname -Method get -header $header
} Catch {
$status = $_.exception.response.statuscode
}

# Created or Update based on Request Status
if ('NotFound' -eq $status)
{
Write-Verbose -Verbose "$assetname within $operation was not found and is being created"
Invoke-WebRequest -Uri https://$domain/api/config/namespaces/$namespace/$operation -Method post -header $header -body $body
}
else
{
Write-Verbose -Verbose "$assetname within $operation was found and is being updated"
Invoke-WebRequest -Uri https://$domain/api/config/namespaces/$namespace/$operation/$assetname -Method $method -header $header -body $body
}