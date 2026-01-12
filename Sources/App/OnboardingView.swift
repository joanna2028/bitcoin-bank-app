import SwiftUI
import LocalAuthentication

struct OnboardingView: View {
    @State private var mnemonic: String = ""
    @State private var showMnemonic = false
    @State private var useBiometrics = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Bitcoin Bank")
                .font(.title)
                .foregroundColor(Color("AccentViolet"))

            Text("Non-custodial, Lightning-ready, Nostr-enabled")
                .font(.subheadline)
                .multilineTextAlignment(.center)

            Button(action: createWallet) {
                Text("Create a new wallet")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentViolet"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: importWallet) {
                Text("Import wallet (mnemonic)")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("AccentViolet"), lineWidth: 1))
            }

            Toggle(isOn: $useBiometrics) {
                Text("Enable biometric unlock (recommended)")
            }
            .padding()

            if showMnemonic {
                TextEditor(text: $mnemonic)
                    .frame(height: 140)
                    .border(Color.gray)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Get started")
    }

    private func createWallet() {
        // TODO: generate mnemonic using WalletManager
        // TODO: store seed encrypted in Keychain + Secure Enclave and enable biometric unlock via LAContext
        showMnemonic = true
        mnemonic = "abandon abandon ..." // placeholder
    }

    private func importWallet() {
        // navigate to a mnemonic import flow (not implemented)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}