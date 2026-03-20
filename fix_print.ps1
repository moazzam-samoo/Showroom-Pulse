Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | Where-Object { $_.Name -notlike "*.g.dart" } | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match '(?m)^\s*(print\()') {
        $newContent = $content -replace '(?m)(?<=^\s*)print\(', 'debugPrint('
        Set-Content -Path $_.FullName -Value $newContent -NoNewline
        Write-Output "Fixed: $($_.FullName)"
    }
}
