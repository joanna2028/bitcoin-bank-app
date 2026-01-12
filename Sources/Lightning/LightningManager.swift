import Foundation

/// Lightning interface skeleton.
/// Options:
/// - Embedded mobile node (lnd-mobile) -> more privacy, more complexity
/// - Remote non-custodial node connection (gRPC / REST) -> simpler UX, requires remote node support
/// For MVP we'll provide an interface and allow integration of lnd-mobile or other implementation later.
public protocol LightningProvider {
    func start()
    func stop()
    func createInvoice(msats: UInt64, memo: String?) async throws -> String
    func payInvoice(bolt11: String) async throws -> String // return payment hash
}

public final class LightningManager {
    public static let shared = LightningManager()
    private init() {}

    public var provider: LightningProvider?

    public func start() {
        provider?.start()
    }

    public func stop() {
        provider?.stop()
    }
}
