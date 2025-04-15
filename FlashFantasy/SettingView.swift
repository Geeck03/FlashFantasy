import SwiftUI

struct SettingView: View {
    @State private var fbg: Double = 1.0

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.custom("Papyrus", size: 48))
                .fontWeight(.bold)
                .padding()

            VStack {
                Text("Flashcards Between Games: \(Int(fbg))")

                ZStack {
                    Slider(value: $fbg, in: 1...20, step: 1)
                        .padding()

                    GeometryReader { geometry in
                        let sliderWidth = geometry.size.width - 32 // adjust for padding
                        let knobPosition = (sliderWidth) * CGFloat((fbg - 1) / 19)

                        Text("🐲") // or any emoji/symbol you like
                            .font(.system(size: 24))
                            .offset(x: knobPosition)
                            .padding(.top, 6)
                    }
                    .frame(height: 44)
                }
            }
            .font(.custom("Papyrus", size: 20))
        }
    }
}
