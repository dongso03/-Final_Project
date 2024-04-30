# 프로젝트명
 LetEatGo

## 프로젝트 제작 과정 및 핵심

현대 사회에 필수적인 ‘식사’와 ‘인간 관계’에 초점을 맞춰 프로젝트를 개발합니다. 새로운 인연을 만들고 밥메이트를 찾을 수 있는 서비스에 중점을 둡니다.

### 프로그램 주요 기능
![1](https://github.com/dongso03/-Final_Project/assets/154950237/412608bd-d0d1-4b55-a5af-57712d24993a)

1. **주변 음식점 찾기 및 모임 만들기**
2. **주변 사람 찾기 및 친구 추가**

### 담당 업무

1. **외부 Open API 활용**
    ![3](https://github.com/dongso03/-Final_Project/assets/154950237/693bea23-c113-4a72-a8f5-012dbbc2f6ba)
   - Kakao Map, Kakao 블로그 검색 API 사용
     1. 주변 음식점 찾기 기능
     2. 주변 친구 찾기 기능 (사용자 간 거리 출력)
    




2. **유저들의 정보 목록 및 친구 추가 기능 (CRUD)**
   ![4](https://github.com/dongso03/-Final_Project/assets/154950237/951dea3f-14a7-4a29-9ac1-353c9a67cefb)

    - MVC 패턴 적용
     1. Servlet Class 작성하여 Servlet에서는 제어 로직 처리만을 수행할 수 있는 환경 제공
     2. 게시판 작성폼 및 게시판 출력 등 View 구현
     3. 유저 간 친구 추가 및 친구 목록 등 서비스 로직 구현 / 테이블 관계 정의


### 이슈 사항

1. 지도 검색결과에서 음식점 외 다른 정보를 제외하고자, 검색 키워드를 가공
  구현 : prefix(사용자 주소) + 사용자가 입력한 키워드 + surfix(음식점 키워드) 로 검색
  발생한 이슈 : 값이 상세해 질수록 검색 정보량이 적어짐
  해결방법 : 일정량의 정보를 찾지 못한 경우 prefix와 surfix의 값을 동적으로 넓은 지역으로 확대 조절, 음식점 키워드를 변경하는 로직 추가

2. Package 네이밍 규칙, Servlet 구현시 url 패턴등 조원들과 통일이 되지 않아 코드 작성시 혼란 발생
 해결 방법: Package 네이밍은 Flat Case로 작성, 변수명은 Camel Case로 작성, url 패턴은 페이지 서비스 내용의 이름으로 알아보기 쉽게 작성

3. 프로젝트 시작 전 CRUD 작업에 필요한 코드를 작성할 때, 코드가 길어지고 시간소모가 심해질 것을 고려하여 라이브러리 선택
 해결 방법: MyBatis와 JPA를 비교하고 MyBatis를 선택. JPA가 MyBatis 보다 생산성을 더 높일수 있지만 MyBatis 또한 경량화된 라이브러리이기에 생산성을 높일 수 있다고 판단, 추가로 성능적 문제와 매핑 작업을 직접하여 세밀한 조정이 가능한 점을 고려하여 선택

4. 프로젝트 제작 중 상용구, Boilerplate 코드가 다수 발생함
  해결방법: CORS 설정, Json body 파싱/직렬화 동작, status code별 에러 처리 메소드 등을 util package 구성해서 보관
  느낀점 : AOP(관점 지향적 프로그래밍)의 필요성을 느낌

5. DB연결 설정 할 때 DBCP 라이브러리의 BasicDataSource 사용
  이유 : BasicDataSource 는 connection pool을 구현하고 있고 이를 통해 DB 연결 객체를 효율적으로 재사용하기에 용이함

6. 지도와 연계하여 비동기(fetch) 방식으로 카카오 블로그 검색 API 사용
 발생한 이슈 : 검색API의 문서 수 파라미터 입력값을 기본값으로 사용하여, 필요 이상의 정보가 검색되며, 성능 하락
 해결방법 : API Document를 읽으며 정보량 제한을 위한 설정 파라미터를 탐색하였고, 입력값을 설정하여 페이지 구성에 필요한 만큼만을 검색할 수 있었음
 교훈 : 외부 API의 사용 시, 예제와 함께 문서를 필독하여 요청 시 필수/옵션 파라미터의 구성과 응답 필드 구성 등을 살펴볼 필요를 느낌

7. kakao Map API 내 주소 값 좌표 변환 함수를 사용하여 사용자 간 거리 출력
 발생한 이슈 : 거리 값을 텍스트 형태로만 서비스 제공하여, 편의성 하락
 해결방법 : 지도형태로 주변 사용자들의 위치를 마커로 나타내고, 거리 값으로 정렬된 목록제공 등으로 편의성 향상
