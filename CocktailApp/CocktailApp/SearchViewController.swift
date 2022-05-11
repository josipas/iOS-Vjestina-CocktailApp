import UIKit


class SearchViewController: UIViewController {
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .yellow
    }
}

