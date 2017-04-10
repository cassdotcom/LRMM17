<#
.NAME
    LRMM_Disable-PESubsystems
.SYNOPSIS
    Disable PE subsystems
.DESCRIPTION
    Identify all PE subsystems and set pipe status to DISABLED
.EXAMPLE
    $pipes = LRMM_Disable-PESubsystems -pipes <<$644006_pipes>> -minPercentPE <<95>>
.INPUTS pipes
    object containing pipes from imported exchange file
.INPUTS minPercentPE
    value between 0 and 100 to specify what is an all PE subsystem
.OUTPUTS pipes
    object containing modified pipes
.NOTES

.REVISION
    0    
.FILE_ID
    LRMM100
.FUNCTION_ID
    LRMM-ZP3CJKXI-FDHII9JC-V1UF
.COMPONENT
    LRMM_Module
#>
function LRMM_Disable-PESubsystems
{
    [CmdletBinding()]
    Param(
        [Parameter()]
        [System.Object]
        $pipes,

        [Parameter()]
        [System.Double]
        $minPercentPE
    )

    # This array holds all the subsystem IDs
    $subsystemIndex = @()

    Try 
    {
        # Select one example of each subsystem -- use @(..) to force an array, this lets us count when there is only one subsystem
        $subsystems = @($pipes | sort -Property FacilitySubsystemID -Unique)

        # Count subsystems
        $noOfSubsystems = $subsystems.Count

        # Loop through subsystems and collect IDs 
        for ( $i = 0; $i -lt $noOfSubsystems; $i++ ) {
        
            $subsystemIndex += $subsystems[$i].FacilitySubsystemID
        
        }

        Write-Verbose "There are $($noOfSubsystems) subsystems"
    } 
    Catch
    {
        Write-Verbose "ERROR 1: Unable to identify unique subsystems"
        Write-Verbose "EXCEPTION:`t$($Error[-1].Exception)"
        Write-Verbose "SCRIPT:`t$($Error[-1].InvocationInfo.ScriptName)"
        Write-Verbose "POSITION:`tLine $($Error[-1].InvocationInfo.ScriptLineNumber) Offset $($Error[-1].InvocationInfo.OffsetInLine)"
        break
    }

    # Process each subsystem
    Try {
        for ( $i = 0; $i -lt $noOfSubsystems; $i++ ) {

            Write-Verbose "Processing sub $($i)"

            # Count all pipes in subsystem
            $subs = @($pipes | where { $_.FacilitySubsystemID -match $subsystemIndex[$i] })
            $subsCount = $subs.Count
            Write-Verbose "`tThere are $($subsCount) pipes in subsystem $($subsystemIndex[$i])"

            # Count PE pipes in subsystem
            $subsPE = @($subs | where { $_.PipeMaterial -match "PE" })
            $subsPECount = $subsPE.Count
            Write-Verbose "`tThere are $($subsPECount) PE pipes in subsystem $($subsystemIndex[$i])"

            # Calculate % of PE in subsystem
            $percentagePE = ($subsPECount / $subsCount) * 100
            Write-Verbose "`t$($percentagePE)% of this subsystem is PE"

            # If subsystem is greater than minimum PE % disable all pipes
            if ($percentagePE -ge $minPercentPE) {
                Write-verbose "`tDisable all pipes in subsystem $($subsystemIndex[$i])"
                $pipes | where { $_.FacilitySubsystemID -match $subsystemIndex[$i] } | foreach { $_.FacilityServiceState = "DISABLED" }
            } else {
                Write-Verbose "`tSubsystem not altered"
            }

        }
    }
    Catch
    {
        Write-Verbose "ERROR 2: Unable to process subsystem"
        Write-Verbose "EXCEPTION:`t$($Error[-1].Exception)"
        Write-Verbose "SCRIPT:`t$($Error[-1].InvocationInfo.ScriptName)"
        Write-Verbose "POSITION:`tLine $($Error[-1].InvocationInfo.ScriptLineNumber) Offset $($Error[-1].InvocationInfo.OffsetInLine)"
        break
    }

    return $pipes
}