#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\get-image.ps1"


$IMAGE = $env:IMAGE
$DIR_PATH = Split-Path -Parent $MyInvocation.MyCommand.Definition

$null = New-Item -Type Directory -Path "$DIR_PATH\..\..\dist\gemfiles" -ErrorAction Ignore

$MOUNT_DIR = (Resolve-Path "$DIR_PATH\..\..\dist\gemfiles").Path
$GEMFILE_LOCK_PATH=(Resolve-Path "$DIR_PATH\..\..\package\windows\Gemfile.lock").Path

docker run -it -v "${MOUNT_DIR}:C:\gems" ${IMAGE} powershell C:\fluentd\install\upgrade-gems.ps1

cp $MOUNT_DIR\Gemfile.lock $GEMFILE_LOCK_PATH