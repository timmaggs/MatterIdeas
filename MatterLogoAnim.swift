//
//  MatterLogoAnim.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import SwiftUI
import CoreHaptics

struct MatterLogoAnim: View {
    @State private var viewDidLoad: Bool = false
    @State private var animating: Bool = false
    
    var body: some View {
        ZStack {
            Color("onyx")
            MatterLogoAnimParticleView(birthRate: 100, lifetime: 10, velocity: 30)
            if animating {
                MatterImageAnimView()
            }
        }
        .overlay(alignment: .bottom) {
            if animating {
                Button(action: {
                    withAnimation { animating = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation { animating = true }
                    }
                }) {
                    ReplayButton(delay: 7, scheme: "dark")
                }
                .offset(y: -120)
            }
        }
        .onAppear {
            withAnimation { animating = true }
            if !viewDidLoad {
                AudioManager.playBackgroundSound(soundfile: "atmosphere.mp3")
                viewDidLoad = true
            }
        }
        .onDisappear {
            animating = false
        }
        .ignoresSafeArea()
    }
}

struct MatterImageAnimView: View {
    @State private var animating: Bool = false
    @State private var explode: Bool = false
    @State private var engine: CHHapticEngine?
    
    struct AnimationValues {
        var scale = 1.0
        var opacity = 0.0
        var blur = 0.0
        var offset = 0.0
        var rotation: Angle = .zero
    }
    
    var body: some View {
        ZStack {
            
            if explode {
                MatterLogoAnimParticleExplosion(birthRate: 3000, lifetime: 1, velocity: 100, animDuration: 0.25)
            }
            
            // Matter Image Animation
            Image("matter-logo")
                .resizable()
                .frame(width: 225/2, height: 83/2)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 225/2, height: 83/2)
                        .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                            content
                                .offset(x: animating ? value.offset : 225/2)
                        } keyframes: { _ in
                            KeyframeTrack(\.offset) {
                                MoveKeyframe(225/2)                     // 0
                                LinearKeyframe(225/2, duration: 3.2)    // 3.2
                                CubicKeyframe(0, duration: 0.1)         // 3.3
                                LinearKeyframe(0, duration: 3.6)        // 6.9
                            }
                        }
                }
                .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                    content
                        .scaleEffect(animating ? value.scale : 1)
                        .opacity(animating ? value.opacity : 0)
                        .blur(radius: animating ? value.blur : 0)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        MoveKeyframe(1)
                        LinearKeyframe(1, duration: 3.5)    // 3.5
                        CubicKeyframe(0.7, duration: 3.0)   // 6.5
                        CubicKeyframe(1.5, duration: 0.1)   // 6.6
                        MoveKeyframe(1)                     // 6.6
                    }
                    KeyframeTrack(\.opacity) {
                        MoveKeyframe(1)                     // 0
                        LinearKeyframe(1, duration: 6.5)    // 6.5
                        CubicKeyframe(0, duration: 0.2)     // 6.7
                    }
                    KeyframeTrack(\.blur) {
                        MoveKeyframe(0)                     // 0
                        CubicKeyframe(0, duration: 6.5)     // 6.5
                        CubicKeyframe(25, duration: 0.2)    // 6.7
                    }
                }
            
            // Home Icon Focus
            ZStack {
                Image("home-inner-ring")
                    .resizable()
                    .frame(width: 63.5/2, height: 60/2)
                    .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                        content
                            .rotationEffect(animating ? value.rotation : .zero)
                    } keyframes: { _ in
                        KeyframeTrack(\.rotation) {
                            CubicKeyframe(.zero, duration: 0.1)         // 0.1
                            CubicKeyframe(.degrees(45), duration: 0.1)  // 0.2
                            CubicKeyframe(.degrees(0), duration: 0.1)   // 0.3
                            CubicKeyframe(.degrees(0), duration: 0.8)   // 1.1
                            CubicKeyframe(.degrees(-45), duration: 0.1) // 1.2
                            CubicKeyframe(.zero, duration: 0.1)         // 1.3
                        }
                    }
                Image("home-outer-ring")
                    .resizable()
                    .frame(width: 93/2, height: 83/2)
                    .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                        content
                            .rotationEffect(animating ? value.rotation : .zero)
                    } keyframes: { _ in
                        KeyframeTrack(\.rotation) {
                            CubicKeyframe(.zero, duration: 0.1)         // 0.1
                            CubicKeyframe(.degrees(-45), duration: 0.1) // 0.2
                            CubicKeyframe(.zero, duration: 0.1)         // 0.3
                            CubicKeyframe(.degrees(0), duration: 0.8)   // 1.1
                            CubicKeyframe(.degrees(45), duration: 0.1)  // 1.2
                            CubicKeyframe(.zero, duration: 0.1)         // 1.3
                        }
                    }
            }
            .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                content
                    .scaleEffect(animating ? value.scale : 1)
                    .opacity(animating ? value.opacity : 0)
                    .blur(radius: animating ? value.blur : 0)
                    .offset(x: animating ? value.offset : 0)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    CubicKeyframe(1.5, duration: 0.1)   // 0.1
                    CubicKeyframe(1, duration: 0.1)     // 0.2
                    CubicKeyframe(1, duration: 1)       // 1.2
                    CubicKeyframe(1.1, duration: 0.6)   // 1.8
                    CubicKeyframe(1, duration: 0.3)     // 2.1
                }
                KeyframeTrack(\.opacity) {
                    CubicKeyframe(1, duration: 0.1)     // 0.1
                    LinearKeyframe(1, duration: 3.2)    // 3.3
                    CubicKeyframe(0, duration: 0.3)     // 3.6
                }
                KeyframeTrack(\.blur) {
                    CubicKeyframe(0, duration: 0.1)     // 0.1
                    CubicKeyframe(20, duration: 0.1)    // 0.2
                    CubicKeyframe(0, duration: 0.1)     // 0.3
                    CubicKeyframe(0, duration: 0.8)     // 1.1
                    CubicKeyframe(5, duration: 0.6)     // 1.7
                    CubicKeyframe(0, duration: 0.3)     // 2.0
                    LinearKeyframe(0, duration: 1.3)    // 3.3
                }
                KeyframeTrack(\.offset) {
                    LinearKeyframe(0, duration: 3)      // 3.0
                    CubicKeyframe(35, duration: 0.2)    // 3.2
                    CubicKeyframe(-85, duration: 0.1)   // 3.3
                    CubicKeyframe(-20, duration: 0.1)   // 3.4
                }
            }
            .mask {
                Rectangle()
                    .frame(width: 225, height: 80)
                    .keyframeAnimator(initialValue: AnimationValues(), trigger: animating) { content, value in
                        content
                            .offset(x: animating ? value.offset : .zero)
                    } keyframes: { _ in
                        KeyframeTrack(\.offset) {
                            LinearKeyframe(0, duration: 3.3)    // 3.3
                            LinearKeyframe(-165, duration: 0)   // 3.3
                            LinearKeyframe(-165, duration: 1)   // 4.3
                            LinearKeyframe(0, duration: 0)      // 4.3
                        }
                    }
            }
        }
        .onAppear {
            withAnimation { animating = true }
            AudioManager.playSound(soundfile: "logo-sfx.mp3")
            AudioManager.fadeInSound()
            prepareHaptics()
            Timer.scheduledTimer(withTimeInterval: 6.5, repeats: false) { timer in
                explode = true
                hapticExplosion()
            }
        }
        .onDisappear {
            AudioManager.fadeOutSound()
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func hapticExplosion() {
        var events = [CHHapticEvent]()
        var curves = [CHHapticParameterCurve]()

        do {
            // create one continuous buzz that fades out
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

            let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
            let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1.5, value: 0)

            let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: 1.5)
            events.append(event)
            curves.append(parameter)
        }

        for _ in 1...16 {
            // make some sparkles
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [sharpness, intensity], relativeTime: TimeInterval.random(in: 0.1...1))
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: curves)

            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error.localizedDescription)
        }
    }
}

