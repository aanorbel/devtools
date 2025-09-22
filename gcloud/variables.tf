variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy resources in"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the Windows workstation"
  type        = string
  default     = "n2-standard-4"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-ssd"
}

variable "windows_image" {
  description = "Windows image to use for the boot disk"
  type        = string
  default     = "projects/windows-cloud/global/images/family/windows-2022"
}

