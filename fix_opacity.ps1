Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Where-Object { $_.Name -notlike "*.g.dart" } | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '\.withOpacity\(') {
        $newContent = $content -replace '\.withOpacity\((\d+\.?\d*)\)', '.withValues(alpha: $1)'
        Set-Content -Path $_.FullName -Value $newContent -NoNewline
        Write-Output "Fixed: $($_.FullName)"
    }
}
