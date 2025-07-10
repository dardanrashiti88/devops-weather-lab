terraform {
  required_version = ">= 1.0"
  
  cloud {
    organization = "LAB-2-terraform"
    workspaces {
      name = "lab-project-workspace"
    }
  }
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "example" {
  content  = "This is a sample file created by Terraform Cloud"
  filename = "${path.module}/example.txt"
}

output "file_content" {
  value = local_file.example.content
}

output "file_path" {
  value = local_file.example.filename
} 