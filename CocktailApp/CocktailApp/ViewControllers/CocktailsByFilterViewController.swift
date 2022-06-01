import UIKit

class CocktailsByFilterViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var collectionView: UICollectionView!

    private var string: String!
    private var filter: Filters!
    private var drinks: [DrinkFilter] = []

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
        let string = string.replacingOccurrences(of: " ", with: "_")

        switch filter {
        case .ingredient:
            networkService.getDrinksByFilter(filter: .ingredient, string: string) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let drinks):
                    self.drinks = drinks

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .category:
            networkService.getDrinksByFilter(filter: .category, string: string) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let drinks):
                    self.drinks = drinks

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .none:
            ()
        }
    }

    private func buildViews(){
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)


        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }


    func addSubviews() {
        view.addSubview(collectionView)
    }

    private func styleViews() {

    }

    private func addConstraints() {
        collectionView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
}

extension CocktailsByFilterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth - 2 * 16, height: 100)
    }
}

extension CocktailsByFilterViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        drinks.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell
        else {
            fatalError()
        }
        let searchData = drinks[indexPath.row]
        cell.set(strDrink: searchData.strDrink, strCategory: string, strAlcoholic: nil, strDrinkThumb: searchData.strDrinkThumb)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idDrink = drinks[indexPath.row].idDrink
        router.showDetailsViewController(idDrink: idDrink)
    }
}

