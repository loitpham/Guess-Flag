//
//  ContentView.swift
//  Guess-Flag
//
//  Created by Loi Pham on 5/12/21.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    
    @State private var scoreTitle = ""
    
    @State private var score = 0
    
    @State private var animationAmount = 0.0
    @State private var fadeOut = false
    @State private var normal = true

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 2).repeatCount(3)) {
                            flagTapped(number)
                        }
                    }) {
                        FlagImage(imageName: countries[number])
                    }
                    .rotation3DEffect(
                        isCorrect(number) ?  .degrees(animationAmount) : .zero,
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .opacity(normal || (fadeOut && isCorrect(number)) ? 1.0 : 0.25)
                    
                }
                
                Text("Current score")
                    .foregroundColor(.white)
                Text("\(score)")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                if showingScore {
                    VStack {
                        Text(scoreTitle)
                            .padding()
                            .foregroundColor(.white)
                            .font(.title)
                        
                        Button(action: {
                            askQuestion()
                            showingScore = false
                        }) {
                            Text("Next")
                                .font(.title)
                        }
                    }
                }
                
                Spacer()
                
            }
        }
    }
    
    func isCorrect(_ number: Int) -> Bool {
        return number == correctAnswer
    }
    
    func flagTapped(_ number: Int) {
        if isCorrect(number) {
            scoreTitle = "Correct"
            score += 10
            animationAmount += 360
            fadeOut = true
            normal = false
        } else {
            scoreTitle = "Wrong. That's the flag of \(countries[number])"
            score -= 5
        }
        
        showingScore = true;
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        normal = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
