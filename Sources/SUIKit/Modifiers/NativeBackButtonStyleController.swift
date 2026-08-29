import UIKit

@MainActor
final class NativeBackButtonStyleController: UIViewController {
    var tint: UIColor
    private let ownerID = UUID()
    private var isStopped = false
    private weak var configuredNavigationController: UINavigationController?

    init(tint: UIColor) {
        self.tint = tint
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { return nil }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.isAccessibilityElement = false
        self.view = view
    }

    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        configureIfAttached()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureIfAttached()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureIfAttached()
    }

    func configureIfAttached() {
        guard !isStopped, let context = navigationContext() else { return }
        configuredNavigationController = context.navigationController
        NativeBackButtonStyleRegistry.shared.update(
            owner: ownerID,
            host: context.host,
            navigationController: context.navigationController,
            tint: tint
        )
    }

    func stop() {
        guard !isStopped else { return }
        isStopped = true
        let owner = ownerID
        // A disappearing screen may still supply the Back item during an
        // interactive transition. Do not restore it halfway through that transition.
        let navigationController = navigationContext()?.navigationController ?? configuredNavigationController
        if let transition = navigationController?.transitionCoordinator,
           transition.animate(alongsideTransition: nil, completion: { _ in
               NativeBackButtonStyleRegistry.shared.release(owner: owner)
           }) {
            return
        }
        NativeBackButtonStyleRegistry.shared.release(owner: owner)
    }

    func navigationContext() -> (host: UIViewController, navigationController: UINavigationController)? {
        var ancestor = parent
        while let candidate = ancestor {
            if let navigationController = candidate.navigationController,
               navigationController.viewControllers.contains(where: { $0 === candidate }) {
                return (candidate, navigationController)
            }
            ancestor = candidate.parent
        }
        return nil
    }
}
