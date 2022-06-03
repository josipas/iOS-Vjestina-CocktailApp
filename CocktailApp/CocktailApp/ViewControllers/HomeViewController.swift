import UIKit

class HomeViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var tableView: UITableView!

    private var filters: [Filters] = Filters.allCases
    private var ingredients: [Ingredient] = []
    private var categories: [Category] = []

    private let networkService: NetworkServiceProtocol = NetworkService()

    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        setUpNavBar()
        getData()
    }

    private func getData() {
        networkService.getListOfAllIngredients { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let ingredients):
                self.ingredients = ingredients
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

        networkService.getListOfAllCategories { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let categories):
                self.categories = categories
                print(categories)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func styleViews() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
    }

    private func addConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 20)

        self.navigationItem.titleView = navigationBarImageView
    }
}

extension HomeViewController: UITableViewDelegate {

}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        filters.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard
                let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: HomeTableViewCell.reuseIdentifier,
                        for: indexPath) as? HomeTableViewCell
            else {
                fatalError()
            }

            cell.selectionStyle = .none
            cell.delegate = self
            cell.set(firstText: "Pick your base!", secondText: "Start cocktail adventure! 🥂", filter: .ingredient)

            return cell
        } else {
            guard
                let cell = tableView
                    .dequeueReusableCell(
                        withIdentifier: HomeTableViewCell.reuseIdentifier,
                        for: indexPath) as? HomeTableViewCell
            else {
                fatalError()
            }

            cell.selectionStyle = .none
            cell.delegate = self
            cell.set(firstText: "Pick category", secondText: "🍺🍸🍹☕️", filter: .category)

            return cell
        }
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func didSelectItem(for filter: Filters, at indexPath: IndexPath) {
        switch filter {
        case .ingredient:
            router.showDrinksByFilterViewController(for: filter, name: ingredients[indexPath.row].strIngredient1)
        case .category:
            router.showDrinksByFilterViewController(for: filter, name: categories[indexPath.row].strCategory)
        }
    }

    func getItemCount(for filter: Filters) -> Int {
        switch filter {
        case .ingredient:
            return ingredients.count
        case .category:
            return categories.count
        }
    }

    func getItemTitle(for filter: Filters, at indexPath: IndexPath) -> String {
        switch filter {
        case .ingredient:
            return ingredients[indexPath.row].strIngredient1
        case .category:
            return categories[indexPath.row].strCategory
        }
    }
}



