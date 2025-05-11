# PowerShell script to create and set up .env file

# Check if .env file exists
if (-not (Test-Path .env)) {
    Write-Host "Creating .env file..."
    
    # Create .env file with content
    @"
MONGO_URI=mongodb://localhost:27017/customsdb
PORT=5000
CUSTOMS_API_KEY=your-customs-api-key
EMAIL_SERVICE=gmail
EMAIL_USER=your-email@gmail.com
EMAIL_PASSWORD=your-app-password
"@ | Out-File -FilePath .env -Encoding utf8
    
    Write-Host ".env file created successfully!"
    Write-Host "Please edit the .env file to update the placeholder values with your actual values."
} else {
    Write-Host ".env file already exists."
}

# Check for Node.js dependencies
Write-Host "Checking Node.js dependencies..."
if (-not (Test-Path node_modules/speakeasy) -or -not (Test-Path node_modules/qrcode) -or -not (Test-Path node_modules/nodemailer)) {
    Write-Host "Installing required dependencies: speakeasy, qrcode, nodemailer..."
    npm install speakeasy qrcode nodemailer
} else {
    Write-Host "Required dependencies already installed."
}

Write-Host "Setup complete! You can now run the server with: node mserver.js" 