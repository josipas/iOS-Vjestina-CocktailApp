
import UIKit


class HomeViewController: UIViewController {
    private var router: AppRouterProtocol!
    private var firstLabel: UILabel!
    private var secondLabel: UILabel!
    private var collectionView: UICollectionView!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        setUpNavBar()
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        firstLabel = UILabel()
        secondLabel = UILabel()

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.delegate = self
        //collectionView.dataSource = self
        //collectionView.register(MoviePictureCollectionViewCell.self, forCellWithReuseIdentifier: MoviePictureCollectionViewCell.reuseIdentifier)
    }

    private func addSubviews() {
        view.addSubview(firstLabel)
        view.addSubview(secondLabel)
        view.addSubview(collectionView)
    }

    private func styleViews() {
        view.backgroundColor = .white

        firstLabel.text = "Pick your drink!"
        firstLabel.textColor = UIColor(hex: "#f54242")
        firstLabel.font = UIFont.italicSystemFont(ofSize: 20, weight: .light)

        secondLabel.text = "It's cocktail o'clock!"
        secondLabel.textColor = UIColor(hex: "#f54242")
        secondLabel.font = UIFont.italicSystemFont(ofSize: 20, weight: .light)

        collectionView.backgroundColor = UIColor(hex: "#f54242")
    }

    private func addConstraints() {
        firstLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(firstLabel.snp.leading).offset(30)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(firstLabel.snp.bottom).offset(5)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }

    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 28, weight: .ultraLight)

        navigationBarImageView.frame = CGRect(x: 0, y: 0, width: 145, height: 35)

        self.navigationItem.titleView = navigationBarImageView
    }
}

extension HomeViewController: UICollectionViewDelegate {

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let collectionWidth = collectionView.frame.width
        let itemDimension = (collectionWidth - 2*18) / 3

        return CGSize(width: itemDimension, height: itemDimension)
    }
}



