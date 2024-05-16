import SwiftUI
import ConfettiSwiftUI

struct WinScreen: View {
    let highestScoringPlayer: String
    let allPlayers: [String]
    
    @State private var counter = 0
    
    var body: some View {
        ZStack {
            Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "trophy")
                    .foregroundColor(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    .font(.system(size: 125))
                
                Spacer().frame(height: 75)
                
                // Display all players
                ForEach(allPlayers, id: \.self) { player in
                    if player == highestScoringPlayer {
                        Text("Winner: \(player)!")
                            .foregroundColor(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .font(.largeTitle)
                    } else {
                        Text(player)
                            .foregroundColor(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    }
                    
                }
                // Display Play Again button
                NavigationLink(destination: StartingView().navigationBarBackButtonHidden(true)) {
                    Text("Play Again")
                }.buttonStyle(CustomButtonStyle())
            }
            
            .confettiCannon(counter: $counter, num: 250, rainHeight: 500.0, radius: 500.0)
            .onAppear() {
                counter += 1
            }
        }
    }
}
