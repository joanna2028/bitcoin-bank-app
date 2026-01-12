import SwiftUI

import LocalAuthentication

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: WalletView()) {
                    Label("Wallet", systemImage: "wallet.pass")
                }
                NavigationLink(destination: NostrView()) {
                    Label("Nostr", systemImage: "paperplane")
                }
                NavigationLink(destination: NostrPayView()) {
                    Label("Nostr Pay", systemImage: "dollarsign.circle")
                }
                NavigationLink(destination: LightningView()) {
                    Label("Lightning", systemImage: "bolt.horizontal")
                }
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .tint(.accentColor)
            .navigationTitle("Bitcoin Bank")
            Text("Select a screen")
        }
        .accentColor(Color("AccentViolet"))
    }
}

struct SettingsView: View {
    @State private var biometricEnabled = true

    var body: some View {
        Form {
            Section(header: Text("Security")) {
                Toggle(isOn: $biometricEnabled) {
                    Label("Require biometric unlock", systemImage: "faceid")
                }
            }
            Section(header: Text("Nostr")) {
                NavigationLink(destination: NostrSettingsView()) {
                    Text("Relay & Pay Request Settings")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

struct NostrSettingsView: View {
    @State private var relayURL: String = "wss://nostr.example.org"

    var body: some View {
        Form {
            Section(header: Text("Relay")) {
                TextField("Relay URL", text: $relayURL)
            }
        }
        .navigationTitle("Nostr")
    }
}

struct WalletView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Wallet")
            Text("(Create / Import / Send / Receive)")
        }
        .navigationTitle("Wallet")
    }
}

struct NostrView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Nostr")
            Text("(Relays, Events, Pay Requests)")
        }
        .navigationTitle("Nostr")
    }
}

struct LightningView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Lightning")
            Text("(Invoices, Channels)")
        }
        .navigationTitle("Lightning")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
