//
//  ReplayButton.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import SwiftUI

struct ReplayButton: View {
    let delay: Double
    var scheme:String = "auto"
    var message: String = "Replay Animation"
    
    @State var animating: Bool = false
    @State var slideAnim: Bool = false
    @State var rotateAnim: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            if animating {
                HStack(spacing: 16) {
                    Image(scheme == "auto" ? colorScheme == .dark ? "icon-replay" : "icon-replay-dark" : "icon-replay")
                        .resizable()
                        .frame(width: 16, height: 15)
                        .rotationEffect(rotateAnim ? .zero : Angle(degrees: -90))
                        .opacity(0.4)
                        .onAppear {
                            withAnimation(.spring(duration: 0.6, bounce: 0.45)) { slideAnim = true }
                            withAnimation(.easeOut(duration: 1.5)) { rotateAnim = true }
                        }
                    
                    Text(message)
                        .font(Font.custom("PitchSans-Regular", size: 12))
                        .foregroundColor(scheme == "auto" ? Color("text") : Color(.white))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(scheme == "auto" ? Color("glass") : Color(red: 0.14, green: 0.13, blue: 0.13))
                }
                .padding(.horizontal, 30)
                .allowsHitTesting(slideAnim ? false : true)
                .opacity(slideAnim ? 1 : 0)
                .offset(y: slideAnim ? 0 : 30)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation { animating = true }
            }
        }
    }
}

#Preview {
    ReplayButton(delay: 0)
}
