Import-Module WebAdministration

$CsvPath = "C:\Jenkinsyml\iis_structure.csv"

$Rows = Import-Csv $CsvPath

$MainSiteName = ""

foreach ($Row in $Rows) {

    if ([string]::IsNullOrWhiteSpace($Row.Type)) { continue }

    $Type         = $Row.Type
    $Name         = $Row.Name
    $AppPool      = $Row.AppPool
    $PhysicalPath = $Row.PhysicalPath
    $Port         = $Row.Port

    if ($Type -eq "Site") {

        Write-Host "Creating Main Site: $Name"

        $MainSiteName = $Name

        if (!(Test-Path $PhysicalPath)) {
            New-Item -ItemType Directory -Path $PhysicalPath | Out-Null
        }

        if (!(Test-Path "IIS:\AppPools\$AppPool")) {
            New-WebAppPool -Name $AppPool
        }

        if (!(Test-Path "IIS:\Sites\$Name")) {
            New-Website -Name $Name `
                        -Port $Port `
                        -PhysicalPath $PhysicalPath `
                        -ApplicationPool $AppPool
        }

        Start-Website $Name
    }

    elseif ($Type -eq "Application") {

        Write-Host "Creating Application: $Name"

        if (!(Test-Path $PhysicalPath)) {
            New-Item -ItemType Directory -Path $PhysicalPath | Out-Null
        }

        if (!(Test-Path "IIS:\AppPools\$AppPool")) {
            New-WebAppPool -Name $AppPool
        }

        if (!(Test-Path "IIS:\Sites\$MainSiteName\$Name")) {
            New-WebApplication `
                -Site $MainSiteName `
                -Name $Name `
                -PhysicalPath $PhysicalPath `
                -ApplicationPool $AppPool
        }
    }
}

Write-Host "IIS Structure Created Successfully!"