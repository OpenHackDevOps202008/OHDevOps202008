<#

.SYNOPSIS
    Healthcheck the Uri and display the result.

.DESCRIPTION
    The polling.ps1 display the helthcheck result for each second. You will see the format
    [Timestamp] | [StatusCode] | [Uri]

.PARAMETER Uri
    The target uri for checking the status

.PARAMETER displayUri
    If $true, it displays the Uri in output

.EXAMPLE
PS > .\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor -displayUri $true
.\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor -displayUri $true
21/03/2019 14:21:17 | 200 | https://github.com/Azure-Samples/openhack-devops-proctor
21/03/2019 14:21:21 | 200 | https://github.com/Azure-Samples/openhack-devops-proctor

.EXAMPLE
PS > .\polling.ps1 -Uri https://github.com/Azure-Samples/openhack-devops-proctor
21/03/2019 14:21:55 | 200
21/03/2019 14:21:58 | 200

#>

Param(
    [string] [Parameter(Mandatory=$true)] $Uri,
    [boolean] [Parameter(Mandatory=$false)] $displayUri,
    [int] [Parameter(Mandatory=$false)] $retries = 10
    )

    $counter = 0

while($true) {
  $R = Invoke-WebRequest -URI $Uri
  $timestamp = Get-Date
  $output = ""
  if ($displayUri) {
    $output = $output = '{0} | {1} | {2}' -f($timestamp, $R.StatusCode, $Uri)
  } else {

    $output = '{0} | {1}' -f($timestamp, $R.StatusCode)
  }
  Write-Output $output
  # Break the loop if the requested website answers with 200 and the content contains healthy
  if (($R.StatusCode -eq 200) -and ($R.Content -like "*healthy*")) {
      break
  }
  if ($counter == $retries) {
      exit 1
  }

  Start-Sleep -Seconds 1
}
