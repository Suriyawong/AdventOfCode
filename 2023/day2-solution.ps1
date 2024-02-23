# Setup collection for possible game number total
$script:allResults = @()
$possibleGames = @()
$powerSum = @()

# Ingest input.
$content = Get-Content .\day2-input.txt

# Process each row
foreach ($game in $content) {
    # Split the game number and the subsets
    $gameResults = $game.Split(":")

    # Pull out game number as an integer
    [int]$gameNumber = $gameResults[0] | Select-String -Pattern "\d{1,3}" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value

    # Split out the subsets from each game
    $subsets = $gameResults[1].Split(";")

    # For each subset, grab the number of cubes
    foreach ($subset in $subsets) {
        

        # Write each number to a value in a custom object
        Clear-Variable custom
        $custom = [PSCustomObject]@{
            Game = $gameNumber
            #Red = [int]($subset | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
            #Green = [int]($subset | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
            #Blue = [int]($subset | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
        }

        # Add logic for missing cubes and populate values for Red, Green, and Blue properties
        switch ($custom) {
            {($subset | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $false } { $custom | Add-Member -MemberType NoteProperty -Name Red -Value 0 }
            {($subset | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $false } { $custom | Add-Member -MemberType NoteProperty -Name Green -Value 0 }
            {($subset | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $false } { $custom | Add-Member -MemberType NoteProperty -Name Blue -Value 0 }
            {($subset | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $true } { $custom | Add-Member -MemberType NoteProperty -Name Red -Value ([int]($subset | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]) }
            {($subset | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $true } { $custom | Add-Member -MemberType NoteProperty -Name Green -Value ([int]($subset | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]) }
            {($subset | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Success) -eq $true } { $custom | Add-Member -MemberType NoteProperty -Name Blue -Value ([int]($subset | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]) }
        }

        # Check Red, Green, and Blue values and if any are too high, add Possible = $false and stop.  Otherwise, add Possible = $true
        switch ($custom) {
            {[int]$custom.Red -gt 12} { $custom | Add-Member -MemberType NoteProperty -Name Possible -Value $false; break }
            {[int]$custom.Green -gt 13} { $custom | Add-Member -MemberType NoteProperty -Name Possible -Value $false; break }
            {[int]$custom.Blue -gt 14} { $custom | Add-Member -MemberType NoteProperty -Name Possible -Value $false; break }
            Default { $custom | Add-Member -MemberType NoteProperty -Name Possible -Value $true }
        }

        # Add results to $script:allResults
        $script:allResults += $custom
    }
}

$script:allResults | Group-Object -Property Game | ForEach-Object {
    # If any result is False do nothing
    if ($_ | Select-Object -ExpandProperty Group | Select-Object Possible | Select-String False) {
        # Do nothing
    }
    # If all are true, add to total
    else {
        $possibleGames += [int]$_.Name
    }

    # Part 2, find the maximum value for each color in each game to make the game possible, multiply them together to calculate "power"
    $redMinimum = $_.Group.Red | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $greenMinimum = $_.Group.Green | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $blueMinimum = $_.Group.Blue | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
    $powerSum += ($redMinimum * $greenMinimum * $blueMinimum)
}

Write-Host "Number total of possible game numbers: $($possibleGames | Measure-Object -Sum | Select-Object -ExpandProperty Sum)" -ForegroundColor Green
Write-Host "Total power of games: $($powerSum | Measure-Object -Sum | Select-Object -ExpandProperty Sum)" -ForegroundColor DarkYellow