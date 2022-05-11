import UIKit


class FavoritesViewController: UIViewController {
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
}

