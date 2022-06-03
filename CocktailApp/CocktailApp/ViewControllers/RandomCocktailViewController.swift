import UIKit
import SnapKit
import RandomColor

class RandomCocktailViewController: UIViewController {
    
    
    private var name: UILabel!
    private var image: UIImageView!
    private var drink: Drink!
    private var tryAgainButton: UIButton!
    private var tryAgainLabel: UILabel!
    private var detailButton: UIButton!
    private var detailsLabel: UILabel!
    
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol) {
            self.init()
            self.router = router
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        let networkService = NetworkService()
        networkService.getRandomDrink() { result in
            switch result {
            case .success(let value):
                self.drink = value
                DispatchQueue.main.async {
                    self.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        buildViews()
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
        setUpNavBar()
    }
    
    private func createViews() {
        name = UILabel()
        view.addSubview(name)
        
        
        image = UIImageView()
        view.addSubview(image)
        
        tryAgainButton = UIButton()
        view.addSubview(tryAgainButton)
        tryAgainButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        
        tryAgainLabel = UILabel()
        view.addSubview(tryAgainLabel)
        
        detailButton = UIButton()
        view.addSubview(detailButton)
        detailButton.addTarget(self, action: #selector(getDetails), for: .touchUpInside)
        
        detailsLabel = UILabel()
        view.addSubview(detailsLabel)

    }
    
    @objc func tryAgain(sender: UIButton!){
        let networkService = NetworkService()
        networkService.getRandomDrink() { result in
            switch result {
            case .success(let value):
                self.drink = value
                DispatchQueue.main.async {
                    self.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func getDetails(sender: UIButton!) {
        router.showRandomDetailsViewController(idDrink: drink.idDrink)
    }
    
    private func styleViews() {
        overrideUserInterfaceStyle = .light

        name.font = .systemFont(ofSize: 24, weight: .bold)
        name.textAlignment = .center
        name.numberOfLines = 0

        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 60)

        let again = UIImage(systemName: "repeat.circle.fill", withConfiguration: config)
        tryAgainButton.setImage(again, for: .normal)
        tryAgainButton.tintColor = UIColor(hex: "#b88dbe")
        
        tryAgainLabel.text = "Try again"
        
        let details = UIImage(systemName: "questionmark.circle.fill", withConfiguration: config)
        detailButton.setImage(details, for: .normal)
        detailButton.tintColor = UIColor(hex: "#b88dbe")
        
        detailsLabel.text = "Show details"
                
    }
    
    private func defineLayoutForViews() {
        name.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.top.equalTo(image.snp.bottom).offset(10)
        }

        image.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height / 2)
        }
        
        tryAgainButton.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(90)
            $0.height.equalTo(60)
            $0.width.equalTo(60)

        }
        
        tryAgainLabel.snp.makeConstraints {
            $0.top.equalTo(tryAgainButton.snp.bottom).offset(0)
            $0.leading.equalToSuperview().inset(85)
        }
        
        detailButton.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(90)
            $0.height.equalTo(60)
            $0.width.equalTo(60)

        }
        
        detailsLabel.snp.makeConstraints {
            $0.top.equalTo(detailButton.snp.bottom).offset(0)
            $0.trailing.equalToSuperview().inset(70)
        }
        
    }
    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 20)

        self.navigationItem.titleView = navigationBarImageView
    }
    
    private func reloadData() {
        name.text = drink.strDrink
        image.load(urlString: drink.strDrinkThumb)
    }
}
