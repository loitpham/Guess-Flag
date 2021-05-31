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
                        flagTapped(number)
                    }) {
                        FlagImage(imageName: countries[number])
                    }
                }
                
                Text("Current score")
                    .foregroundColor(.white)
                Text("\(score)")
                    .foregroundColor(.orange)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),                
                  dismissButton: .default(Text("Continue")) {
                    askQuestion()
                  })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
        } else {
            scoreTitle = "Wrong. That's the flag of \(countries[number])"
            score -= 5
        }
        
        showingScore = true;
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
