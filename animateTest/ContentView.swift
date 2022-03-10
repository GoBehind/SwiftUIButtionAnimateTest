//
//  ContentView.swift
//  animateTest
//
//  Created by 王冠之 on 2022/3/10.
//

import SwiftUI

struct ContentView: View {
    @State var likes: [LikeView] = []
    
    func likeAction () {
        likes += [LikeView()]
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ZStack {
                
                Image(systemName: "heart")
                    .resizable()
                    .frame(width: 50, height: 45)
                    .padding()
                    .onTapGesture {
                        likeAction()
                    }
                
                ForEach (likes) { like in
                    like.image.resizable()
                        .frame(width: 50, height: 45)
                        .modifier(LikeTapModifier())
                        .padding()
                        .id(like.id)
                }.onChange(of: likes) { newValue in
                    if likes.count > 10 {
                        likes.removeFirst()
                    }
                }
                
            }.foregroundColor(.white.opacity(0.5))
                .offset(x: 0, y: 60)
        }
    }
}



struct LikesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 200...300)
    var xDirection = Double.random(in: -0.05...0.05)
    var yDirection = Double.random(in: -Double.pi...0)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * xDirection
        let yTranslation = speed * sin(yDirection) * time
        let affineTranslation = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}


struct LikeTapModifier: ViewModifier {
    @State var time = 0.0
    let duration = 1.0
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .foregroundColor(.random)
                .modifier(LikesGeometryEffect(time: time))
                .opacity(time == 1 ? 0 : 1)
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
            }
        }
    }
}

struct LikeView : Identifiable, Equatable {
    let image = Image(systemName: "heart.fill")
    let id = UUID()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
