# 💬 프로젝트 소개

<img src="https://user-images.githubusercontent.com/77015330/204082594-357cce14-0df3-450a-ab7d-0ad4dce34c26.png" width="300">

> **타임캡슐에서 공간적 제약을 강조하면 어떨까?** 라는 아이디어에서 착안했습니다.
>
> 사용자는 사진, 글 등의 추억을 **캡슐**에 담아 특정 장소에 묻어둘 수 있습니다.
>
> 이후 사용자가 해당 장소를 방문할 때에만 해당 **캡슐**을 열어볼 수 있습니다.

# 👨‍👨‍👧‍👦 팀원 소개


|S004 김민중|S019 박영준|S049 장재훈|S060 홍지수|
|---|---|---|---|
|<a href="https://github.com/solbat"><img src="https://avatars.githubusercontent.com/u/77015330?v=4" width="200"></a>|<a href="https://github.com/pyj9748"><img src="https://avatars.githubusercontent.com/u/65703011?v=4" width="200"></a>|<a href="https://github.com/trumanfromkorea"><img src="https://avatars.githubusercontent.com/u/55919701?v=4" width="200"></a>|<a href="https://github.com/hongpower"><img src="https://avatars.githubusercontent.com/u/96896873?v=4" width="200"></a>|

# 📲 주요 기능


## User Flow

<img src="https://user-images.githubusercontent.com/55919701/205919850-eeca782e-68f3-475a-8cd0-66a59c784d44.png">

## 애플 로그인


## 캡슐 추가

<img src="https://user-images.githubusercontent.com/55919701/205920762-deb3b5f4-fe43-4e0b-9db6-5d932a56d7f9.PNG" width="300">

- 사용자의 추억이 담긴 캡슐을 추가할 수 있습니다.
- 이미지, 이름, 위치, 날짜, 내용으로 이루어진 정보를 추가할 수 있습니다.
    - PHPickerViewController 를 이용해 이미지 추가 기능을 구현했습니다.
    - 지도를 움직여 중심부에 위치한 어노테이션으로 원하는 위치를 선택할 수 있도록 구현했습니다.
    - DatePicker 를 이용해 날짜를 선택할 수 있도록 구현했습니다.

## 캡슐 지도

<img src="https://user-images.githubusercontent.com/55919701/205920812-da84f7e6-5896-44a1-8e41-7b25040fb2f0.PNG" width="300">

- 묻어둔 캡슐들을 지도 위에서 확인할 수 있습니다.
- 사용자 위치 반경 100m 이내의 캡슐은 개봉이 가능합니다.
- 개봉 가능한 캡슐은 초록색, 불가능한 캡슐은 회색으로 표시하였습니다.
- 사용자가 이동할 때마다 캡슐 가능 여부는 실시간으로 화면에 업데이트 됩니다.

## 캡슐 목록

<img src="https://user-images.githubusercontent.com/55919701/205920849-7a77d520-5b05-4881-83ca-683562f7f94e.PNG" width="300">

- 캡슐들을 목록 형태로 확인할 수 있습니다.
- 가까운 순, 멀리있는 순, 최신 순, 오래된 순의 정렬 방식을 제공합니다.
- 개봉 불가능한 캡슐은 자물쇠 이미지와 블러 효과를 적용했습니다.

## 캡슐 상세

<img src="https://user-images.githubusercontent.com/55919701/205920889-034e3e5b-45a9-46a0-91c8-fa16dcc5be81.PNG" width="300">

- 개봉된 사용자의 캡슐 정보를 확인할 수 있습니다.
- 해당 캡슐이 묻혀있는 위치를 지도에서 확인할 수 있습니다.

# 🛠 사용 기술

## MVVM

- View 와 Model 간의 의존성을 줄이고자 MVVM 패턴을 사용했습니다.
- ViewModel 과 View 의 데이터 바인딩을 이용해 ViewController 의 부담을 덜어주었습니다.
- MVVM 패턴을 직접 구현해보며 학습해보고자 했습니다.

## Coordinator

- 앱의 계층 구조를 명확하게 하기 위해 Coordinator 패턴을 사용했습니다.
- 화면 전환 로직을 ViewController 에서 분리하고자 했습니다.
- ViewController 가 내부에서 ViewModel 을 직접 생성해서 가지고 있는 것이 역할에서 벗어난다고 생각해 Coordinator 를 통해 문제를 해결하고자 했습니다.

