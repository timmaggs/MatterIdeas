//
//  MatterHexDash.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import SwiftUI

var lineWidth: Double = 98.6    // 145
var lineHeight: Double = 5.44   // 8
var lineIndent: Double = 3.23   // 9.5/2 (4.75)

struct MatterHexDash: View {
    @State private var animating: Bool = false
    
    var body: some View {
        ZStack {
            Color("background")
            ZStack(alignment: .center) {
                if animating {
                    NeuroLineView(delay: 1, color: "dopamine", percent: 90, title: "Dopamine", textFlip: false)
                    NeuroLineView(delay: 1.4, color: "serotonin", percent: 100, title: "Serotonin", textFlip: false)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                    NeuroLineView(delay: 1.8, color: "cannabinoids", percent: 60, title: "Cannabinoids", textFlip: true)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                    NeuroLineView(delay: 2.2, color: "opioids", percent: 100, title: "Opioids", textFlip: true)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                    NeuroLineView(delay: 2.6, color: "oxytocin", percent: 100, title: "Oxytocin", textFlip: true)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                    NeuroLineView(delay: 3, color: "testosterone", percent: 60, title: "Testosterone", textFlip: false)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                        .rotationEffect(Angle(degrees: 60), anchor: UnitPoint(x: 0, y: 0))
                        .offset(x: lineWidth + 1)
                }
            }
            .frame(width: 200, height: 170)
            .offset(y: -lineWidth + 15)
            .scaleEffect(animating ? 1 : 1.2, anchor: .center)
            .animation(.easeInOut(duration: 0.6), value: animating)
            
            VStack(spacing: 0) {
                if animating {
                    ScoreCounter(value: Int.random(in: 2000..<9000))
                        .offset(y: 2)
                    Text("Matter Score")
                        .font(Font.custom("PitchSans-Regular", size: 11))
                        .foregroundColor(Color("text"))
                        .offset(y: -8)
                }
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
                    ReplayButton(delay: 4)
                }
                .offset(y: -120)
            }
        }
        .onAppear {
            animating = true
        }
        .onDisappear {
            animating = false
        }
        .ignoresSafeArea()
    }
}

struct NeuroLineView: View {
    @State private var animating: Bool = false
    let delay: Double
    let color: String
    let percent: CGFloat
    let title: String
    let textFlip: Bool
    
    var body: some View {
        
        ZStack {
            // Background
            Path { path in
                path.move(to: CGPoint(x : 0, y : 0))
                path.addLine (to : CGPoint(x: lineWidth, y : 0))
                path.addLine (to : CGPoint(x: lineWidth - lineIndent, y : lineHeight))
                path.addLine (to : CGPoint(x: lineIndent, y : lineHeight))
            }
            .fill(Color("background-hex"))
            
            // Color Gradient
            Path { path in
                path.move(to: CGPoint(x : 0, y : 0))
                path.addLine (to : CGPoint(x: lineWidth, y : 0))
                path.addLine (to : CGPoint(x: lineWidth - lineIndent, y : lineHeight))
                path.addLine (to : CGPoint(x: lineIndent, y : lineHeight))
            }
            .fill(LinearGradient(stops: [
                Gradient.Stop(color: Color(color).opacity(0), location: 0.00),
                Gradient.Stop(color: Color(color), location: 0.5),
                ], startPoint: UnitPoint(x: 0, y: 0.5), endPoint: UnitPoint(x: 1, y: 0.5)))
            .mask {
                Path { path in
                    path.move(to: CGPoint(x : 0, y : 0))
                    path.addLine (to : CGPoint(x: lineWidth, y : 0))
                    path.addLine (to : CGPoint(x: lineWidth - lineIndent, y : lineHeight))
                    path.addLine (to : CGPoint(x: lineIndent, y : lineHeight))
                }
                .offset(x: animating ? -getLineSize(percent: percent, inverse: true) : -lineWidth)
                .animation(.easeOut(duration: 0.85).delay(delay), value: animating)
            }
            .onAppear { animating = true }
            .onDisappear { animating = false }
            .overlay {
                NeuroParticleView(birthRate: 300, lifetime: 1, velocity: 30, animDuration: 0.62, delay: delay, color: color, percent: percent)
                NeuroParticleView(birthRate: 500, lifetime: 0.5, velocity: 10, animDuration: 0.62, delay: delay, color: color, percent: percent)
            }
        }
        .frame(width: lineWidth, height: lineHeight)
        .overlay {
            Text(title)
                .font(Font.custom("PitchSans-Regular", size: 10))
                .foregroundColor(Color("text"))
                .offset(y: textFlip ? 29 : -17)
                .rotationEffect(textFlip ? Angle(degrees: 180) : .zero, anchor: .bottom)
                .opacity(animating ? 1 : 0)
                .animation(.easeOut(duration: 2).delay(delay), value: animating)
        }
    }
}

