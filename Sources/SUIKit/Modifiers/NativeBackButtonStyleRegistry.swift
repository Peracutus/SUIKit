import UIKit

/// Leases are shared by adjacent destinations because UIKit gets the Back
/// button's title from the previous item, not from the visible item.
@MainActor
final class NativeBackButtonStyleRegistry {
    static let shared = NativeBackButtonStyleRegistry()

    private struct Owner {
        let modeItems: Set<ObjectIdentifier>
    }

    @MainActor
    private final class ModeLease {
        weak var item: UINavigationItem?
        let original: UINavigationItem.BackButtonDisplayMode
        var owners: Set<UUID> = []

        init(item: UINavigationItem) {
            self.item = item
            original = item.backButtonDisplayMode
        }

        func restore() {
            guard let item, item.backButtonDisplayMode == .minimal else { return }
            item.backButtonDisplayMode = original
        }
    }

    private var owners: [UUID: Owner] = [:]
    private var modes: [ObjectIdentifier: ModeLease] = [:]
    func update(owner: UUID, host: UIViewController, navigationController: UINavigationController) {
        guard let index = navigationController.viewControllers.firstIndex(where: { $0 === host }) else { return }
        let item = host.navigationItem
        var items = [item]
        if index > 0 {
            items.append(navigationController.viewControllers[index - 1].navigationItem)
        }
        let desiredModes = Set(items.map(ObjectIdentifier.init))
        if let old = owners[owner] {
            releaseModes(old.modeItems.subtracting(desiredModes), owner: owner)
        }

        for item in items {
            let id = ObjectIdentifier(item)
            let lease = modes[id] ?? ModeLease(item: item)
            lease.owners.insert(owner)
            modes[id] = lease
            if item.backButtonDisplayMode != .minimal {
                item.backButtonDisplayMode = .minimal
            }
        }
        // UIKit owns the indicator and its Liquid Glass geometry. Only hide the
        // previous destination's title; do not clone or offset its image/mask.
        owners[owner] = Owner(modeItems: desiredModes)
    }

    func release(owner: UUID) {
        guard let old = owners.removeValue(forKey: owner) else { return }
        releaseModes(old.modeItems, owner: owner)
    }

    private func releaseModes(_ ids: Set<ObjectIdentifier>, owner: UUID) {
        for id in ids {
            guard let lease = modes[id] else { continue }
            lease.owners.remove(owner)
            if lease.owners.isEmpty {
                lease.restore()
                modes.removeValue(forKey: id)
            }
        }
    }

}
