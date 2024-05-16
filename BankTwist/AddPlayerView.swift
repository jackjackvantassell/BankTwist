import SwiftUI

struct AddPlayerView: View {
    @State private var newName: String = ""
    @EnvironmentObject var nameList: NameList
    
    @State private var showingAlert = false
    @State private var showPlayGameAlert = false // New state variable
    @State private var showDuplicateNameAlert = false // New state variable
    @State private var isNavigationActive = false // State to control navigation
    
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
                            if !nameList.names.contains(newName) {
                                // Add the new name to the list if it's not a duplicate
                                nameList.names.append(newName)
                                // Clear the text field
                                newName = ""
                            } else {
                                // Show an alert indicating that the name already exists
                                showDuplicateNameAlert = true
                            }
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
                        .alert(isPresented: $showDuplicateNameAlert) {
                            Alert(title: Text("Error"), message: Text("Name already exists"), dismissButton: .default(Text("OK")))
                        }
                    
                    List {
                        ForEach(nameList.names, id: \.self) { name in
                            HStack {
                                Text(name)
                                
                                Spacer()
                                
                                Button(action: {
                                    // Delete the name from the list
                                    if let index = nameList.names.firstIndex(of: name) {
                                        nameList.names.remove(at: index)
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
                    
                    NavigationLink(destination: GameScreenView().navigationBarBackButtonHidden(true), isActive: $isNavigationActive) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        if nameList.names.isEmpty {
                            // Show an alert indicating that there must be at least one person to play
                            showPlayGameAlert = true
                        } else {
                            // Navigate to the game screen
                            isNavigationActive = true
                        }
                    }) {
                        Text("Play Game")
                            .padding()
                            .background(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
                            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
                            .cornerRadius(10)
                    }
                    .alert(isPresented: $showPlayGameAlert) {
                        Alert(title: Text("Error"), message: Text("You have to have at least one person to play"), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
}
