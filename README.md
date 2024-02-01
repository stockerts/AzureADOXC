
## Appendix

- Requirements
- Features
- Artifacts
- Enviroment Variables

## Requirements

**F5 Distributed Cloud**

*with access to create, update*

- Credentials/Service Credentials
- Namespaces
- Load Balancers
- Origin Pools
- Health Checks
- Service Policies

**Azure DevOps**

*with access to create, update*

- Repos
- Pilelines
- Service Connections

**Azure Platform**

*with access to create, update*

- App Registation
- Key Vault*

## Features

Create, Update and Delete
- Load Balancer (Internet)
- Origin (Public DNS)
- Health Check
- Service Policy * (IP Allow, Source Deny)

## Artifacts

PowerShell

- xc_api_request.ps1
- xc_api_request_kv.ps1 (using Azure Key Vault to store secrets)

Pipeline YAML

- azure.yaml
- azure_kv.yaml (using Azure Key Vault to store secrets)
- azure_kv_policy.yaml (using Azure Key Vault to store secrets, includes service policies)

## Environment Variables

Azure DevOps Pipline

`azsubname`

`azkvname` *

`azkvsecretname` *

Distributed Cloud

`namespace`

`domain`

`method`

Repository

`directory`

