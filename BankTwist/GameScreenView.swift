import SwiftUI

struct GameScreenView: View {
    
    @EnvironmentObject private var round: Round
    @EnvironmentObject private var players: NameList
    @State private var currentRound = 1
    @State private var gameScore = 0
    @State private var diceRoll = 1
    @State private var isWinScreenActive = false
    @State private var playersWhoBanked: [String] = []
    
    // Dictionary to store player scores, where key is player name and value is player score
    @State private var playerScores: [String: Int] = [:]
    
    var highestScoringPlayers: [String] {
        playerScores.sorted(by: { $0.value > $1.value }).map { $0.key }
    }
    
    func resetRound() {
        if gameScore == 0 || players.names.isEmpty {
            currentRound += 1
            if currentRound == round.roundCounter {
                isWinScreenActive = true
            }
            
            for name in playersWhoBanked {
                players.add(name)
            }
            playersWhoBanked.removeAll()
        }
    }
    
    func bankScore(for player: String) {
        guard let playerScore = playerScores[player] else { return }
        let newScore = playerScore + gameScore
        playerScores[player] = newScore
        
        // Add the player to the list of players who have banked
        playersWhoBanked.append(player)
        
        // Remove the player from the list of active players
        players.remove(player)
    }

    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                LinearGradient(gradient: Gradient(colors: [Color(red: 29.0/255, green: 90.0/255.0, blue: 137.0/255.0), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Text("Round: \(currentRound) out of \(round.roundCounter)")
                            .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    }
                    
                    Spacer().frame(height: 50)
                    
                    Text("\(gameScore)").font(.system(size: 75))
                        .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    
                    Spacer().frame(height: 100)
                    
                    // Renders people playing
                    ForEach(highestScoringPlayers, id: \.self) { name in
                        HStack {
                            Text("\(name): \(playerScores[name] ?? 0)")
                                .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            
                            // Check if the player is in the list of players who haven't banked
                            if !playersWhoBanked.contains(name) {
                                Button(action: {
                                    bankScore(for: name)
                                }) {
                                    Text("BANK!")
                                        .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                                }
                            }
                        }
                    }


                    
                    VStack {
                        Spacer().frame(height: 75)
                        
                        // All of the buttons
                        HStack {
                            ForEach(2..<6) { i in
                                Button(action: {
                                    gameScore += i
                                    diceRoll += 1
                                }) {
                                    Text("\(i)")
                                }
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                        
                        HStack {
                            Button(action: {
                                gameScore += 6
                                diceRoll += 1
                            }) {
                                Text("6")
                            }
                            .buttonStyle(CustomButtonStyle())
                            Button(action: {
                                if diceRoll < 4 {
                                    gameScore += 70
                                } else {
                                    gameScore = 0
                                    diceRoll = 0
                                }
                                
                                resetRound()
                                diceRoll += 1
                                print("\(diceRoll)")
                            }) {
                                Text("7")
                            }
                            .padding()
                            .background(diceRoll < 4 ? Color.green : Color.red)
                            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
                            .cornerRadius(10)
                            HStack {
                                ForEach(8..<10) { i in
                                    Button(action: {
                                        gameScore += i
                                        diceRoll += 1
                                    }) {
                                        Text("\(i)")
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                }
                            }
                        }
                        HStack {
                            ForEach(11..<13) { i in
                                Button(action: {
                                    gameScore += i
                                    diceRoll += 1
                                }) {
                                    Text("\(i)")
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                            
                            Button(action: {
                                gameScore = gameScore + gameScore
                                diceRoll += 1
                            }) {
                                Text("Doubles!")
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                    // Changes pages
                    .navigationBarHidden(true)
                    .background(
                        NavigationLink(destination: NavigationView {
                            WinScreen(highestScoringPlayer: highestScoringPlayers.first ?? "")
                        }.navigationBarHidden(true),
                                       isActive: $isWinScreenActive) {
                                           EmptyView()
                                       })
                    .onAppear {
                        // Initialize player scores to zero for each player
                        for name in players.names {
                            playerScores[name] = 0
                        }
                    }
                }
            }
        }
    }
}
