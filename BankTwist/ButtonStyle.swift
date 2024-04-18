import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 252.0/255.0, green: 194.0/255.0, blue: 0))
            .foregroundColor(Color(red: 29.0/255.0, green: 90.0/255.0, blue: 137.0/255.0))
            .cornerRadius(10)
    }
}
