function LRMM_Collect-ASP
{

    $networks = import-csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks_Test.csv"

    foreach ( $n in $networks ) 
    {
        Write-Host "$($n.TITLE)"
        
        if ( $n.ScriptBDone -match "Y" )
        {
            # COUNT ACTIVE DGs
            # ================
            # Open nodes file - 100% demand
            $nodeSubs = Import-Csv $n.NodeSubsFile

            # Count active DGs
            $DGCount = (@($nodeSubs | where { $_.NodeStatus -match "Known Pressure" } | where { $_.NodeActiveState -match "-1.000000" })).count
            Write-Host "`tDGCount: $($DGCount)"
            
            # Record number of DGs
            $n.DGCount = $DGCount



            # MINIMUM PRESSURE
            # ================
            # Get active nodes
            $activeNodes = @($nodeSubs | where { $_.NodeActiveState -match "-1.000000" })

            # Test for -1.00
            if ( $activeNodes.Count -eq 0 )
            {
                $activeNodes = @($nodeSubs | where { $_.NodeActiveState -match "-1.00" })
            }

            $minPressure = ($activeNodes | measure -Property NodeResultPressure -Minimum).Minimum

            $n.MinPressure = $minPressure
            Write-Host "`tmin. pressure: $($minPressure)"

            # Get minimum pressure node
            $minPressureNode = @($activeNodes | where { $_.NodeResultPressure -match $minPressure })
            $n.MinPressureNode = $minPressureNode[0].NAME
            Write-Host "`tmin. pressure node: $($minPressureNode[0].NAME)"
        }
        else
        {
            Write-Host "Missing nodes file"
        }


        if ( $n.ScriptBDone -match "Y" )
        {
            # GET AVERAGE SYSTEM PRESSURE
            # ===========================
            # Get ASP
            $mains = Import-Csv $n.PipeFileB
            $activeMains = $mains | where { $_.FacilityServiceState -match "ENABLED" }
            $asp = ($activeMains | measure -Property PipeAvePressure -Average).Average
            $n.ASP = $asp
            Write-Host "`tASP: $($asp)"



            # EXCLUDED PE LENGTH
            # ==================
            $mainsLength = ($activeMains | measure -Property PipeLength -Sum).Sum
            $excludedLength = $n.PipeLength - $mainsLength
            $n.ExcludedPELen = $excludedLength
            Write-Host "`tExcluded length: $($excludedLength)"
        }
        else
        {
            Write-Host "Missing mains file"
        }

    }

    $networks | Export-csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks_Test.csv" -NoTypeInformation
}
