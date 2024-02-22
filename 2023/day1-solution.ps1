# Get day 1 input
$content = Get-Content .\day1-input.txt

# Create an empty object to store values in
$total = @()

# Process each of the 1000 entries, find all numbers in each entry, and combine the first and last number, add to the $total object.
foreach ($entry in $content) {
    $entrymatches = $entry | Select-String -Pattern '[0-9]' -AllMatches | Select-Object -ExpandProperty Matches

    # Put the numbers together
    [int]$combined = $entrymatches[0].Value + $entrymatches[-1].Value

    # Add to object
    $total += $combined
}

# Do the math and find the sum
$total | Measure-Object -Sum