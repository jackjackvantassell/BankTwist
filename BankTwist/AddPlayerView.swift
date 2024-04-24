import SwiftUI

struct AddPlayerView: View {
    @State private var newName: String = ""
    @EnvironmentObject var nameList: NameList
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    TextField("Enter a name", text: $newName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .cornerRadius(10)
                    
                    Button(action: {
                        if !newName.isEmpty {
                            // Add the new name to the list
                            nameList.names.append(newName)
                            // Clear the text field
                            newName = ""
                        } else {
                            // Show an alert indicating that the name cannot be blank
                            showingAlert = true
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
                            .cornerRadius(10)
                    }.padding(5)
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Error"), message: Text("Please enter a name"), dismissButton: .default(Text("OK")))
                        }
                    
                    List {
                        ForEach(nameList.names, id: \.self) { name in // Corrected reference to names array
                            HStack {
                                Text(name)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Delete the name from the list
                                    if let index = nameList.names.firstIndex(of: name) { // Corrected reference to names array
                                        nameList.names.remove(at: index) // Corrected reference to names array
                                    }
                                }) {
                                    // Add trash image
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .cornerRadius(10)
                    .padding()
                    NavigationLink(destination: NavigationView { GameScreenView() }.navigationBarHidden(true)) {
                        Text("Play Game")
                            .padding()
                            .background(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
                            .cornerRadius(10)
                        
                    }
                }
            }
        }
    }
}
