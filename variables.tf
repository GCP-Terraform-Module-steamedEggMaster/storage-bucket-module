# 버킷 이름
variable "name" {
  description = "GCS 버킷의 고유 이름 (영숫자 및 일부 특수 문자 허용, 유일해야 함)"
  type        = string
}

# 버킷 생성 위치
variable "location" {
  description = "버킷이 생성될 GCP 리전 또는 멀티-리전 (예: US, ASIA, EUROPE)"
  type        = string
}

# 버킷 삭제 시 내부 객체 포함 여부
variable "force_destroy" {
  description = "버킷 삭제 시 내부 객체도 함께 삭제할지 여부 (기본값: false)"
  type        = bool
  default     = false
}

# GCP 프로젝트 ID
variable "project" {
  description = "버킷이 속한 GCP 프로젝트 ID (지정하지 않으면 provider 기본값 사용)"
  type        = string
  default     = null
}

# 스토리지 클래스
variable "storage_class" {
  description = "버킷의 스토리지 클래스 (예: STANDARD, NEARLINE, COLDLINE 등)"
  type        = string
  default     = "STANDARD"
}

# 사용자 정의 레이블
variable "labels" {
  description = "버킷에 추가할 사용자 정의 메타데이터 레이블 (key-value 맵)"
  type        = map(string)
  default     = {}
}

# Requester Pays 활성화 여부
variable "requester_pays" {
  description = "요청자가 비용을 지불하도록 설정할지 여부 (기본값: false)"
  type        = bool
  default     = false
}

# 버킷 레벨 액세스 제어 활성화 여부
variable "uniform_bucket_level_access" {
  description = "IAM 기반의 일관된 액세스 제어를 활성화할지 여부"
  type        = bool
  default     = false
}

# 공개 접근 방지 설정
variable "public_access_prevention" {
  description = "공개 접근 방지 수준 설정 ('inherited' 또는 'enforced')"
  type        = string
  default     = "inherited"
}

# AutoClass 설정
variable "autoclass" {
  description = "AutoClass 자동 스토리지 전환 설정 (활성화 여부 및 최종 클래스 지정)"
  type = object({
    enabled                = optional(bool, false)
    terminal_storage_class = optional(string, null)
  })
  default = null
}

# 라이프사이클 규칙
variable "lifecycle_rule" {
  description = "버킷의 라이프사이클 규칙 목록 (객체 조건에 따라 작업 수행)"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string, null)
    })
    condition = object({
      age                        = optional(number, null)
      created_before             = optional(string, null)
      with_state                 = optional(string, null)
      matches_storage_class      = optional(list(string), [])
      matches_prefix             = optional(list(string), [])
      matches_suffix             = optional(list(string), [])
      num_newer_versions         = optional(number, null)
      custom_time_before         = optional(string, null)
      days_since_custom_time     = optional(number, null)
      days_since_noncurrent_time = optional(number, null)
      noncurrent_time_before     = optional(string, null)
    })
  }))
  default = []
}

# 버전 관리 설정
variable "versioning" {
  description = "버킷 버전 관리 활성화 여부 설정 (예: 이전 객체 복구 가능)"
  type = object({
    enabled = optional(bool, false)
  })
  default = null
}

# 웹사이트 설정
variable "website" {
  description = "버킷을 웹사이트로 구성하기 위한 설정 (메인 페이지 및 404 페이지 지정)"
  type = object({
    main_page_suffix = optional(string, null)
    not_found_page   = optional(string, null)
  })
  default = null
}

# CORS 설정
variable "cors" {
  description = "Cross-Origin Resource Sharing 규칙 설정 (허용된 요청 출처, 메서드 등)"
  type = list(object({
    origin          = list(string)
    method          = list(string)
    response_header = list(string)
    max_age_seconds = optional(number, null)
  }))
  default = []
}

# Retention Policy 설정
variable "retention_policy" {
  description = "버킷 객체 보존 정책 설정 (최소 보존 기간 및 잠금 여부)"
  type = object({
    is_locked        = optional(bool, false)
    retention_period = optional(number, null)
  })
  default = null
}

# 로깅 설정
variable "logging" {
  description = "버킷 액세스 로그를 저장할 버킷과 객체 접두사 설정"
  type = object({
    log_bucket        = string
    log_object_prefix = optional(string, null)
  })
  default = null
}

# 암호화 설정
variable "encryption" {
  description = "버킷의 기본 데이터 암호화를 위한 KMS 키 설정"
  type = object({
    default_kms_key_name = optional(string, null)
  })
  default = null
}

# 타임아웃 설정
variable "timeout_create" {
  description = "리소스 생성 작업의 시간 제한 (기본값: 4분)"
  type        = string
  default     = "4m"
}

variable "timeout_update" {
  description = "리소스 업데이트 작업의 시간 제한 (기본값: 4분)"
  type        = string
  default     = "4m"
}

variable "timeout_read" {
  description = "리소스 읽기 작업의 시간 제한 (기본값: 4분)"
  type        = string
  default     = "4m"
}