import UIKit
import SnapKit
import RandomColor

class CocktailDetailsViewController: UIViewController {
    
    private var name: UILabel!
    private var instructionsTitle: UILabel!
    private var instructions: UILabel!
    private var image: UIImageView!
    private var ingredientsTitle: UILabel!
    private var ingredients: UILabel!
    private var drink: Drink!
    private var category: UILabel!
    private var categoryText: UILabel!
    private var alcoholic: UILabel!
    private var heart: UIImage!
    private var heartFill: UIImage!
    private var favorites: UIImageView!
    private var idDrink: String!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var scrollViewContainer: UIStackView!

    private var allFavorites: [DrinkFilter] = []
    
    private var router: AppRouterProtocol!

    convenience init(router: AppRouterProtocol, idDrink: String) {
        self.init()
        self.router = router
        self.idDrink = idDrink
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        let networkService = NetworkService()
        networkService.getDrinkDetails(string: idDrink) { result in
            switch result {
            case .success(let value):
                self.drink = value
                DispatchQueue.main.async {
                    self.reloadData()
                    self.getFavorites()
                }
            case .failure(let error):
                print(error)
            }
        }
        buildViews()
    }

    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                self.allFavorites = favorites
                let drinkFilter = DrinkFilter(strDrink: self.drink.strDrink, strDrinkThumb: self.drink.strDrinkThumb, idDrink: self.drink.idDrink)
                if self.allFavorites.contains(where: {
                    $0.idDrink == drinkFilter.idDrink
                }) {
                    DispatchQueue.main.async {
                        self.favorites.image = self.heartFill
                    }
                }
                print(favorites)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
        setUpNavBar()
    }
    
    private func createViews() {
        scrollView = UIScrollView()
        scrollView.canCancelContentTouches = true
        scrollView.delaysContentTouches = true
        view.addSubview(scrollView)
        
        contentView = UIView()
        scrollView.addSubview(contentView)
        
        scrollViewContainer = UIStackView()
        scrollViewContainer.axis = .vertical

        contentView.addSubview(scrollViewContainer)
        
        name = UILabel()
        scrollViewContainer.addSubview(name)

        instructions = UILabel()
        scrollViewContainer.addSubview(instructions)

        instructionsTitle = UILabel()
        scrollViewContainer.addSubview(instructionsTitle)

        image = UIImageView()
        scrollViewContainer.addSubview(image)

        ingredients = UILabel()
        scrollViewContainer.addSubview(ingredients)

        ingredientsTitle = UILabel()
        scrollViewContainer.addSubview(ingredientsTitle)

        category = UILabel()
        scrollViewContainer.addSubview(category)

        categoryText = UILabel()
        scrollViewContainer.addSubview(categoryText)

        alcoholic = UILabel()
        scrollViewContainer.addSubview(alcoholic)

        heart = UIImage(systemName: "heart")
        heartFill = UIImage(systemName: "heart.fill")
        
        favorites = UIImageView()
        favorites.image = heart
        favorites.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateFavorites)))
        favorites.isUserInteractionEnabled = true
        scrollView.addSubview(favorites)
    }

    
    private func styleViews() {
        overrideUserInterfaceStyle = .light

        self.navigationController?.navigationBar.tintColor = .white
        
        name.font = .systemFont(ofSize: 30, weight: .bold)
        name.numberOfLines = 0

        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
                
        instructions.font = .systemFont(ofSize: 16)
        instructions.numberOfLines = 0

        instructionsTitle.font = .systemFont(ofSize: 22, weight: .bold)
        instructionsTitle.text = "Instructions:"

        ingredients.font = .systemFont(ofSize: 16)
        ingredients.numberOfLines = 0

        ingredientsTitle.font = .systemFont(ofSize: 22, weight: .bold)
        ingredientsTitle.text = "Ingredients:"

        favorites.tintColor = UIColor(hex: "#b88dbe")
        
        categoryText.font = .systemFont(ofSize: 22, weight: .bold)
        categoryText.text = "Category:"
    }
    
    private func defineLayoutForViews() {
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollViewContainer.snp.makeConstraints {
            $0.leading.equalTo(scrollView.snp.leading)
            $0.top.equalTo(scrollView.snp.top)
            $0.trailing.equalTo(scrollView.snp.trailing)
        }
        
        image.snp.makeConstraints{
            $0.top.equalTo(scrollViewContainer.snp.top).inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
        
        name.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(95)
            $0.top.equalTo(image.snp.bottom).offset(10)
        }
        alcoholic.snp.makeConstraints{
            $0.top.equalTo(name.snp.bottom).offset(0)
            $0.leading.equalToSuperview().inset(30)
            $0.trailing.equalToSuperview().inset(95)
        }
          
        favorites.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(40)
            $0.leading.equalTo(name.snp.trailing).offset(10)
            $0.top.equalTo(image.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        
        categoryText.snp.makeConstraints{
            $0.top.equalTo(alcoholic.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(20)
        }

        category.snp.makeConstraints{
            $0.top.equalTo(categoryText.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
            
        instructionsTitle.snp.makeConstraints{
            $0.top.equalTo(category.snp.bottom).offset(10)
            $0.trailing.leading.equalToSuperview().inset(20)
        }

        instructions.snp.makeConstraints{
            $0.top.equalTo(instructionsTitle.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(20)
        }

        ingredientsTitle.snp.makeConstraints{
            $0.top.equalTo(instructions.snp.bottom).offset(10)
            $0.trailing.leading.equalToSuperview().inset(20)
        }

        ingredients.snp.makeConstraints{
            $0.top.equalTo(ingredientsTitle.snp.bottom).offset(5)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    private func reloadData() {
        name.text = drink.strDrink
        
        image.load(urlString: drink.strDrinkThumb)
        
        instructions.text = drink.strInstructions
        
        var textIngredient = ""
        if
            let i1 =  drink.strIngredient1,
            i1 != "" {
            textIngredient += " - " + i1 + "\n"
        }
        if
            let i2 =  drink.strIngredient2,
            i2 != "" {
            textIngredient += " - " + i2 + "\n"
        }
        if
            let i3 =  drink.strIngredient3,
            i3 != "" {
            textIngredient += " - " + i3 + "\n"
        }
        if
            let i4 =  drink.strIngredient4,
            i4 != "" {
            textIngredient += " - " + i4 + "\n"
        }
        if
            let i5 =  drink.strIngredient5,
            i5 != "" {
            textIngredient += " - " + i5 + "\n"
        }
        if
            let i6 =  drink.strIngredient6,
            i6 != "" {
            textIngredient += " - " + i6 + "\n"
        }
        ingredients.text = textIngredient
        
        category.text = drink.strCategory
        
        alcoholic.text = drink.strAlcoholic
    }
    
    private func setUpNavBar() {
        let navigationBarImageView = UILabel()
        navigationBarImageView.textColor = .white
        navigationBarImageView.text = "Cocktail App"
        navigationBarImageView.font = UIFont.italicSystemFont(ofSize: 20)

        self.navigationItem.titleView = navigationBarImageView
    }
    
    @objc func updateFavorites() {
        let drinkFilter = DrinkFilter(strDrink: drink.strDrink, strDrinkThumb: drink.strDrinkThumb, idDrink: drink.idDrink)
        print("TU SMO")
        if favorites.image == heart {
            PersistenceManager.updateWith(favorite: drinkFilter, actionType: .add) { [weak self] error in
                guard let self = self else { return }

                guard error != nil else {
                    DispatchQueue.main.async {
                        self.favorites.image = self.heartFill
                    }
                    return
                }
                return
            }
        } else {
            PersistenceManager.updateWith(favorite: drinkFilter, actionType: .remove) { [weak self] error in
                guard let self = self else { return }

                guard error != nil else {
                    DispatchQueue.main.async {
                        self.favorites.image = self.heart
                    }
                    return
                }
                return
            }
        }
    }
}
