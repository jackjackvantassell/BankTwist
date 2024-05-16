import SwiftUI

class Round: ObservableObject {
    @Published var roundCounter = 0
}

class NameList: ObservableObject {
    @Published var names: [String] = []
    
    init(names: [String] = []) {
        self.names = names
    }
    
    func remove(_ name: String) {
        names.removeAll { $0 == name }
    }
    
    func add(_ name: String) {
        names.append(name)
    }
}

//class PlayerScore: ObservableObject {
//    @Published var score = 0
//}

@main
struct BankTwistApp: App {
    let round = Round() // Assuming you still need this environment object
    
    var body: some Scene {
        WindowGroup {
            StartingView()
                .environmentObject(round)
                .environmentObject(NameList()) // Inject NameList here
        }
    }
}

