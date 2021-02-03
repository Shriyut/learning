provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "cloudglobaldelivery-1000135575"
  region      = "us-central1"
}

resource "google_spanner_instance" "main" {
    config = "regional-us-central1"
    display_name = "Sample Spanner instance"
    num_nodes = 2
    labels = {
        "test" = "instance"
    }
}

resource "google_spanner_database" "database" {
    instance = google_spanner_instance.main.name
    name = "sample-spanner-database"
    ddl = [
        "CREATE TABLE t1 (t1 INT64  NOT NULL,) PRIMARY KEY(t1)",
        "CREATE TABLE t2 (t2 INT64  NOT NULL,) PRIMARY KEY(t2)",
    ]
}

resource "google_pubsub_topic" "sample" {
    name = "sample-topic"

    message_storage_policy {
        allowed_persistence_regions = [
            "us-central1",
        ]
    }
}

resource "google_pubsub_subscription" "sample" {
    name = "sample-subscription"
    topic = google_pubsub_topic.sample.name

    labels = {
        foo = "bar"
    }

    message_retention_duration = "1200s"
    retain_acked_messages = true

    ack_deadline_seconds = 20

    expiration_policy {
        ttl = "300000.5s"
    }
}

resource "google_bigquery_dataset" "default" {
    dataset_id = "setupdataset"
    friendly_name = "testdataset"
    description = "Created via Terraform"
    location = "US"
    default_table_expiration_ms = "3600000"

    labels = {
        env = "default"
    }
}

resource "google_bigquery_table" "default" {
    dataset_id = google_bigquery_dataset.default.dataset_id
    table_id = "sampletable"

    labels = {
        env = "default"
    }

    schema = <<EOF
    [
        {
            "name": "data",
            "type": "STRING",
            "mode": "NULLABLE"
        }
    ]
    EOF
}

resource "google_cloud_scheduler_job" "job" {
    name = "testjob"
    description = "test job"
    schedule = "* * * * *"
    region = "asia-south1"
    pubsub_target {
        topic_name = google_pubsub_topic.sample.id
        data = "${base64encode("test")}"
    }
}

resource "google_storage_bucket" "image" {
    name = "samplebucket1234576890"
    location = "US"
}

resource "google_dataflow_job" "big_data_job" {
    name = "sampledataflowa"
    zone = "us-central1-c"
    max_workers = 3
    on_delete = "drain"
    template_gcs_path = "gs://dataflow-templates/latest/PubSub_to_BigQuery"
    temp_gcs_location = "gs://samplebucket1234576890/tmp/"
    parameters = {
        inputTopic : google_pubsub_topic.sample.id
        outputTableSpec : "cloudglobaldelivery-1000135575:setupdataset.setuptable"
    }

    machine_type = "n1-standard-1"
    network = "a-a-sample-vpc"
    subnetwork = "regions/us-central1/subnetworks/sample-us-central1"

    depends_on = ["google_storage_bucket.image"]
}
