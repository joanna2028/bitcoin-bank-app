import SwiftUI

struct NostrPayView: View {
    @StateObject private var client = NostrClient(relayURL: URL(string: "wss://nostr.example.org")!)
    @State private var selectedEvent: String?

    var body: some View {
        VStack {
            HStack {
                Text("Nostr Pay Requests")
                    .font(.title2)
                    .foregroundColor(Color("AccentViolet"))
                Spacer()
                Button(action: { client.connect() }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
            .padding()

            List(client.events.reversed()) { event in
                Button(action: { selectedEvent = event }) {
                    VStack(alignment: .leading) {
                        Text(event.content.prefix(100) + "...")
                            .font(.body)
                        if let invoice = event.findLightningInvoice() {
                            Text("Invoice: " + invoice.prefix(32) + "...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Tap to view")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Nostr Pay")
        .sheet(item: $selectedEvent, content: { event in
            NostrEventDetailView(eventJSON: event)
        })
    }
}

struct NostrEventDetailView: View, Identifiable {
    public var id: String { eventJSON }
    let eventJSON: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Nostr Event")
                .font(.headline)
                .foregroundColor(Color("AccentViolet"))
            ScrollView {
                Text(eventJSON)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            Button(action: { /* TODO: Parse invoice and pay via LightningManager */ }) {
                Text("Pay / Open Invoice")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("AccentViolet"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct NostrPayView_Previews: PreviewProvider {
    static var previews: some View {
        NostrPayView()
    }
}