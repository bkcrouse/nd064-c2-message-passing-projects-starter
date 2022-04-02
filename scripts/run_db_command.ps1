<#
.SYNOPSIS
        Seed the initial postgres database using a powershell version of the ./scripts/run_db_command.sh
.DESCRIPTION
        Long description
.EXAMPLE
        PS C:\> run_db_command.ps1 -Name postgres-5f676c995d-gppfj

        This is the powershell version of the ./scripts/run_db_command.ps1 to run from a Windows workstation running powershell.
.EXAMPLE
        PS C:\> run_db_command.ps1

        This will use the kubectl command to query for a pod named 'postgres'

.PARAMETER Name
        The name of the postgres node to see. Run kubelctl get pods to view the name give to the postgres pod
        
        PS C:\> get pods
        NAME                              READY   STATUS    RESTARTS   AGE
        udaconnect-api-89dbffbf9-n6tmz    1/1     Running   0          12m
        postgres-5f676c995d-gppfj         1/1     Running   0          12m
        udaconnect-app-6ddf7c79fb-ljk5g   1/1     Running   0          12m

.OUTPUTS
        CREATE TABLE
        CREATE TABLE
        CREATE INDEX
        CREATE INDEX
        INSERT 0 1
        INSERT 0 1
        INSERT 0 1
        INSERT 0 1
        INSERT 0 1
        INSERT 0 1
        ...

#>
[cmdletbinding()]
param(
        [Parameter(Mandatory=$false)]
        [string]
        $Name = "$(kubectl get pods --selector=app=postgres -o jsonpath='{.items[*].metadata.name}')"
)

# Set database configurations
$env:CT_DB_USERNAME="ct_admin"
$env:CT_DB_NAME="geoconnections"

$CT_DB_USERNAME=$env:CT_DB_USERNAME
$CT_DB_NAME = $env:CT_DB_NAME

Get-Content -Path ./db/2020-08-15_init-db.sql | kubectl exec -i $Name -- bash -c "psql -U $CT_DB_USERNAME -d $CT_DB_NAME"

Get-Content -Path ./db/udaconnect_public_person.sql | kubectl exec -i $Name -- bash -c "psql -U $CT_DB_USERNAME -d $CT_DB_NAME"

Get-Content -Path ./db/udaconnect_public_location.sql | kubectl exec -i $Name -- bash -c "psql -U $CT_DB_USERNAME -d $CT_DB_NAME"
