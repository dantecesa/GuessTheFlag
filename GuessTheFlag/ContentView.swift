//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dante Cesa on 1/7/22.
//

import SwiftUI

struct ContentView: View {
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Japan", "Switzerland"].shuffled()
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    @State var numberOfCorrectGuesses: Int = 0
    @State var numberOfGuesses: Int = 0
    @State var gameOver: Bool = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],center: .top, startRadius: 200, endRadius: 700).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack (spacing: 15) {
                    VStack {
                        Text("Tap the country of…").font(.subheadline.weight(.heavy)).foregroundStyle(.secondary)
                        Text(countries[correctAnswer]).font(.largeTitle.weight(.semibold))
                    }.padding()
                    ForEach(0..<3) { index in
                        Button {
                            makeGuess(buttonIndex: index)
                        } label: {
                            Image(countries[index])
                                .renderingMode(.original)
                                .clipShape(Circle().scale(1))
                                .shadow(radius: 5)
                        }.padding()
                    }
                }.frame(width: .infinity).padding(.vertical, 20).background(.regularMaterial).clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(numberOfCorrectGuesses)/\(numberOfGuesses)").foregroundColor(.white).font(.title.bold()).padding()
                Spacer()
            }
        }.alert(alertText, isPresented: $showAlert) {
            Button("Continue", action: reloadFlags)
        } message: {
            Text("Your score is: \(numberOfCorrectGuesses)/\(numberOfGuesses)")
        }.alert("Good job!", isPresented: $gameOver) {
            Button("Play Again", action: reset)
        } message: {
            Text("Your final score was: \(numberOfCorrectGuesses)/\(numberOfGuesses)")

        }
    }
    
    func reloadFlags() {
        countries.remove(at: correctAnswer)
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func makeGuess(buttonIndex: Int) {
        if buttonIndex == correctAnswer {
            alertText = "That's correct!"
            numberOfCorrectGuesses += 1
        } else {
            alertText = "Nope, that's \(countries[buttonIndex])."
        }
        numberOfGuesses += 1
        
        if numberOfGuesses == 10 {
            gameOver = true
        } else {
            showAlert = true
        }
    }
    
    func reset() {
        self.numberOfGuesses = 0
        self.numberOfCorrectGuesses = 0
        countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Japan", "Switzerland"]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
