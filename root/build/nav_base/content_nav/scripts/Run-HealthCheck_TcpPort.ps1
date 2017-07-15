param(
    [Parameter(Mandatory=$true)]
    [int]$TcpPort
)

if (!(Test-NetConnection -ComputerName localhost -Port $TcpPort).TcpTestSucceeded) 
{ 
    Write-Error "Service on the port $TcpPort is not available"
    exit 1
} 
else
{
    exit 0
}