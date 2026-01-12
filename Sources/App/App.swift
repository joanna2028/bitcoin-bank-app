import SwiftUI

@main
struct BitcoinBankAppApp: App {
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasOnboarded {
                ContentView()
            } else {
                NavigationStack {
                    OnboardingView()
                }
            }
        }
    }
}
