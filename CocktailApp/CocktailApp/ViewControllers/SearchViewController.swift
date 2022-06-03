import UIKit
import SnapKit
import RandomColor

class SearchViewController: UIViewController {
    private var searchBar: SearchBarView!
    private var drinks: [Drink] = []
    private var collectionList: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {

        view.backgroundColor = .white
        let networkService = NetworkService()
        networkService.getDrinksByName(string: "t") { result in
            switch result {
            case .success(let value):
                self.drinks = value
                print(value.count)
                DispatchQueue.main.async {
                    self.collectionList.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        buildViews()
    }
    
    private func buildViews(){
        createViews()
        styleViews()
        defineLayoutForViews()
        configureCollectionView()
        setUpNavBar()
    }
    
    private func createViews(){
        
        searchBar = SearchBarView()
        searchBar.delegateFilter = self
        view.addSubview(searchBar)
        
        layout = UICollectionViewFlowLayout()

        collectionList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionList)
    }
    
    private func styleViews(){
        overrideUserInterfaceStyle = .light
        layout.minimumInteritemSpacing = 10
    }
    
    private func defineLayoutForViews(){
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.height.equalTo(45)
        }
        
        collectionList.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() {
        collectionList.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        collectionList.dataSource = self
        collectionList.delegate = self
    }
    
    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 20)

        self.navigationItem.titleView = navigationBarImageView
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        return CGSize(width: collectionViewWidth - 2 * 10, height: 100)
    }
}

extension SearchViewController: UICollectionViewDataSource {

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
        cell.set(strDrink: searchData.strDrink, strCategory: searchData.strCategory, strAlcoholic: searchData.strAlcoholic, strDrinkThumb: searchData.strDrinkThumb)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idDrink = drinks[indexPath.row].idDrink
        router.showDetailsViewControllerFromSearch(idDrink: idDrink)
    }
}

extension SearchViewController: SearchFilterDelegate {
    
    func filter(text: String) {
        let networkService = NetworkService()
        networkService.getDrinksByName(string: text) { result in
            switch result {
            case .success(let value):
                self.drinks = value
                print(value.count)
                DispatchQueue.main.async {
                    self.collectionList.reloadData()
                }
            case .failure(let error):
                print(error)
                self.drinks = []
                DispatchQueue.main.async {
                    self.collectionList.reloadData()
                }
            }
        }
    }
}