/* ################
 
 Background particles
 
 ################ */

struct MatterLogoAnimParticleView: UIViewRepresentable {
    let birthRate: Float
    let lifetime: Float
    let velocity: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        let screenSize = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        view.layer.masksToBounds = false
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterPosition = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .oldestLast
        emitterLayer.birthRate = birthRate
        
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = lifetime
        cell.velocity = velocity
        cell.scale = 0.05
        cell.emissionRange = .pi * 2
        cell.emissionLongitude = .pi
        cell.alphaSpeed = -0.5
        cell.color = UIColor(white: 1, alpha: 0.8).cgColor
        
        cell.contents = UIImage(named: "spark")?.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        view.layer.addSublayer(emitterLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

/* ################
 
 Explosion particles
 
 ################ */

struct MatterLogoAnimParticleExplosion: UIViewRepresentable {
    let birthRate: Float
    let lifetime: Float
    let velocity: CGFloat
    let animDuration: Double
    
    func makeUIView(context: Context) -> some UIView {
        let screenSize = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        view.layer.masksToBounds = false
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: 100, height: 40)
        emitterLayer.emitterPosition = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .oldestLast
        emitterLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = lifetime
        cell.velocity = velocity
        cell.scale = 0.05
        cell.emissionRange = .pi * 2
        cell.alphaSpeed = -0.5
        
        cell.contents = UIImage(named: "spark")?.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let animation = CAKeyframeAnimation()
            animation.duration = animDuration
            animation.keyTimes = [0, 0.7, 1]
            animation.values = [birthRate, birthRate, 0]
            emitterLayer.add(animation, forKey: "birthRate")
        }
        
        view.layer.addSublayer(emitterLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    MatterLogoAnim()
}
