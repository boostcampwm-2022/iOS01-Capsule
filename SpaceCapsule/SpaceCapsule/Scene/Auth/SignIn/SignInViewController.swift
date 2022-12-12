//
//  SignInViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import RxCocoa
import RxSwift

final class SignInViewController: UIViewController, BaseViewController {
    // MARK: - Properties

    private let signInView = SignInView()
    var viewModel: SignInViewModel?
    var disposeBag = DisposeBag()

    fileprivate var currentNonce: String?

    // MARK: - Lifecycles

    override func loadView() {
        view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    // MARK: - Rx

    func bind() {
        signInView.appleSignInButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.appleSignInButtonDidTap()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Apple SignIn

    func appleSignInButtonDidTap() {
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        print("애플로그인")
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    @available(iOS 13, *)
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let appleIDRequest = appleIDProvider.createRequest()
        // 애플로그인은 사용자에게서 2가지 정보를 요구함
        appleIDRequest.requestedScopes = [.fullName, .email]

        let nonce = randomNonceString()
        appleIDRequest.nonce = sha256(nonce)
        currentNonce = nonce

        return appleIDRequest
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    // MARK: - @objc Functions

    // MARK: - Custom Methods
}

// MARK: - ASAuthorizationControllerDelegate

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 몇 가지 표준 키 검사를 수행
            // 1. 현재 nonce가 설정되어 있는지 확인
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            // 2. ID 토큰을 검색하여
            guard let appleIDtoken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            // 문자열로 변환
            guard let idTokenString = String(data: appleIDtoken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDtoken.debugDescription)")
                return
            }
            if let authorizationCode = appleIDCredential.authorizationCode,
               let codeString = String(data: authorizationCode, encoding: .utf8) {
                UserDefaultsManager<String>.saveData(data: codeString, key: .authorizationCode)
            }
            // nonce와 IDToken을 사용하여 OAuth 공급자에게 방금 로그인한 사용자를 나타내는 자격증명을 생성하도록 요청
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)

            // 이 자격증명을 사용하여 Firebase에 로그인할 것이다.
            // Firebase는 자격증명을 확인하고 유효한 경우 사용자를 로그인시켜 줄 것이다.
            // 새 사용자인 경우에 Firebase는 ID 토큰에 제공된 정보를 사용하여 새 사용자 계정을 만들 것이다.
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in

                guard let self = self else {
                    return
                }

                // 인증 결과에서 Firebase 사용자를 검색하고 사용자 정보를 표시할 수 있다.
                if let error = error {
                    print(error.localizedDescription)
                    UserDefaultsManager.saveData(data: false, key: .isSignedIn)
                    return
                }

                if let user = authResult?.user {
                    print("애플 로그인 성공!", user.uid, user.email ?? "-")
                    UserDefaultsManager.saveData(data: true, key: .isSignedIn)
                    self.viewModel?.checkRegistration(uid: user.uid)
                    if let refreshToken = user.refreshToken {
                        UserDefaultsManager<String>.saveData(data: refreshToken, key: .refreshToken)
                    }
                }
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    // presentation context UI를 어디에 띄울지 가장 적합한 뷰 앵커를 반환한다.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? ASPresentationAnchor()
    }
}

// MARK: - randomNonceString()

extension SignInViewController {
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
