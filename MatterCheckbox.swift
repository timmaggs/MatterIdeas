//
//  MatterCheckbox.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import SwiftUI

struct MatterCheckbox: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var showReset: Bool = false
    @State var visible: Bool = true
    
    let colorEN: [Color] = [Color(red: 0.99, green: 0.39, blue: 0.45), Color(red: 0.99, green: 0.39, blue: 0.45), Color(red: 0.98, green: 0.56, blue: 0.81)]
    let colorSD: [Color] = [Color(red: 1.00, green: 0.79, blue: 0.69), Color(red: 1.00, green: 0.79, blue: 0.69), Color(red: 1.00, green: 0.53, blue: 0.61)]
    let colorPR: [Color] = [Color(red: 1.00, green: 0.80, blue: 0.47), Color(red: 1.00, green: 0.80, blue: 0.47), Color(red: 0.99, green: 0.66, blue: 0.60)]
    let colorNL: [Color] = [Color(red: 0.07, green: 0.85, blue: 0.76), Color(red: 0.07, green: 0.85, blue: 0.76), Color(red: 0.31, green: 0.69, blue: 0.93)]
    let colorCO: [Color] = [Color(red: 0.05, green: 0.84, blue: 0.76), Color(red: 0.18, green: 0.56, blue: 0.91), Color(red: 0.55, green: 0.50, blue: 0.92)]
    let colorFL: [Color] = [Color(red: 0.18, green: 0.56, blue: 0.91), Color(red: 0.18, green: 0.56, blue: 0.91), Color(red: 0.23, green: 0.86, blue: 0.91)]
    let colorAM: [Color] = [Color(red: 0.60, green: 0.64, blue: 0.93), Color(red: 0.19, green: 0.57, blue: 0.91), Color(red: 0.34, green: 0.86, blue: 0.93)]
    let colorPL: [Color] = [Color(red: 0.58, green: 0.62, blue: 0.92), Color(red: 0.58, green: 0.62, blue: 0.92), Color(red: 0.67, green: 0.87, blue: 1.00)]
    let colorGR: [Color] = [Color(red: 0.60, green: 0.64, blue: 0.93), Color(red: 0.62, green: 0.60, blue: 0.90), Color(red: 0.82, green: 0.61, blue: 0.82)]
    
    var body: some View {
        ZStack {
            Color("background")
            if visible {
                HStack(spacing: 10) {
                    CheckboxAnim(color: colorEN, title: "EN", showReset: $showReset)
                    CheckboxAnim(color: colorSD, title: "SD", showReset: $showReset)
                    CheckboxAnim(color: colorPR, title: "PR", showReset: $showReset)
                    CheckboxAnim(color: colorNL, title: "NL", showReset: $showReset)
                    CheckboxAnim(color: colorCO, title: "CO", showReset: $showReset)
                    CheckboxAnim(color: colorFL, title: "FL", showReset: $showReset)
                    CheckboxAnim(color: colorAM, title: "AM", showReset: $showReset)
                    CheckboxAnim(color: colorPL, title: "PL", showReset: $showReset)
                    CheckboxAnim(color: colorGR, title: "GR", showReset: $showReset)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 5)
                .padding(.bottom, 20)
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(Color("glass"))
                }
                .padding(.horizontal)
            }
        }
        .overlay(alignment: .bottom) {
            if showReset {
                Button(action: {
                    withAnimation { visible = false }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation { visible = true }
                    }
                    withAnimation { showReset = false }
                }) {
                    ReplayButton(delay: 0, message: "Reset Emotions")
                }
                .padding(.bottom, 120)
            }
        }
        .ignoresSafeArea()
    }
}

struct CheckboxAnim: View {
    let color: [Color]
    let title: String
    
    @Binding var showReset: Bool
    @State private var completedLongPress = false
    @State private var isPressing = false
    @State private var animSpeed = 0.2
    
    @State private var animating = false
    
    var animTime: Double = 1.8
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("background"))
                .stroke(LinearGradient(stops: [
                    Gradient.Stop(color: color[0], location: 0.00),
                    Gradient.Stop(color: color[1], location: 0.70),
                    Gradient.Stop(color: color[2], location: 1.00),
                ], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1)), style: StrokeStyle(lineWidth: 1.6, lineCap: .round, dash: [0, 3.6]))
            Circle()
                .trim(from: 0, to: self.isPressing ? 1 : (self.completedLongPress ? 1 : 0))
                .stroke(LinearGradient(stops: [
                    Gradient.Stop(color: color[0], location: 0.00),
                    Gradient.Stop(color: color[1], location: 0.70),
                    Gradient.Stop(color: color[2], location: 1.00),
                ], startPoint: UnitPoint(x: 1, y: 0.5), endPoint: UnitPoint(x: 0, y: 0.5)), style: StrokeStyle(lineWidth: 1.6))
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeIn(duration: self.animSpeed), value: self.isPressing)
            Circle()
                .fill(LinearGradient(stops: [
                    Gradient.Stop(color: color[0], location: 0.00),
                    Gradient.Stop(color: color[1], location: 0.70),
                    Gradient.Stop(color: color[2], location: 1.00),
                ], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1)))
                .scaleEffect(self.completedLongPress ? 1 : 0, anchor: .center)
            if animating {
                CheckboxParticleExplosion(birthRate: 500, lifetime: 0.25, velocity: 100, animDuration: 0.1, color: color[0])
                CheckmarkAnim()
            }
        }
        .frame(width: 24, height: 100)
        .background(Color("glass"))
        .onLongPressGesture(minimumDuration: animTime, maximumDistance: 50) {
            if !animating {
                AudioManager.playCheckboxSound(soundfile: "complete.mp3")
            }
            withAnimation(.spring(duration: 0.3, bounce: 0.6)) { self.completedLongPress = true }
            animating = true
            withAnimation { showReset = true }
        } onPressingChanged: { isPressing in
            self.isPressing = isPressing
            self.animSpeed = animTime
            if !isPressing { self.animSpeed = 0.2 }
        }
        .sensoryFeedback(.impact, trigger: isPressing)
        .sensoryFeedback(.success, trigger: completedLongPress)
        .overlay(alignment: .bottom) {
            Text(title)
                .font(Font.custom("PitchSans-Regular", size: 11))
                .foregroundColor(Color("text"))
                .offset(y: -16)
        }
    }
}

struct CheckmarkAnim: View {
    @State private var animating: Bool = false
    
    var body: some View {
        Image("icon-checkmark")
            .resizable()
            .frame(width: 12, height: 9.5)
            .mask(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .frame(width: 10, height: 4)
                        .rotationEffect(Angle(degrees: 45))
                        .offset(x: animating ? -4 : -14, y: animating ? 2 : -8)
                        .animation(.easeOut(duration: 0.2).delay(0.25), value: animating)
                    
                    Rectangle()
                        .frame(width: 15, height: 3, alignment: .leading)
                        .rotationEffect(Angle(degrees: -45))
                        .offset(x: animating ? 0 : -12, y: animating ? 0 : 12)
                        .animation(.easeOut(duration: 0.2).delay(0.35), value: animating)
                }
            }
            .onAppear {
                animating = true
            }
    }
}

/* ################
 
 Explosion particles
 
 ################ */

struct CheckboxParticleExplosion: UIViewRepresentable {
    let birthRate: Float
    let lifetime: Float
    let velocity: CGFloat
    let animDuration: Double
    let color: Color
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 100))
        view.layer.masksToBounds = false
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: 24, height: 24)
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
        cell.color = color.cgColor
        
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
    MatterCheckbox()
}