struct NeuroParticleView: UIViewRepresentable {
    let birthRate: Float
    let lifetime: Float
    let velocity: CGFloat
    let animDuration: Double
    let delay: Double
    let color: String
    let percent: CGFloat
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight))
        view.layer.masksToBounds = false
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterShape = .rectangle
        emitterLayer.emitterSize = CGSize(width: 1, height: 8)
        emitterLayer.emitterPosition = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .oldestLast
        emitterLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = lifetime
        cell.velocity = velocity
        cell.scale = 0.04
        cell.emissionRange = .pi * 2
        cell.emissionLongitude = .pi
        cell.alphaSpeed = -0.5
        cell.color = UIColor(named: color)?.cgColor
        
        cell.contents = UIImage(named: "spark")?.cgImage
        
        emitterLayer.emitterCells = [cell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let animation = CAKeyframeAnimation()
            animation.duration = animDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.keyTimes = [0, 0.1, 0.7, 1]
            animation.values = [birthRate / 4, birthRate, birthRate, 0]
            emitterLayer.add(animation, forKey: "birthRate")
            
            let posAnim = CABasicAnimation()
            posAnim.duration = animDuration
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            posAnim.fromValue = CGPoint(x: 0, y: view.frame.height / 2)
            posAnim.toValue = CGPoint(x: -getLineSize(percent: percent, inverse: false), y: view.frame.height / 2)
            emitterLayer.add(posAnim, forKey: "emitterPosition")
        }
        
        view.layer.addSublayer(emitterLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

func getLineSize(percent: CGFloat, inverse: Bool) -> CGFloat {
    let width = -((lineWidth / 100) * percent)
    if (inverse) {
        return width + lineWidth
    } else {
        return width
    }
}

struct ScoreCounter: View {
    var value: Int
    @State var animationRange: [Int] = []
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<animationRange.count,id: \.self) { index in
                Text("0")
                    .font(Font.custom("MagnetHeadline-Upright", size: 80))
                    .opacity(0)
                    .overlay {
                        GeometryReader { proxy in
                            let size = proxy.size
                            VStack(spacing: -30) {
                                ForEach(0...9, id: \.self) { number in
                                    Text("\(number)")
                                        .font(Font.custom("MagnetHeadline-Upright", size: 80))
                                        .foregroundColor(Color("text"))
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[index]) * (size.height - 30))
                        }
                        .mask {
                            Rectangle()
                                .frame(height: 70)
                        }
                    }
            }
        }
        .onAppear {
            animationRange = Array(repeating: 0, count: "\(value)".count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                updateText()
            }
        }
    }
    
    func updateText() {
        let stringValue = "\(value)"
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            var fraction = Double(index) * 0.15
            fraction = (fraction > 0.5 ? 0.5 : fraction)
            withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = (String(value) as NSString).integerValue
            }
        }
    }
}


#Preview {
    MatterHexDash()
}
