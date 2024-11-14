resource "google_bigquery_dataset" "dataset" {
  dataset_id = "sales"
  description = "holds sales data"
  location = var.region
  delete_contents_on_destroy = true

  labels = {
    env = "default"
  }
}



#not creating a table as function will create one upon execution