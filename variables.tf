variable "name" {
  description = "버킷 이름"
  type        = string
}

variable "location" {
  description = "버킷 위치"
  type        = string
}

variable "force_destroy" {
  description = "버킷 삭제 시 객체 포함 여부"
  type        = bool
  default     = false
}

variable "project" {
  description = "프로젝트 ID"
  type        = string
  default     = null
}

variable "storage_class" {
  description = "스토리지 클래스는 데이터를 저장하는 방식과 비용 모델을 결정하며, STANDARD, NEARLINE, COLDLINE, ARCHIVE 옵션이 있습니다 (기본값: STANDARD)."
  type        = string
  default     = "STANDARD"
}

variable "uniform_bucket_level_access" {
  description = "버킷 레벨 액세스 활성화 여부"
  type        = bool
  default     = false
}

variable "public_access_prevention" {
  description = "공개 액세스 방지 설정"
  type        = string
  default     = "inherited"
}

variable "autoclass" {
  description = "Autoclass 설정"
  type = object({
    enabled                = bool
    terminal_storage_class = optional(string)
  })
  default = null
}

variable "lifecycle_rule" {
  description = "Lifecycle Rule 설정"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                        = optional(number)
      created_before             = optional(string)
      with_state                 = optional(string)
      matches_storage_class      = optional(list(string))
      matches_prefix             = optional(list(string))
      matches_suffix             = optional(list(string))
      num_newer_versions         = optional(number)
      custom_time_before         = optional(string)
      days_since_custom_time     = optional(number)
      days_since_noncurrent_time = optional(number)
      noncurrent_time_before     = optional(string)
    })
  }))
  default = []
}

variable "versioning" {
  description = "버전 관리 설정"
  type = object({
    enabled = bool
  })
  default = null
}

variable "website" {
  description = "Website 설정"
  type = object({
    main_page_suffix = optional(string)
    not_found_page   = optional(string)
  })
  default = null
}

variable "cors" {
  description = "CORS 설정"
  type = list(object({
    origin          = list(string)
    method          = list(string)
    response_header = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "retention_policy" {
  description = "Retention Policy 설정"
  type = object({
    is_locked        = optional(bool)
    retention_period = number
  })
  default = null
}

variable "logging" {
  description = "Logging 설정"
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string)
  })
  default = null
}

variable "encryption" {
  description = "Encryption 설정"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "timeout_create" {
  description = "생성 타임아웃"
  type        = string
  default     = "4m"
}

variable "timeout_update" {
  description = "업데이트 타임아웃"
  type        = string
  default     = "4m"
}

variable "timeout_read" {
  description = "리소스 읽기 타임아웃"
  type        = string
  default     = "4m"
}