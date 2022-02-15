//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dante Cesa on 1/7/22.
//

import SwiftUI

struct ContentView: View {
    @State private var countries: [String] = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Japan", "Switzerland"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner",
        "Japan": "Flag with white background and red dot.",
        "Switzerland": "Flag with red background and a centered white plus."
    ]
    
    @State private var correctAnswer: Int = Int.random(in: 0...2)
    @State private var showAlert: Bool = false
    @State private var alertText: String = ""
    @State var numberOfCorrectGuesses: Int = 0
    @State var numberOfGuesses: Int = 0
    @State var gameOver: Bool = false
    @State var animationDegrees: [Double] = [0, 0, 0]
    @State var animationOpacity: [Double] = [0, 0, 0]
    
    func flagImage(flagIndex: Int) -> some View {
        Image(countries[flagIndex])
            .renderingMode(.original)
            .clipShape(Circle().scale(1))
            .shadow(radius: 5)
    }
    
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
                    }
                    .padding()
                    .accessibilityElement()
                    .accessibilityLabel("Tap the conutry of \(countries[correctAnswer])")
                    ForEach(0..<3) { index in
                        Button {
                            withAnimation(.interpolatingSpring(stiffness: 10, damping: 2)) {
                                animationDegrees[index] += 360
                            }
                            
                            withAnimation(.linear) {
                                animationOpacity = [0.25, 0.25, 0.25]
                                animationOpacity[index] = 1
                            }
                            makeGuess(buttonIndex: index)
                        } label: {
                            flagImage(flagIndex: index)
                                .accessibilityLabel(labels[countries[index], default: "Unknown Flag"])
                        }
                        .padding()
                        .rotation3DEffect(.degrees(animationDegrees[index]), axis: (x: 0, y: 1, z: 0))
                        .opacity(animationOpacity[index])
                        .onAppear {
                            withAnimation(.default.delay(0.25)) {
                                animationOpacity = [1, 1, 1]
                            }
                        }
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
        withAnimation(.default.delay(0.10)) {
            animationOpacity = [1, 1, 1]
        }
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
        withAnimation(.default.delay(0.25)) {
            self.animationOpacity = [1, 1, 1]
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
