import UIKit


class FavoritesViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var collectionView: UICollectionView!
    private var favorites: [DrinkFilter] = []

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        buildViews()
        setUpNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getFavorites()
    }

    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.favorites = favorites

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func buildViews() {
        createViews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.reuseIdentifier)

        view.addSubview(collectionView)
    }

    private func styleViews() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
    }

    private func addConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App Favorites"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 20)

        self.navigationItem.titleView = navigationBarImageView
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.reuseIdentifier, for: indexPath) as? FavoritesCollectionViewCell
        else {
            fatalError()
        }

        let drinkFilter = favorites[indexPath.row]
        cell.set(drink: drinkFilter, isFavorite: true)

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idDrink = favorites[indexPath.row].idDrink
        router.showDetailsViewControllerFromFavorites(idDrink: idDrink)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let itemWidth = (collectionWidth - 2*16) / 3

        let collectionHeight = collectionView.frame.height
        let itemHeight = collectionHeight / 5

        return CGSize(width: itemWidth, height: itemHeight)
    }
}

