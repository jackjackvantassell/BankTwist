import SwiftUI

struct ContentView: View {
    @EnvironmentObject var round: Round
    @State private var isAddingPlayer = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("B\(Image(systemName: "building.columns.fill"))NK")
                            .font(.largeTitle)
                            .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .padding(.top)
                    }
                    Spacer().frame(height: 200)
                    NavigationLink(destination: AddPlayerView().navigationBarBackButtonHidden(true), isActive: $isAddingPlayer) {
                        Text("Play")
                    }.buttonStyle(CustomButtonStyle())
                    
                    Text("\(round.roundCounter)")
                        .foregroundColor(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    HStack {
                        Button(action: { round.roundCounter = 10 }) {
                            Text("10 rounds")
                        }.buttonStyle(CustomButtonStyle())
                        Button(action: { round.roundCounter = 15 }) {
                            Text("15 rounds")
                        }.buttonStyle(CustomButtonStyle())
                        Button(action: { round.roundCounter = 20 }) {
                            Text("20 rounds")
                        }.buttonStyle(CustomButtonStyle())
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}
