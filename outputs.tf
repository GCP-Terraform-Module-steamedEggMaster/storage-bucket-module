output "id" {
  description = "GCS 버킷 ID"
  value       = google_storage_bucket.storage_bucket.id
}

output "url" {
  description = "GCS 버킷 URL"
  value       = google_storage_bucket.storage_bucket.url
}

output "self_link" {
  description = "GCS 버킷의 URI"
  value       = google_storage_bucket.storage_bucket.self_link
}

output "name" {
  description = "GCS 버킷 이름"
  value       = google_storage_bucket.storage_bucket.name
}

output "project" {
  description = "GCS 버킷이 속한 GCP 프로젝트 ID"
  value       = google_storage_bucket.storage_bucket.project
}

output "location" {
  description = "GCS 버킷의 위치"
  value       = google_storage_bucket.storage_bucket.location
}

output "storage_class" {
  description = "GCS 버킷의 스토리지 클래스"
  value       = google_storage_bucket.storage_bucket.storage_class
}

output "lifecycle_rule" {
  description = "GCS 버킷에 적용된 라이프사이클 규칙"
  value       = try(google_storage_bucket.storage_bucket.lifecycle_rule, [])
}

output "versioning_enabled" {
  description = "GCS 버킷 버전 관리 활성화 여부"
  value       = try(google_storage_bucket.storage_bucket.versioning[0].enabled, false)
}

output "logging_config" {
  description = "GCS 버킷의 로그 설정"
  value = {
    log_bucket        = try(google_storage_bucket.storage_bucket.logging[0].log_bucket, null)
    log_object_prefix = try(google_storage_bucket.storage_bucket.logging[0].log_object_prefix, null)
  }
}

output "labels" {
  description = "GCS 버킷에 설정된 레이블"
  value       = google_storage_bucket.storage_bucket.labels
}

output "encryption_key" {
  description = "GCS 버킷의 기본 암호화 KMS 키"
  value       = try(google_storage_bucket.storage_bucket.encryption[0].default_kms_key_name, null)
}

output "retention_policy" {
  description = "GCS 버킷의 데이터 보존 정책"
  value = {
    is_locked        = try(google_storage_bucket.storage_bucket.retention_policy[0].is_locked, false)
    retention_period = try(google_storage_bucket.storage_bucket.retention_policy[0].retention_period, null)
  }
}