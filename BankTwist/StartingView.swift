import SwiftUI

struct StartingView: View {
    @EnvironmentObject var round: Round
    @State private var isAddingPlayer = false
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("BANK!")
                            .font(.largeTitle)
                            .foregroundStyle(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .padding(.top)
                    }
                    Spacer().frame(height: 200)
                    
                    // Button to initiate adding player
                    NavigationLink(destination: AddPlayerView().navigationBarBackButtonHidden(true), isActive: $isAddingPlayer) {
                        Text("Play")
                    }
                    .disabled(round.roundCounter == 0)
                    .buttonStyle(CustomButtonStyle())
                    .onTapGesture {
                        if round.roundCounter == 0 {
                            // Show error message
                            errorMessage = "Please set a maximum number of rounds."
                            showingAlert = true
                        } else {
                            // Navigate to AddPlayerView
                            isAddingPlayer = true
                        }
                    }
                    
                    Text("\(round.roundCounter)")
                        .foregroundColor(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                    
                    // Buttons to set round counter
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
        }
        // Error popup
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
