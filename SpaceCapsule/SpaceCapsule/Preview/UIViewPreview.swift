//
//  UIViewPreView.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/18.
//

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    struct UIViewPreview<View: UIView>: UIViewRepresentable {
        let view: View

        init(_ builder: @escaping () -> View) {
            view = builder()
        }

        // MARK: - UIViewRepresentable

        func makeUIView(context: Context) -> UIView {
            return view
        }

        func updateUIView(_ view: UIView, context: Context) {
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
    }
#endif

//#if canImport(SwiftUI) && DEBUG
//    import SwiftUI
//    // Preview 이름
//    struct ViewPreview: PreviewProvider {
//        static var previews: some View {
//            UIViewPreview {
//                View() // View 인스턴스
//            }
//            .previewLayout(.sizeThatFits)
//        }
//    }
//#endif
