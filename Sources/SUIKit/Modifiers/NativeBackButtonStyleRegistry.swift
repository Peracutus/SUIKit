import UIKit

/// Leases are shared by adjacent destinations because UIKit gets the Back
/// button's title from the previous item, not from the visible item.
@MainActor
final class NativeBackButtonStyleRegistry {
    static let shared = NativeBackButtonStyleRegistry()

    private struct Owner {
        let modeItems: Set<ObjectIdentifier>
        let appearanceItem: ObjectIdentifier?
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
    private var appearances: [ObjectIdentifier: NativeBackButtonAppearance] = [:]

    func update(owner: UUID, host: UIViewController, navigationController: UINavigationController, tint: UIColor) {
        guard let index = navigationController.viewControllers.firstIndex(where: { $0 === host }) else { return }
        let item = host.navigationItem
        var items = [item]
        if index > 0 {
            items.append(navigationController.viewControllers[index - 1].navigationItem)
        }
        let desiredModes = Set(items.map(ObjectIdentifier.init))
        let desiredAppearance = index > 0 ? ObjectIdentifier(item) : nil
        if let old = owners[owner] {
            releaseModes(old.modeItems.subtracting(desiredModes), owner: owner)
            if old.appearanceItem != desiredAppearance, let oldAppearance = old.appearanceItem {
                releaseAppearance(oldAppearance, owner: owner)
            }
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
        if let id = desiredAppearance {
            let appearance = appearances[id] ?? NativeBackButtonAppearance(item: item)
            appearance.owners.insert(owner)
            appearances[id] = appearance
            appearance.apply(tint: tint, navigationBar: navigationController.navigationBar)
        }
        owners[owner] = Owner(modeItems: desiredModes, appearanceItem: desiredAppearance)
    }

    func release(owner: UUID) {
        guard let old = owners.removeValue(forKey: owner) else { return }
        releaseModes(old.modeItems, owner: owner)
        if let id = old.appearanceItem {
            releaseAppearance(id, owner: owner)
        }
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

    private func releaseAppearance(_ id: ObjectIdentifier, owner: UUID) {
        guard let appearance = appearances[id] else { return }
        appearance.owners.remove(owner)
        if appearance.owners.isEmpty {
            appearance.restore()
            appearances.removeValue(forKey: id)
        }
    }
}
