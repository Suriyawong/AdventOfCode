# Setup collection for possible game number total
$script:allResults = @()

# Ingest input.
$content = Get-Content .\day2-input.txt

# Process each row
ForEach-Object -InputObject $content {
    # Split the game number and the subsets
    $gameResults = $_.Split(":")

    # Pull out game number as an integer
    [int]$gameNumber = $gameResults[0] | Select-String -Pattern "\d{1,3}" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value

    # Split out the subsets from each game
    $subsets = $gameResults[1].Split(";")

    # For each subset, grab the number of cubes
    ForEach-Object -InputObject $subsets {
        <# Determine the number of Red, Green, and Blue
        [int]$red = ($_ | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
        [int]$green = ($_ | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
        [int]$blue = ($_ | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
        #>

        $subset = [PSCustomObject]@{
            Game = $gameNumber
            Red = ($_ | Select-String "\d* red" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
            Green = ($_ | Select-String "\d* green" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
            Blue = ($_ | Select-String "\d* blue" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value).Split(" ")[0]
        }

        $subset

        
        # Check each game and verify whether red > 12, green > 13, or blue > 14 and write result to $allResults
        if ($subset.Red -gt 12 -or $subset.Green -gt 13 -or $subset.Blue -gt 14) {
            $subset = $subset | Add-Member -MemberType NoteProperty -Name Possible -Value $true
        }
        else {
            $subset = $subset | Add-Member -MemberType NoteProperty -Name Possible -Value $false
        }

        $script:allResults += $subset
    }
}

$script:allResults