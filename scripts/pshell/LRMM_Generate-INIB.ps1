function LRMM_Generate-INIB
{

    $lrmmNetworks = Import-Csv "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\data\LRMM_Networks.csv"
    $lrmmLOG = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\LRMM_Log.txt"
    $lrmmASPPath = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\modelsOut\"
    $outPath = "\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\LRMM_B"

    
    for ( $i=5; $i -lt 24; $i++ ) 
    {
        Write-Host "$($i)"

        $modelGroup = $lrmmNetworks | where { $_.LRMMRun -eq $i }

        $modelCount = $modelGroup.Count

        $iniLine = @()
        $iniLine2 = @()
        $iniLine3 = @()

        $modelNo = 1

        foreach ( $n in $modelGroup )
        {
            # Model names
            $iniLine += "ModelName$($modelNo)=$($n.TITLE)"
            # Models in
            $modelOut = $lrmmASPPath + $n.ModeloutA
            $iniLine2 += "Model$($modelNo)=$($modelOut)"
            # Model subs
            $iniLine3 += "ModelSubs$($modelNo)=$($n.ProcessedPipeFile)"

            $modelNo++
        }

        $outFile = $outPath + $i + ".ini"
        
        # Assign this ini file to db for record-keeping
        $lrmmNetworks | where { $_.LRMMRun -eq $i } | foreach { $_.B_ini = $outFile }
            

$header = @"
[LOGS]
script_log_synergee=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\script_log_synergee_subs_$i
analysis_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\analysis_log_subs_$i
script_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\script_log_subs_$i
validation_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\validation_log_subs_$i
data_import_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\data_import_log_subs_$i
data_export_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\data_export_log_subs_$i
general_log=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\logs\general_log_subs_$i


[SUPPLEMENTS]
workspace=\\sgn\dfs\Shared\SYN4.7.1\UsersWorkspaces\jf74313_471\WorkspaceDefaultG.ws.mdb
warehouse=\\sgn\dfs\shared\Syn4.7.1\UsersWorkspaces\ac00418_471\WarehouseDefaultG.wh.mdb


[EXCHANGE]
LRMMProfiles_25pc=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\exchange\LRMMProfiles_25pc.csv
LRMMProfiles_25pcSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ImportProfiles_25pc.ini
LRMMProfiles_25pcWorksheet="LRMMProfiles_25pc"
LRMMSubsystemsSettings = \\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ImportSubsystems.ini

ExportNodesSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportNodes.ini
ExportMainsSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportMains.ini
ExportFlowsSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ExportFlows.ini
exchangeFilePath=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\output\
ImportPotsOff=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\exchange\LRMMPotsOff.csv
ImportPotsOffSettings=\\scotia.sgngroup.net\dfs\shared\Syn4.2.3\TEST AREA\ac00418\LRMM17\settings\ImportPotsOff.ini
ImportPotsOffWorksheet="LRMMPotsOff"


[MODELDATA]
number_of_models=40
start_at=1

[MODELNAMES]
"@
    
        $header | Out-File $outFile

        $iniLine | Out-File $outFile -Append
        " " | Out-File $outFile -Append
        "[MODELSIN]" | Out-File $outFile -Append
        $iniLine2 | Out-File $outFile -Append
        " " | Out-File $outFile -Append
        "[MODELSUBS]" | Out-File $outFile -Append
        $iniLine3 | Out-File $outFile -Append

    }
}