## RxSwift

- 비동기 작업을 더 간결하게 처리하기 위해 RxSwift 를 사용했습니다.
- 이벤트 처리를 간결하고 일관성 있게 처리하기 위해 RxCocoa 를 사용했습니다.
- 현업에서 많이 쓰이는 비동기 라이브러리라고 알고 있기에, 학습 차원에서 도입했습니다.

## Firebase

- 짧은 기간 내에 구현할 수 있는 사용자 인증, 데이터베이스 등의 기능이 필요해 Firebase 를 사용했습니다.
- NoSQL 데이터베이스로 수정과 확장이 용이해 사용하게 되었습니다.

# 🤔 고민과 해결

## 거리 계산 방식

<img src="https://user-images.githubusercontent.com/55919701/205921093-c21c6233-d1a3-4f43-ac5c-b4b638ebdb1a.png" width="300">

- 지도 위 개봉 가능한 캡슐은 초록색, 개봉 불가능한 캡슐은 회색으로 표시합니다.
- 사용자 위치 기준 반경 100m 이내에 있는 캡슐은 개봉 가능한 캡슐입니다.
- 사용자가 이동할때마다 사용자와 모든 캡슐과의 거리를 계산하는 것은 너무 큰 오버헤드라고 판단했습니다.

<img src="https://user-images.githubusercontent.com/55919701/205921172-382e4f14-152e-4c44-a624-d752b14fe846.png" width="300">

- 위와 같은 문제점 때문에 일부 캡슐들만 감시하기 위한 영역을 지정하기로 했습니다.
- 사용자가 이동할때마다 반경 1km 이내에 있는 캡슐들만의 개봉 가능 여부를 판단합니다.
- 사용자 반경 1km 외에 있는 캡슐들과의 거리는 계산하지 않습니다.

<img src="https://user-images.githubusercontent.com/55919701/205921236-808037c3-3ade-4a60-8b54-7fa08195fb0a.png" width="300">

- 항상 감시하는 영역을 (이미지상 큰 원) 업데이트 하는 경우는 사용자가 해당 영역의 가장자리에 가까워졌을 때입니다.
- 이는 사용자가 이동한 거리가 900m 를 넘어갔을 때이며, 감시하는 영역 밖에 개봉할 수 있는 캡슐이 있을 수도 있다는 뜻입니다.

<img src="https://user-images.githubusercontent.com/55919701/205921296-3d3f070f-1db3-47c1-9ccd-678f11f2fb73.png" width="300">

- 사용자가 항상 감시하는 영역의 중심으로부터 850m 이동할 시 새롭게 감시할 영역을 업데이트 합니다.
    - 감시 영역을 업데이트 할 거리인 900m에 오차 범위를 고려해 850m로 지정했습니다.
- 위 과정을 반복하며 캡슐 개봉 가능 여부에 관한 계산과 지도 어노테이션을 다시 그리는데 드는 오버헤드를 감소시키고자 하였습니다.
- 이를 통해 약 25% 의 성능 향상이라는 성과를 내었습니다.

# 🤝 협업 방식

## Git

- 변형된 Git Flow 모델을 사용하여 협업을 진행했습니다.
- `feature_기능이름` 과 같은 이름의 브랜치에서 작업을 진행하고 `develop` 브랜치에 PR 을 생성하는 방식으로 진행했습니다.
- 한명 이상의 리뷰와 승인이 있을 시 Merge 할 수 있도록 했습니다.
- 아래는 저희 팀의 Github 룰이 담긴 Wiki 페이지입니다.

[GitHub 룰](https://github.com/boostcampwm-2022/iOS01-Capsule/wiki/GitHub-%EB%A3%B0)

## Figma

[공간캡슐 디자인 Figma](https://www.figma.com/embed?embed_host=notion&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FYwaNiUE96rBMVXcvPBuFdK%2F%25EA%25B3%25B5%25EA%25B0%2584%25EC%25BA%25A1%25EC%258A%2590%3Fnode-id%3D0%253A1%26t%3DfDT2tIlg3PwqbJCH-1)

