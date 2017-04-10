<#
.NAME
    LRMM_Get-TotalLength
.SYNOPSIS
    Get pipe length
.DESCRIPTION
    Sums length of all pipes
.EXAMPLE
    $pipeLength = LRMM_Get-TotalLength -pipes <<$644006_pipes>>
.EXAMPLE
    $pipeLength = LRMM_Get-TotalLength -pipes <<$644006_pipes>> -allPipes
.INPUTS pipes
    object containing pipes from imported exchange file
.INPUTS allPipes
    switch to calculate pipe length including non-active pipes
.OUTPUTS pipeLength
    value containing pipe length
.NOTES

.REVISION
    0    
.FILE_ID
    LRMM102
.FUNCTION_ID
    LRMM-FGUHE03W-8J4958P0-FCPK
.COMPONENT
    LRMM_Module
#>
function LRMM_Get-TotalLength
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.Object]
        $pipes,

        [Parameter()]
        [switch]
        $allPipes
    )

    Try {
        if ( $allPipes -eq $false ) {
            $pipeLength = ($pipes | where { $_.FacilityServiceState -match "ENABLED" } | measure -Property PipeLength -Sum).Sum
        } else {
            $pipeLength = ($pipes | measure -Property PipeLength -Sum).Sum
        }
    } 
    Catch
    {
        Write-Verbose "ERROR 1: Unable to find pipelength"
        Write-Verbose "EXCEPTION:`t$($Error[-1].Exception)"
        Write-Verbose "SCRIPT:`t$($Error[-1].InvocationInfo.ScriptName)"
        Write-Verbose "POSITION:`tLine $($Error[-1].InvocationInfo.ScriptLineNumber) Offset $($Error[-1].InvocationInfo.OffsetInLine)"
        break
    }

    return $pipeLength

}