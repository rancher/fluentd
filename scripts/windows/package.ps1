#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\get-image.ps1"

$DIR_PATH = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SRC_PATH = (Resolve-Path "$DIR_PATH\..\..").Path
Set-Location -Path $SRC_PATH\package\windows

$ARCH = $env:ARCH
$TAG = $env:TAG
$IMAGE = $env:IMAGE
$HOST_RELEASE_ID = $env:HOST_RELEASE_ID
$RELEASE_ID = $env:RELEASE_ID

if ($RELEASE_ID -eq $HOST_RELEASE_ID) {
    docker build `
        --build-arg SERVERCORE_VERSION=$RELEASE_ID `
        --build-arg ARCH=$ARCH `
        --build-arg VERSION=$TAG `
        -t $IMAGE `
        -f Dockerfile .
} else {
    docker build `
        --isolation hyperv `
        --build-arg SERVERCORE_VERSION=$RELEASE_ID `
        --build-arg ARCH=$ARCH `
        --build-arg VERSION=$TAG `
        -t $IMAGE `
        -f Dockerfile .
}

$DIST_PATH = "$SRC_PATH\dist\"
$null = New-Item -Type Directory -Path $DIST_PATH -ErrorAction Ignore
Write-Output $IMAGE > "$DIST_PATH\images"
