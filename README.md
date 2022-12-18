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

# 🤝 협업 방식

## Git

- 변형된 Git Flow 모델을 사용하여 협업을 진행했습니다.
- `feature_기능이름` 과 같은 이름의 브랜치에서 작업을 진행하고 `develop` 브랜치에 PR 을 생성하는 방식으로 진행했습니다.
- 한명 이상의 리뷰와 승인이 있을 시 Merge 할 수 있도록 했습니다.
- 아래는 저희 팀의 Github 룰이 담긴 Wiki 페이지입니다.

[GitHub 룰](https://github.com/boostcampwm-2022/iOS01-Capsule/wiki/GitHub-%EB%A3%B0)

## Figma

- [공간캡슐 디자인 Figma](https://www.figma.com/embed?embed_host=notion&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FYwaNiUE96rBMVXcvPBuFdK%2F%25EA%25B3%25B5%25EA%25B0%2584%25EC%25BA%25A1%25EC%258A%2590%3Fnode-id%3D0%253A1%26t%3DfDT2tIlg3PwqbJCH-1)

# 🎤 추가 자료

### 발표 자료
- [발표 PPT](https://github.com/boostcampwm-2022/iOS01-Capsule/blob/develop/%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.md)
- 기술적 고민
    - [Apple Token Revoke](https://github.com/boostcampwm-2022/iOS01-Capsule/blob/develop/%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.md#apple-token-revoke)
    - [이미지 처리 및 캐싱 모듈](https://github.com/boostcampwm-2022/iOS01-Capsule/blob/develop/%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.md#%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%B2%98%EB%A6%AC-%EB%B0%8F-%EC%BA%90%EC%8B%B1-%EB%AA%A8%EB%93%88)
    - [캡슐 개봉 가능 여부 계산 로직](https://github.com/boostcampwm-2022/iOS01-Capsule/blob/develop/%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.md#%EC%BA%A1%EC%8A%90-%EA%B0%9C%EB%B4%89-%EA%B0%80%EB%8A%A5-%EC%97%AC%EB%B6%80-%EA%B3%84%EC%82%B0-%EB%A1%9C%EC%A7%81)
    - [3D Carousel CollectionView](https://github.com/boostcampwm-2022/iOS01-Capsule/blob/develop/%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C.md#3d-carousel-collectionview)

### 발표 영상

- [공간캡슐 발표 영상](https://youtu.be/acyWvWpLJVc)

### 시연 영상

- [공간캡슐 시연 영상](https://youtu.be/yiHOi-m3Stk)




