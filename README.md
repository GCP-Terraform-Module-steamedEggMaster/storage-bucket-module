# storage-bucket-module
GCP Terraform Storage Bucket Module Repo

GCP에서 Google Cloud Storage 버킷을 생성하고 관리하기 위한 Terraform 모듈입니다. <br>
이 모듈은 GCS 버킷의 라이프사이클, 암호화, 로깅, 버전 관리 등 다양한 설정을 손쉽게 구성하도록 설계되었습니다

<br>

## 📑 **목차**
1. [모듈 특징](#모듈-특징)
2. [사용 방법](#사용-방법)
    1. [사전 준비](#1-사전-준비)
    2. [입력 변수](#2-입력-변수)
    3. [모듈 호출 예시](#3-모듈-호출-예시)
    4. [출력값 (Outputs)](#4-출력값-outputs)
    5. [지원 버전](#5-지원-버전)
    6. [모듈 개발 및 관리](#6-모듈-개발-및-관리)
3. [테스트](#terratest를-이용한-테스트)
4. [주요 버전 관리](#주요-버전-관리)
5. [기여](#기여-contributing)
6. [라이선스](#라이선스-license)

---

## 모듈 특징

- GCS 버킷의 다양한 설정을 제공 (라이프사이클, 암호화, 로깅, 버전 관리 등).
- 조건부 라이프사이클 규칙 및 CORS 규칙 지원.
- IAM 기반 통합 버킷 액세스 관리 가능.
- AutoClass 및 보존 정책 지원.
- 생성된 GCS 버킷의 주요 속성 출력.

---

## 사용 방법

### 1. 사전 준비

다음 사항을 확인하세요:
1. Google Cloud 프로젝트 준비.
2. 적절한 IAM 권한 필요: `roles/storage.admin`.

### 2. 입력 변수

| 변수명                            | 타입        | 필수 여부 | 기본값        | 설명                                                                 |
|-----------------------------------|-------------|-----------|---------------|----------------------------------------------------------------------|
| `name`                            | string      | ✅        | 없음          | GCS 버킷의 고유 이름                                                 |
| `location`                        | string      | ✅        | 없음          | GCS 버킷이 생성될 GCP 리전 또는 멀티-리전                             |
| `force_destroy`                   | bool        | ❌        | `false`       | 버킷 삭제 시 내부 객체도 함께 삭제할지 여부                          |
| `project`                         | string      | ❌        | `null`        | GCP 프로젝트 ID (지정하지 않으면 provider 기본값 사용)                |
| `storage_class`                   | string      | ❌        | `STANDARD`    | GCS 스토리지 클래스                                                  |
| `labels`                          | map(string) | ❌        | `{}`          | 사용자 정의 메타데이터 레이블                                         |
| `requester_pays`                  | bool        | ❌        | `false`       | 요청자가 비용을 지불하도록 설정할지 여부                              |
| `uniform_bucket_level_access`     | bool        | ❌        | `false`       | IAM 기반의 일관된 액세스 제어 활성화 여부                             |
| `public_access_prevention`        | string      | ❌        | `"inherited"` | 공개 접근 방지 수준 설정                                             |
| `autoclass`                       | object      | ❌        | `null`        | AutoClass 설정                                                      |
| `lifecycle_rule`                  | list(object) | ❌        | `[]`          | 라이프사이클 규칙 목록                                               |
| `versioning`                      | object      | ❌        | `null`        | 버전 관리 활성화 여부                                                |
| `website`                         | object      | ❌        | `null`        | 웹사이트 설정                                                        |
| `cors`                            | list(object) | ❌        | `[]`          | CORS 규칙 설정                                                       |
| `retention_policy`                | object      | ❌        | `null`        | 객체 보존 정책 설정                                                  |
| `logging`                         | object      | ❌        | `null`        | 액세스 로그 설정                                                     |
| `encryption`                      | object      | ❌        | `null`        | 기본 KMS 키를 사용한 암호화 설정                                      |
| `timeout_create`                  | string      | ❌        | `"4m"`        | 리소스 생성 시간 제한                                                |
| `timeout_update`                  | string      | ❌        | `"4m"`        | 리소스 업데이트 시간 제한                                            |
| `timeout_read`                    | string      | ❌        | `"4m"`        | 리소스 읽기 시간 제한                                                |

<br>

### 3. 모듈 호출 예시

```hcl
module "project_iam_member" {
  source   = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/storage-bucket-module.git?ref=v1.0.0"

  name                    = "my-unique-bucket-name"
  location                = "US"
  force_destroy           = true
  storage_class           = "NEARLINE"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  lifecycle_rule = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "COLDLINE"
      }
      condition = {
        age                   = 30
        matches_storage_class = ["NEARLINE"]
      }
    }
  ]
}
```

<br>

### 4. 출력값 (Outputs)

| 출력명               | 설명                                      |
|----------------------|-------------------------------------------|
| `id`                | GCS 버킷 ID                              |
| `url`               | GCS 버킷 URL                             |
| `self_link`         | GCS 버킷의 URI                           |
| `name`              | GCS 버킷 이름                            |
| `project`           | GCS 버킷이 속한 GCP 프로젝트 ID          |
| `location`          | GCS 버킷의 위치                          |
| `storage_class`     | GCS 버킷의 스토리지 클래스               |
| `lifecycle_rule`    | GCS 버킷에 적용된 라이프사이클 규칙       |
| `versioning_enabled`| GCS 버킷 버전 관리 활성화 여부            |
| `logging_config`    | GCS 버킷의 로그 설정                     |
| `labels`            | GCS 버킷에 설정된 레이블                 |
| `encryption_key`    | GCS 버킷의 기본 암호화 KMS 키             |
| `retention_policy`  | GCS 버킷의 데이터 보존 정책              |

<br>

### 5. 지원 버전

#### a.  Terraform 버전
| 버전 범위 | 설명                              |
|-----------|-----------------------------------|
| `1.10.3`   | 최신 버전, 지원 및 테스트 완료                  |

#### b. Google Provider 버전
| 버전 범위 | 설명                              |
|-----------|-----------------------------------|
| `~> 6.0`  | 최소 지원 버전                   |

<br>

### 6. 모듈 개발 및 관리

- **저장소 구조**:
  ```
  storage-bucket-module/
  ├── .github/workflows/  # github actions 자동화 테스트
  ├── examples/           # 테스트를 위한 루트 모듈 모음 디렉터리
  ├── test/               # 테스트 구성 디렉터리
  ├── main.tf             # 모듈의 핵심 구현
  ├── variables.tf        # 입력 변수 정의
  ├── outputs.tf          # 출력 정의
  ├── versions.tf         # 버전 정의
  ├── README.md           # 문서화 파일
  ```
<br>

---

## Terratest를 이용한 테스트
이 모듈을 테스트하려면 제공된 Go 기반 테스트 프레임워크를 사용하세요. 아래를 확인하세요:

1. Terraform 및 Go 설치.
2. 필요한 환경 변수 설정 (GCP_PROJECT_ID, API_SERVICES 등).
3. 테스트 실행:
```bash
go test -v ./test
```

<br>

## 주요 버전 관리
이 모듈은 [Semantic Versioning](https://semver.org/)을 따릅니다.  
안정된 버전을 사용하려면 `?ref=<version>`을 활용하세요:

```hcl
source = "git::https://github.com/GCP-Terraform-Module-steamedEggMaster/storage-bucket-module.git?ref=v1.0.0"
```

### Module ref 버전
| Major | Minor | Patch |
|-----------|-----------|----------|
| `1.0.0`   |    |   |


<br>

## 기여 (Contributing)
기여를 환영합니다! 버그 제보 및 기능 요청은 GitHub Issues를 통해 제출해주세요.

<br>

## 라이선스 (License)
[MIT License](LICENSE)