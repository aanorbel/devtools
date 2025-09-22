# Google Cloud Windows Workstation

This guide explains how to set up a Windows workstation in Google Cloud using Terraform.

## Prerequisites

### Install Google Cloud SDK (gcloud)

#### macOS

1. Using Homebrew:
   ```bash
   brew install --cask google-cloud-sdk
   ```

2. Or, download the installer:
   ```bash
   curl https://sdk.cloud.google.com | bash
   ```
   
3. Restart your shell:
   ```bash
   exec -l $SHELL
   ```

#### Windows

1. Download the installer from: https://cloud.google.com/sdk/docs/install

2. Run the installer and follow the prompts

#### Linux

1. Add the Cloud SDK distribution URI as a package source:
   ```bash
   echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
   ```

2. Import the Google Cloud public key:
   ```bash
   curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
   ```

3. Update and install the SDK:
   ```bash
   sudo apt-get update && sudo apt-get install google-cloud-sdk
   ```

### Install Terraform

#### macOS

```bash
brew install terraform
```

#### Windows

```bash
choco install terraform
```

#### Linux

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

## Set Up Google Cloud

### Initialize Google Cloud SDK

```bash
gcloud init
gcloud auth application-default login
```

Follow the prompts to:
- Log in to your Google account
- Select or create a project
- Configure default compute region and zone

## Deploy Windows Workstation

### 1. Configure Terraform Variables

1. Copy the example variables file:
   ```bash
   cd gcloud
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` to customize your configuration:
   ```bash
   nano terraform.tfvars
   ```
   
   Update these values:
   - `project`: Your GCP project ID
   - `zone`: The GCP zone to deploy in (e.g., "us-central1-a")
   - Any other customizations you need

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Apply the Terraform Configuration

```bash
terraform plan

terraform apply
```

Review the changes and type `yes` to confirm.

### 4. Connect to Your Windows Workstation

1. In the Google Cloud Console, go to Compute Engine > VM instances
2. Find your `win-workstation-tf` instance
3. Click the "RDP" button to download an RDP file
4. Open the RDP file with Remote Desktop Connection

Or use gcloud:

```bash
gcloud compute reset-windows-password win-workstation-tf --zone=[YOUR_ZONE] --user=[USERNAME]
```

This will provide a password you can use to connect via RDP.

## Customizing Your Windows Workstation

### Modify the Machine Type

Edit `terraform.tfvars` to change the machine type:

```
machine_type = "n2-standard-8"
```

### Increase Disk Size

Edit `terraform.tfvars` to change the disk size:

```
disk_size_gb = 200
```

### Change Windows Version

Edit `terraform.tfvars` to use a different Windows image:

```
windows_image = "projects/windows-cloud/global/images/family/windows-2022-core"
```

To see available Windows images:

```bash
gcloud compute images list --filter="family~'windows'" --project=windows-cloud
```

### Add Software to Installation

Edit `windows.tf` and modify the `windows-startup-script-ps1` section to install additional software:

```
choco install -y llvm make vscode 7zip git librewolf firefox chrome
```

## Cleaning Up

To delete the Windows workstation and all associated resources:

```bash
terraform destroy
```

Review the changes and type `yes` to confirm.

## Troubleshooting

### RDP Connection Issues

1. Make sure your firewall allows RDP traffic (port 3389)
2. Verify the VM is running
3. Reset the Windows password:
   ```bash
   gcloud compute reset-windows-password win-workstation-tf --zone=[YOUR_ZONE] --user=[USERNAME]
   ```

### Windows Not Fully Initialized

It may take 5-10 minutes after the VM shows as running for Windows to complete initialization. If you connect too early, you may see a black screen or Windows setup.

### Checking Startup Script Logs

To view the startup script logs:

1. Connect to the VM using RDP
2. Open PowerShell as Administrator
3. Run:
   ```powershell
   Get-Content C:\Windows\debug\startup-script.log
   ```