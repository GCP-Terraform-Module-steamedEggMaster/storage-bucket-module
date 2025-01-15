resource "google_storage_bucket" "storage_bucket" {
  # 필수 설정
  name     = var.name     # 버킷의 고유 이름 (GCS 내에서 유일해야 하며 영숫자 및 일부 특수 문자만 허용)
  location = var.location # 버킷이 생성될 GCP 리전 또는 멀티-리전 (예: US, ASIA, EUROPE)

  # 선택적 설정
  force_destroy               = var.force_destroy # 버킷 삭제 시 내부 객체도 함께 삭제할지 여부 설정 (기본값: false)
  project                     = var.project       # 버킷이 속한 GCP 프로젝트 ID (지정하지 않으면 기본 프로젝트 사용)
  storage_class               = var.storage_class # 저장소 클래스 (예: STANDARD, NEARLINE, COLDLINE 등, 기본값: STANDARD)
  labels                      = var.labels
  requester_pays              = var.requester_pays
  uniform_bucket_level_access = var.uniform_bucket_level_access # 버킷 전체에 통일된 IAM 정책 적용 여부 설정
  public_access_prevention    = var.public_access_prevention    # 버킷의 공개 접근 방지 수준 ("inherited" 또는 "enforced")

  # AutoClass 설정
  dynamic "autoclass" {
    for_each = var.autoclass != null ? [var.autoclass] : [] # AutoClass 설정이 있는 경우 동적으로 처리
    content {
      enabled                = try(autoclass.value.enabled, false)               # AutoClass 자동 스토리지 클래스 전환 활성화 여부 (기본값: false)
      terminal_storage_class = try(autoclass.value.terminal_storage_class, null) # AutoClass로 전환할 최종 스토리지 클래스 (예: NEARLINE, ARCHIVE)
    }
  }

  # Lifecycle Rule 설정
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule # 정의된 라이프사이클 규칙을 반복 처리
    content {
      action {
        type          = try(lifecycle_rule.value.action.type, null)          # 수행할 작업 유형 ("Delete", "SetStorageClass")
        storage_class = try(lifecycle_rule.value.action.storage_class, null) # 규칙에 따라 객체를 이동할 대상 스토리지 클래스 (예: COLDLINE, ARCHIVE)
      }
      condition {
        age                        = try(lifecycle_rule.value.condition.age, null)                        # 객체가 지정된 일 수 이상된 경우
        created_before             = try(lifecycle_rule.value.condition.created_before, null)             # 지정된 날짜 이전에 생성된 객체
        with_state                 = try(lifecycle_rule.value.condition.with_state, null)                 # 객체 상태 필터 ("LIVE", "ARCHIVED" 등)
        matches_storage_class      = try(lifecycle_rule.value.condition.matches_storage_class, [])        # 특정 스토리지 클래스를 가진 객체만 포함
        matches_prefix             = try(lifecycle_rule.value.condition.matches_prefix, [])               # 특정 접두사로 시작하는 객체만 포함
        matches_suffix             = try(lifecycle_rule.value.condition.matches_suffix, [])               # 특정 접미사로 끝나는 객체만 포함
        num_newer_versions         = try(lifecycle_rule.value.condition.num_newer_versions, null)         # 최신 버전 이후의 객체만 포함
        custom_time_before         = try(lifecycle_rule.value.condition.custom_time_before, null)         # 지정된 커스텀 시간 이전에 생성된 객체
        days_since_custom_time     = try(lifecycle_rule.value.condition.days_since_custom_time, null)     # 커스텀 시간 이후 경과된 일 수
        days_since_noncurrent_time = try(lifecycle_rule.value.condition.days_since_noncurrent_time, null) # 객체 비활성화 이후 경과된 일 수
        noncurrent_time_before     = try(lifecycle_rule.value.condition.noncurrent_time_before, null)     # 비활성 상태로 전환되기 이전에 생성된 객체
      }
    }
  }

  # 버전 관리 설정
  dynamic "versioning" {
    for_each = var.versioning != null ? [var.versioning] : [] # 버전 관리 설정이 있는 경우 동적으로 처리
    content {
      enabled = try(versioning.value.enabled, false) # 버킷의 버전 관리 활성화 여부 (기본값: false)
    }
  }

  # Website 설정
  dynamic "website" {
    for_each = var.website != null ? [var.website] : [] # 웹사이트 설정이 있는 경우 동적으로 처리
    content {
      main_page_suffix = try(website.value.main_page_suffix, null) # 웹사이트의 메인 페이지 파일 이름 (예: index.html)
      not_found_page   = try(website.value.not_found_page, null)   # 리소스가 없는 경우 반환할 404 페이지 파일 이름
    }
  }

  # CORS 설정
  dynamic "cors" {
    for_each = var.cors # 정의된 CORS 규칙을 반복 처리
    content {
      origin          = try(cors.value.origin, [])            # 허용할 HTTP 요청 출처 목록 (예: "https://example.com")
      method          = try(cors.value.method, [])            # 허용할 HTTP 요청 메서드 목록 (예: GET, POST, DELETE)
      response_header = try(cors.value.response_header, [])   # 허용할 응답 헤더 목록
      max_age_seconds = try(cors.value.max_age_seconds, null) # CORS 요청의 캐싱 유효 기간 (초 단위)
    }
  }

  # Retention Policy 설정
  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? [var.retention_policy] : [] # 보존 정책 설정이 있는 경우 동적으로 처리
    content {
      is_locked        = try(retention_policy.value.is_locked, false)       # 정책 잠금 여부 설정 (잠금 시 변경 불가, 기본값: false)
      retention_period = try(retention_policy.value.retention_period, null) # 객체가 보존되어야 하는 최소 기간 (초 단위)
    }
  }

  # Logging 설정
  dynamic "logging" {
    for_each = var.logging != null ? [var.logging] : [] # 액세스 로그 설정이 있는 경우 동적으로 처리
    content {
      log_bucket        = try(logging.value.log_bucket, null)        # 로그를 저장할 GCS 버킷 이름
      log_object_prefix = try(logging.value.log_object_prefix, null) # 로그 객체의 이름 접두사 (Optional)
    }
  }

  # Encryption 설정
  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : [] # 암호화 설정이 있는 경우 동적으로 처리
    content {
      default_kms_key_name = try(encryption.value.default_kms_key_name, null) # 기본 KMS 키 이름 (예: projects/my-project/locations/global/keyRings/my-keyring/cryptoKeys/my-key)
    }
  }

  timeouts {
    create = var.timeout_create # 리소스 생성 시간 제한 (기본값: 4분)
    update = var.timeout_update # 리소스 업데이트 시간 제한 (기본값: 4분)
    read   = var.timeout_read   # 리소스 읽기 시간 제한 (기본값: 4분)
  }
}