# PowerShell Script to Consolidate GitHub Assignment Repos

# Define the list of repositories and their target folder names
$repos = @(
    @{ url = "https://github.com/Gauravsin522/Basic_python"; folder = "Assignment_01" },
    @{ url = "https://github.com/Gauravsin522/Second_Assingment"; folder = "Assignment_02" },
    @{ url = "https://github.com/Gauravsin522/Third_Assignment-"; folder = "Assignment_03" },
    @{ url = "https://github.com/Gauravsin522/fouth_Assignment"; folder = "Assignment_04" },
    @{ url = "https://github.com/Gauravsin522/Fifth_assignment"; folder = "Assignment_05" },
    @{ url = "https://github.com/Gauravsin522/Sixth_Assingment"; folder = "Assignment_06" },
    @{ url = "https://github.com/Gauravsin522/Seventh_Assignment"; folder = "Assignment_07" },
    @{ url = "https://github.com/Gauravsin522/Eight-Assignment"; folder = "Assignment_08" },
    @{ url = "https://github.com/Gauravsin522/Nineth"; folder = "Assignment_09" },
    @{ url = "https://github.com/Gauravsin522/Ninth_assignment"; folder = "Assignment_10" },
    @{ url = "https://github.com/Gauravsin522/Tenth-Assignment"; folder = "Assignment_11" },
    @{ url = "https://github.com/Gauravsin522/Eleveth_assignment"; folder = "Assignment_12" },
    @{ url = "https://github.com/Gauravsin522/Tweth_Assignment"; folder = "Assignment_13" },
    @{ url = "https://github.com/Gauravsin522/Thirteenth-Assignment"; folder = "Assignment_14" },
    @{ url = "https://github.com/Gauravsin522/Fourteenth-Assignment"; folder = "Assignment_15" },
    @{ url = "https://github.com/Gauravsin522/Fifteenth-Assignment"; folder = "Assignment_16" },
    @{ url = "https://github.com/Gauravsin522/Sixteen_Assingment"; folder = "Assignment_17" },
    @{ url = "https://github.com/Gauravsin522/Seveteenth-Assingment"; folder = "Assignment_18" },
    @{ url = "https://github.com/Gauravsin522/Eighteen-Assignment"; folder = "Assignment_19" },
    @{ url = "https://github.com/Gauravsin522/Nineteenth-Assignment"; folder = "Assignment_20" },
    @{ url = "https://github.com/Gauravsin522/Twentieth-Assignment-"; folder = "Assignment_21" },
    @{ url = "https://github.com/Gauravsin522/twenty-one"; folder = "Assignment_22" },
    @{ url = "https://github.com/Gauravsin522/twenty-two"; folder = "Assignment_23" },
    @{ url = "https://github.com/Gauravsin522/Twenty-three"; folder = "Assignment_24" },
    @{ url = "https://github.com/Gauravsin522/Twenty-four-assignment"; folder = "Assignment_25" },
    @{ url = "https://github.com/Gauravsin522/Twenty_five-Assignment"; folder = "Assignment_26" },
    @{ url = "https://github.com/Gauravsin522/Twenty_sixth_Assignment"; folder = "Assignment_27" }
)

Write-Host "`n=== Starting GitHub Assignment Consolidation ===`n"

foreach ($repo in $repos) {
    $url = $repo.url
    $tempFolder = ($url.Split('/')[-1]).Replace(".git", "")
    $targetFolder = $repo.folder

    if (Test-Path $targetFolder) {
        Write-Host "SKIP: $targetFolder already exists."
        continue
    }

    Write-Host "Cloning: $url"
    git clone $url | Out-Null

    if (!(Test-Path $tempFolder)) {
        Write-Host "ERROR: Failed to clone $url"
        continue
    }

    Write-Host "Renaming '$tempFolder' to '$targetFolder'"
    Rename-Item -Path $tempFolder -NewName $targetFolder

    $gitFolder = Join-Path $targetFolder ".git"
    if (Test-Path $gitFolder) {
        Write-Host "Removing .git folder from $targetFolder"
        Remove-Item -Recurse -Force $gitFolder
    }

    Write-Host "Done: $targetFolder`n"
}

Write-Host "`n=== All Repositories Processed ===`n"
