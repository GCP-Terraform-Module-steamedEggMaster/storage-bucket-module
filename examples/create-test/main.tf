module "bucket" {
  source = "../../"

  # 필수 변수
  name          = "test-bucket"     # GCS 버킷 이름
  location      = "ASIA-NORTHEAST3" # 버킷 생성 위치 (서울 리전)
  storage_class = "STANDARD"        # 스토리지 클래스 (예: STANDARD, NEARLINE 등)

  # 선택 변수
  force_destroy = true             # 삭제 시 버킷 내 객체도 함께 삭제 여부
  labels = {                       # 사용자 정의 메타데이터 레이블
    environment = "test"           # 환경 레이블 (개발 환경)
    team        = "infrastructure" # 팀 레이블 (인프라 팀)
  }
  versioning = {   # 객체 버전 관리 설정
    enabled = true # 버전 관리 활성화 여부
  }
  # logging = {                                # 접근 및 스토리지 로그 설정
  #   log_bucket        = "example-log-bucket" # 로그를 저장할 버킷 이름
  #                                            # 미리 만들어져 있어야 함
  #   log_object_prefix = "logs/"              # 로그 객체의 접두사
  # }
}