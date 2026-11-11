# SPDX-License-Identifier: GPL-3.0-or-later

$gitRemote = 'origin'
$stopOnError = $false

foreach ($argument in $args) {
    switch -CaseSensitive ($argument) {
        { $_ -eq '-d' -or $_ -eq '--debug' } {
            $DebugPreference = 'Continue'
        }
        { $_ -eq '-e' -or $_ -eq '--error' } {
            $stopOnError = $true
        }
        default {
            $gitRemote = $argument
        }
    }
}

if (-not (Test-Path -LiteralPath '.git' -PathType Container)) {
    Write-Output 'No git repo found'
    exit 1
}

Write-Debug "Getting fetch URL for remote '$gitRemote'"
$fetchUrl = (& git remote get-url $gitRemote | Out-String).Trim()
$gitExitCode = $LASTEXITCODE
if ($gitExitCode -ne 0) {
    exit $gitExitCode
}

# Convert URLs such as https://github.com/user/repo.git to git@github.com:user/repo.git.
$match = [regex]::Match($fetchUrl, '^(?:[A-Za-z][A-Za-z0-9+.-]*://)?(?:[^/@:]+@)?([^/:]+)(?:/)(.+)$')
if (-not $match.Success) {
    [Console]::Error.WriteLine("Unable to parse fetch URL: $fetchUrl")
    exit 1
}

$gitHost = $match.Groups[1].Value
$gitRepo = $match.Groups[2].Value
$pushUrl = "git@${gitHost}:${gitRepo}"

Write-Debug "Setting push URL for '$gitRemote' to '$pushUrl'"
& git remote set-url --push $gitRemote $pushUrl
$gitExitCode = $LASTEXITCODE
if ($stopOnError -and $gitExitCode -ne 0) {
    exit $gitExitCode
}
exit $gitExitCode
