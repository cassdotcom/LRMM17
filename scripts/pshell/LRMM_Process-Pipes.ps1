$dataTable = Data {
    ConvertFrom-StringData @'
        thisRev=1
        minPercentPE=95
        LRMM_NetworksPath=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\data\\LRMM_Networks.csv
        logFile=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\logs\\Detect_Subsystems_
        pipesOutPath=\\\\scotia.sgngroup.net\\dfs\\shared\\Syn4.2.3\\TEST AREA\\ac00418\\LRMM17\\processed\\
'@}

function LRMM_Process-Pipes
{

    # Load networks from csv
    $networks = Import-Csv $dataTable.LRMM_NetworksPath
    $logDate = Get-Date -Format "yyyyMMdd"
    $logFile = $dataTable.logFile + $logDate + ".log"
     

    $counter = 1

    "--------------------------------------------------------------------------------------------" | Out-File $logFile -Append
    "--------------------------------------------------------------------------------------------" | Out-File $logFile -Append
    "Begin Script" | Out-File $logFile -Append


    foreach ( $n in $networks ) {

        # Report on % done
        $pcComplete = ($counter / $networks.Count) * 100
        Write-Progress -Activity "Process pipes" -PercentComplete $pcComplete -CurrentOperation "$($pcComplete)% complete" -Status "$($n.Title)"

        Write-Host "Processing $($n.TITLE)"
        "Processing $($n.TITLE)" | Out-File $logFile -Append
    
        # Skip already existing pipe files
        Try
        {
            $pipesOutFile = $dataTable.pipesOutPath + $n.TITLE + "_Mains_Proc.csv"
            if ( Test-Path $pipesOutFile ) {
                Write-Host "$($n.TITLE) ALREADY EXISTS"
                "$($n.TITLE) ALREADY EXISTS" | Out-File $logFile -Append    
                "--------------------------------------------------------------------------------------------" | Out-File $logFile -Append
                $counter++
                continue
            }
        }
        Catch
        {
            Write-Host "Unable to test path pipe file" -ForegroundColor Yellow -BackgroundColor Black
            "Unable to test path $($n.TITLE) PipeFile" | Out-File $logFile -Append    
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | Out-File $logFile -Append
            $counter++
            continue
        }
    
        # Import mains
        Try 
        {
            $pipes = Import-Csv $n.PipeFileA
        }
        Catch
        {
            Write-Host "Unable to import $($n.TITLE) PipeFile" -ForegroundColor Yellow -BackgroundColor Black
            "Unable to import $($n.TITLE) PipeFile" | Out-File $logFile -Append    
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | Out-File $logFile -Append
            $counter++
            continue
        }
    
        # Calculate total pipe length
        Try
        {
            #$pipeLength = LRMM_Get-TotalLength -pipes $pipes
            $pipeLength = $n.PipeLength
            # $n | Add-Member -MemberType NoteProperty -Name "PipeLength" -Value $pipeLength
            #$n.PipeLength = $pipeLength
            Write-Host "$($n.TITLE) pipelength: $($pipeLength)m"
            "$($n.TITLE) pipelength: $($pipeLength)m" | Out-File $logFile -Append
        }
        Catch
        {
            Write-Host "Unable to calculate pipe length for $($n.TITLE)" -ForegroundColor Yellow -BackgroundColor Black
            "Unable to calculate pipe length for $($n.TITLE)" | Out-File $logFile -Append    
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | Out-File $logFile -Append
            $counter++
            continue
        }
    
        # Disable PE subsystems
        Try
        {
            # Test for all PE networks
            if ( $n.AllPE -match "Y" )
            {
                Write-Host "$($n.NUMBER) is all PE"
                "$($n.NUMBER) is all PE" | Out-File $logFile -Append
                $pipesOut = $pipes
            }
            else
            {
                $pipesOut = LRMM_Disable-PESubsystems -pipes $pipes -minPercentPE $dataTable.minPercentPE -Verbose
            }
        }
        Catch
        {
            Write-Host "Unable to disable subsystems for $($n.TITLE)" -ForegroundColor Yellow -BackgroundColor Black
            "Unable to disable subsystems for $($n.TITLE)" | Out-File $logFile -Append    
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | Out-File $logFile -Append
            $counter++
            continue
        }
    
        # Write pipes out to file
        Try
        {
            $pipesOutFile = $dataTable.pipesOutPath + $n.TITLE + "_Mains_Proc.csv"
            $pipesOut | Export-Csv $pipesOutFile -NoTypeInformation
            #$n | Add-Member -MemberType NoteProperty -Name "PipeOutFile" -Value $pipesOutFile
            $n.PipeOutFile = $pipesOutFile
            "$($n.TITLE) Pipe file processed" | Out-File $logFile -Append
        }
        Catch
        {
            Write-Host "Unable to write to output file $($n.TITLE)" -ForegroundColor Yellow -BackgroundColor Black
            "Unable to write to output file $($n.TITLE)" | Out-File $logFile -Append    
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" | Out-File $logFile -Append
            $counter++
            continue
        }
    
        "--------------------------------------------------------------------------------------------" | Out-File $logFile -Append
    
        $counter++
   
    }

    Write-Host "Finished"
    "FINISHED" | Out-File $logFile -Append
    $networks | Export-Csv $dataTable.LRMM_NetworksPath -NoTypeInformation

}