output "bucket_details" {
  description = "생성된 GCS 버킷의 세부 정보"
  value = {
    id               = module.bucket.id
    name             = module.bucket.name
    url              = module.bucket.url
    self_link        = module.bucket.self_link
    location         = module.bucket.location
    storage_class    = module.bucket.storage_class
    versioning       = module.bucket.versioning_enabled
    logging          = module.bucket.logging_config
    labels           = module.bucket.labels
    encryption_key   = module.bucket.encryption_key
    retention_policy = module.bucket.retention_policy
  }
}