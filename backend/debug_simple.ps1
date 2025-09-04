# Script de diagnostic simple pour les services
$backendUrl = "http://localhost:3001"
$token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsInJvbGUiOiJ1c2VyIiwiZW1haWwiOiJsZWxlaGVybmFuZGV6MjAwN0B5YWhvby5mciIsInRva2Vuc19iYWxhbmNlIjo5OTk5OTMwNjgyMiwiaWF0IjoxNzU2NTAwMDM5LCJleHAiOjE3NTY1ODY0Mzl9.YowAEhZu2ugad3IRTmBhe_50WJJG53GeI1rUVapWhfY"

Write-Host "Test des services..." -ForegroundColor Cyan

$serviceIds = @(531974, 27)

foreach ($serviceId in $serviceIds) {
    Write-Host "Test du service $serviceId..." -ForegroundColor Gray
    
    try {
        $headers = @{
            "Authorization" = "Bearer $token"
        }
        
        $response = Invoke-RestMethod -Uri "$backendUrl/api/services/$serviceId" -Method GET -Headers $headers
        
        Write-Host "SUCCESS: Service $serviceId" -ForegroundColor Green
        Write-Host "Data keys: $($response.data.PSObject.Properties.Name -join ', ')" -ForegroundColor White
        
        if ($response.data.titre_service) {
            Write-Host "Titre: $($response.data.titre_service)" -ForegroundColor Green
        } else {
            Write-Host "Pas de titre_service" -ForegroundColor Red
        }
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "ERROR $statusCode: Service $serviceId" -ForegroundColor Red
    }
} 