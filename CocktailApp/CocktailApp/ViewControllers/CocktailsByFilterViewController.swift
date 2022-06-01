import UIKit

class CocktailsByFilterViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var string: String!
    private var filter: Filters!
    private var drinks: [DrinkFilters] = []

    private let networkService: NetworkServiceProtocol = NetworkService()

    convenience init(router: AppRouterProtocol, string: String, filter: Filters) {
        self.init()
        self.router = router
        self.string = string
        self.filter = filter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        getData()
        buildViews()
    }

    private func getData() {
        switch filter {
        case .ingredient:
            networkService.getDrinksByFilter(filter: .ingredient, string: string) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let drinks):
                    print(drinks)
                case .failure(let error):
                    print(error)
                }
            }
        case .category:
            networkService.getDrinksByFilter(filter: .category, string: string) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let drinks):
                    print(drinks)
                case .failure(let error):
                    print(error)
                }
            }
        case .none:
            ()
        }
    }

    private func buildViews() {

    }
}
