#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\version.ps1"

$TAG = $env:TAG
if (-not $TAG) {
    $TAG = ('{0}{1}' -f $env:VERSION, $env:SUFFIX)
}
$REPO = $env:REPO
if (-not $REPO) {
    $REPO = "rancher"
}

if ($TAG | Select-String -Pattern 'dirty') {
    $TAG = "dev"
}

if ($env:DRONE_TAG) {
    $TAG = $env:DRONE_TAG
}

# Get release id as image tag suffix
$HOST_RELEASE_ID = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' -ErrorAction Ignore).ReleaseId
$RELEASE_ID = $env:RELEASE_ID
if (-not $RELEASE_ID) {
    $RELEASE_ID = $HOST_RELEASE_ID
}
$IMAGE = ('{0}/fluentd:{1}-windows-{2}' -f $REPO, $TAG, $RELEASE_ID)

$env:IMAGE = $IMAGE
$env:RELEASE_ID = $RELEASE_ID
$env:HOST_RELEASE_ID = $HOST_RELEASE_ID

Write-Host "IMAGE: $IMAGE"
