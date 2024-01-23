//
//  ContentView.swift
//  MatterIdeas
//
//  Created by Tim Maggs on 23/01/2024.
//

import SwiftUI

struct ContentView: View {
    var tabDarkModes: [Bool] = [true, false, false]

    @State var offset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.init()) {
                TabView {
                    
                    MatterLogoAnim()
                        .offsetX { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * 0)
                            DispatchQueue.main.async {
                                withAnimation(.default) {
                                    self.offset = -pageOffset
                                }
                            }
                        }
                    
                    MatterHexDash()
                        .offsetX { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * 1)
                            DispatchQueue.main.async {
                                withAnimation(.default) {
                                    self.offset = -pageOffset
                                }
                            }
                        }
                    
                    MatterCheckbox()
                        .offsetX { rect in
                            let minX = rect.minX
                            let pageOffset = minX - (size.width * 2)
                            DispatchQueue.main.async {
                                withAnimation(.default) {
                                    self.offset = -pageOffset
                                }
                            }
                        }

                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                HStack(spacing: 8) {
                    ForEach(tabDarkModes.indices,id: \.self) { index in
                        
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerSize: CGSize(width: 1.5, height: 1.5))
                                .fill(tabDarkModes[getIndex()] ? Color.white : colorScheme == .dark ? Color.white : Color.black)
                                .rotationEffect(Angle(degrees: 45))
                                .frame(width: 6, height: 6)
                                .offset(x: 3)
                            
                            Rectangle()
                                .fill(tabDarkModes[getIndex()] ? Color.white : colorScheme == .dark ? Color.white : Color.black)
                                .frame(width: getIndex() == index ? 20 : 1, height: 7)
                            
                            RoundedRectangle(cornerSize: CGSize(width: 1.5, height: 1.5))
                                .fill(tabDarkModes[getIndex()] ? Color.white : colorScheme == .dark ? Color.white : Color.black)
                                .rotationEffect(Angle(degrees: 45))
                                .frame(width: 6, height: 6)
                                .offset(x: -3)
                        }
                    }
                }
                .padding(.bottom, proxy.safeAreaInsets.bottom)
            }
        }
    }
    
    func getIndex() -> Int {
        let index = Int(round(Double(offset / getWidth())))
        return index
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
}

#Preview {
    ContentView()
}
