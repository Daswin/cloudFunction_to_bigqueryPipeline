terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "5.18.0"
    }
  }
}

provider "google"{
    project = var.project
    region = var.region
    zone = var.zone
}

#create bucket
resource "google_storage_bucket" "bucket" {
  name = var.bucket
  location =  var.region
  force_destroy = true
  storage_class = "STANDARD"
}

#create bucket
resource "google_storage_bucket" "data_bucket" {
  name = var.bucket2
  location =  var.region
  force_destroy = true
  storage_class = "STANDARD"
}


#zip function to prepare
data "archive_file" "function" {
  type = "zip"
  output_path = "cloud-function.zip"
  source_dir = "../cloud-function-code/"
}

#add to bucket
resource "google_storage_bucket_object" "zipFunction" {
  name = "cloud-function.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.function.output_path
}

#cloud function creation
resource "google_cloudfunctions2_function" "function" {
  name = "dataupload"
  location = var.region
  description = "loads data into BQ table"
  
  build_config {
    runtime = "python39"
    entry_point = "loadData"

    source {
        storage_source {
            bucket = google_storage_bucket.bucket.name
            object = google_storage_bucket_object.zipFunction.name
        }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory = "256M"
    timeout_seconds = 60
  }

  event_trigger {
    event_type = "google.cloud.storage.object.v1.finalized"
    service_account_email = var.service_account
    #leaving service account blank to auto pick compute

    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.data_bucket.name
    }
  }


}