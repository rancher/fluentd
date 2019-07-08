#Requires -Version 5.0
$ErrorActionPreference = "Stop"

Invoke-Expression -Command "$PSScriptRoot\version.ps1"

$DIR_PATH = Split-Path -Parent $MyInvocation.MyCommand.Definition
$SRC_PATH = (Resolve-Path "$DIR_PATH\..\..").Path
cd $SRC_PATH

$null = New-Item -Type Directory -Path bin -ErrorAction Ignore
$env:GOARCH=$env:ARCH
$env:GOOS='windows'
$env:CGO_ENABLED=0
$LINKFLAGS = ('-X main.VERSION={0} -s -w -extldflags "-static"' -f $env:VERSION)
go build -i -tags k8s -ldflags $LINKFLAGS -o .\bin\fluentd.exe