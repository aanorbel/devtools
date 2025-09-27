# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 7.3.0"
    }
  }
}

provider "google" {
  project = var.project
  zone    = var.zone
}

# Define the Windows virtual workstation
resource "google_compute_instance" "windows_workstation" {
  name         = "win-workstation-tf"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.windows_image
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  # Allow network access (RDP, etc.)
  network_interface {
    network = "default"
    access_config {}
  }

  # Startup script to install Chocolatey and software
  metadata = {
    windows-startup-script-ps1 = <<-EOT
      # Install Chocolatey
      Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

      # Use Chocolatey to install your applications
      # Add or remove packages from the list below
      choco install -y llvm make vscode 7zip git librewolf androidstudio

      choco install -y correttojdk --version=17.0.2

    EOT

    serial-port-enable = true
  }

  tags = ["windows-workstation"]
}
