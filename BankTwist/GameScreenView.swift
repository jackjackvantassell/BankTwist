import SwiftUI

struct GameScreenView: View {
    @EnvironmentObject private var round: Round
    @EnvironmentObject private var players: NameList
    @State private var currentRound = 1
    @State private var gameScore = 0
    @State private var diceRoll = 1
    @State private var isWinScreenActive = false
    @State private var playersWhoBanked: [String] = []
    @State private var playerScores: [String: Int] = [:]
    // [() -> Void] makes a stack.
    @State private var actionStack: [() -> Void] = []
    
    // Function to push an action to the stack
    private func pushAction(_ action: @escaping () -> Void) {
        actionStack.append(action)
    }
    
    // Function to pop and execute the most recent action from the stack
    private func undoLastAction() {
        guard let lastAction = actionStack.popLast() else { return }
        lastAction()
    }
    
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
        
        pushAction {
            playerScores[player] = playerScore // Revert the player's score
            players.add(player) // Add the player back to the list of active players
            playersWhoBanked.removeAll(where: { $0 == player }) // Remove the player from the list of banked players
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        // Renders what round the game is on
                        Text("Round: \(currentRound) out of \(round.roundCounter)")
                            .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                        
                        Spacer().frame(width: 25)
                        
                        // Renders the back button
                        Button(action: {
                            undoLastAction()
                        }) {
                            Label("Undo", systemImage: "arrow.backward.circle")
                            //                            Image(systemName: "arrow.backward.circle")
                        }
                        .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                        //                        .buttonStyle(CustomButtonStyle())
                    }
                    
                    Spacer().frame(height: 50)
                    
                    // Renders the diceRoll
                    Text("Dice roll: \(diceRoll - 1)")
                        .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    
                    Spacer().frame(height: 50)
                    
                    // Renders the game score
                    Text("\(gameScore)").font(.system(size: 75))
                        .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    
                    
                    Spacer().frame(height: 50)
                    
                    // Renders people playing
                    ScrollView(.horizontal ) {
                        HStack(spacing: 20) {
                            ForEach(highestScoringPlayers, id: \.self) { name in
                                Text("\(name): \(playerScores[name] ?? 0)")
                                    .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                                
                                // Check if the player is in the list of players who haven't banked
                                if !playersWhoBanked.contains(name) {
                                    Button(action: {
                                        bankScore(for: name)
                                    }) {
                                        Text("BANK!")
                                        //                                            .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                                            .background(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                                            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
                                            .padding(2.5)
                                            .cornerRadius(25)
                                    }
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
                                    pushAction {
                                        gameScore -= i
                                        diceRoll -= 1
                                    }
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
                                pushAction {
                                    gameScore -= 6
                                    diceRoll -= 1
                                }
                            }) {
                                Text("6")
                            }
                            .buttonStyle(CustomButtonStyle())
                            
                            Button(action: {
                                if diceRoll < 4 {
                                    gameScore += 70
                                    
                                    pushAction {
                                        gameScore -= 70
                                        diceRoll -= 1
                                    }
                                } else {
                                    let previousGameScore = gameScore
                                    let previousDiceRoll = diceRoll
                                    
                                    pushAction {
                                        gameScore = previousGameScore
                                        diceRoll = previousDiceRoll
                                        currentRound -= 1
                                    }
                                    
                                    gameScore = 0
                                    diceRoll = 0
                                }
                                
                                resetRound()
                                diceRoll += 1
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
                                        pushAction {
                                            gameScore -= i
                                            diceRoll -= 1
                                        }
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
                                    pushAction {
                                        gameScore -= i
                                        diceRoll -= 1
                                    }
                                }) {
                                    Text("\(i)")
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                            
                            Button(action: {
                                gameScore = gameScore + gameScore
                                diceRoll += 1
                                pushAction {
                                    gameScore /= 2
                                    diceRoll -= 1
                                }
                            }) {
                                Text("Doubles!")
                            }
                            .buttonStyle(CustomButtonStyle())
                            .disabled(diceRoll < 4)
                            .strikethrough(diceRoll < 4)
                        }
                    }
                    // Changes pages
                    .navigationBarHidden(true)
                    .background(
                        NavigationLink(destination: NavigationView {
                            WinScreen(highestScoringPlayer: highestScoringPlayers.first ?? "", allPlayers: players.names) // Pass array of all players
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
