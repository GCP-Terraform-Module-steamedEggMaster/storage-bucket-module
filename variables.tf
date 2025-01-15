variable "name" {
  description = "GCS 버킷 이름"
  type        = string
}

variable "location" {
  description = "GCS 버킷 위치"
  type        = string
}

variable "force_destroy" {
  description = "버킷 삭제 시 객체 강제 삭제 여부"
  type        = bool
  default     = false
}

variable "project" {
  description = "GCP 프로젝트 ID"
  type        = string
  default     = null
}

variable "storage_class" {
  description = "GCS 버킷의 스토리지 클래스"
  type        = string
  default     = "STANDARD"
}

variable "labels" {
  description = "GCS 버킷에 추가할 레이블"
  type        = map(string)
  default     = {}
}

variable "encryption" {
  description = "GCS 버킷의 암호화 설정"
  type = object({
    default_kms_key_name = string
  })
  default = null
}

variable "versioning" {
  description = "GCS 버킷 버전 관리 설정"
  type = object({
    enabled = bool
  })
  default = null
}

variable "lifecycle_rules" {
  description = "GCS 버킷 라이프사이클 규칙"
  type = list(
    object({
      action = object({
        type          = string
        storage_class = optional(string)
      })
      condition = object({
        age                        = optional(number)
        created_before             = optional(string)
        matches_storage_class      = optional(list(string))
        with_state                 = optional(string)
        matches_prefix             = optional(list(string))
        matches_suffix             = optional(list(string))
        days_since_noncurrent_time = optional(number)
      })
    })
  )
  default = []
}

variable "cors" {
  description = "GCS 버킷의 CORS 설정"
  type = list(
    object({
      origin          = list(string)
      method          = list(string)
      response_header = list(string)
      max_age_seconds = number
    })
  )
  default = []
}

variable "logging" {
  description = "GCS 버킷 로그 설정"
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string)
  })
  default = null
}

variable "website" {
  description = "GCS 버킷 웹사이트 설정"
  type = object({
    main_page_suffix = optional(string)
    not_found_page   = optional(string)
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

variable "timeout_delete" {
  description = "삭제 타임아웃"
  type        = string
  default     = "4m"
}