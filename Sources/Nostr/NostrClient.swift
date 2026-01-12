import Foundation

/// Lightweight Nostr client skeleton.
/// TODO: Replace placeholders with secure signing using secp256k1 and full event handling.
import Combine

public final class NostrClient: NSObject, ObservableObject {
    private var url: URL
    private var webSocketTask: URLSessionWebSocketTask?

    @Published public private(set) var events: [NostrEvent] = []

    public init(relayURL: URL) {
        self.url = relayURL
        super.init()
    }

    public func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        listen()
    }

    public func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }

    private func listen() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    self?.handleIncomingData(data)
                case .string(let text):
                    if let data = text.data(using: .utf8) {
                        self?.handleIncomingData(data)
                    }
                @unknown default:
                    break
                }
            case .failure(let error):
                print("WebSocket error: \(error)")
            }
            // Continue listening
            self?.listen()
        }
    }

    private func handleIncomingData(_ data: Data) {
        // Nostr relays typically send arrays like ["EVENT", { eventJSON }]
        // We'll try to decode either an array container or a single event object
        do {
            // try decode as array first
            let any = try JSONSerialization.jsonObject(with: data, options: [])
            if let arr = any as? [Any], arr.count >= 2 {
                // second element may be the event object
                if let eventObj = arr[1] as? [String: Any], let eventData = try? JSONSerialization.data(withJSONObject: eventObj) {
                    let event = try JSONDecoder().decode(NostrEvent.self, from: eventData)
                    DispatchQueue.main.async { self.events.append(event) }
                }
            } else if let obj = any as? [String: Any], let eventData = try? JSONSerialization.data(withJSONObject: obj) {
                let event = try JSONDecoder().decode(NostrEvent.self, from: eventData)
                DispatchQueue.main.async { self.events.append(event) }
            }
        } catch {
            print("Nostr parse error: \(error)")
        }
    }

    public func send(eventJSON: String) {
        webSocketTask?.send(.string(eventJSON)) { error in
            if let e = error { print("Send error: \(e)") }
        }
    }

    // Signing uses WalletManager to sign Nostr events. Keep this as a thin adapter so real secp256k1 implementation can be injected.
    public func signEvent(withPrivateKeyHex hex: String, event: NostrEvent) -> String {
        return WalletManager.shared.signNostrEvent(event: event, hexPrivateKey: hex)
    }
}
