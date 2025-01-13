# --- INICIO DEL SCRIPT PS ---

# 1. Obtenemos todos los archivos .webp, ordenados por nombre
$files = Get-ChildItem -Path . -Filter "*.webp" | Sort-Object -Property Name

# 2. Iniciamos un array de strings donde iremos acumulando líneas
$output = @()
$output += "export const images = ["  # Línea inicial

# Llevamos un contador para ir generando los "id" => image_1, image_2, etc.
$counter = 1

foreach ($file in $files) {

    # 3. Leemos el contenido y lo convertimos a Base64
    $b64 = [System.Convert]::ToBase64String([IO.File]::ReadAllBytes($file.FullName))

    # 4. Generamos el texto de cada elemento del array
    # Usamos `image_$counter` como "id"
    $element = @"
  {
    "id": "image_$counter",
    "p": "data:image/webp;base64,$b64"
  }
"@

    # Para que se vea como un array JS válido, solo ponemos coma si NO es el último
    if ($counter -lt $files.Count) {
        $element += ","
    }

    $output += $element
    $counter++
}

# 5. Cerramos el array
$output += "];"

# 6. Finalmente, escribimos todo al archivo images.js en la carpeta actual
$output | Out-File -FilePath .\images.js -Encoding UTF8

# --- FIN DEL SCRIPT PS ---
