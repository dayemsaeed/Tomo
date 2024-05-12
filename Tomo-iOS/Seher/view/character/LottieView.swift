//
//  LottieView.swift
//  Tomo
//
//  Created by Dayem Saeed on 4/22/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var lottieFile: String
    var onAnimationComplete: (() -> Void)? = nil

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        
        // Load and play the animation
        loadAnimation(in: animationView, name: lottieFile)

        view.addSubview(animationView)
        
        // Configure layout constraints for the animation view
        setupConstraints(for: animationView, in: view)

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let animationView = uiView.subviews.first(where: { $0 is LottieAnimationView }) as? LottieAnimationView {
            loadAnimation(in: animationView, name: lottieFile)
        }
    }

    private func setupConstraints(for animationView: UIView, in parentView: UIView) {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: parentView.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: parentView.widthAnchor)
        ])
    }

    private func loadAnimation(in animationView: LottieAnimationView, name: String) {
        animationView.animation = LottieAnimation.named(name)
        animationView.loopMode = (name == "catIdle" || name == "catSleeping") ? .autoReverse : .playOnce
        animationView.play { finished in
            if finished {
                self.onAnimationComplete?()
            }
        }
    }
}
