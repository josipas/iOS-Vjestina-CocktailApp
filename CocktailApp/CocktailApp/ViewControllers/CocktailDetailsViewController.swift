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
    }
    
    private func createViews() {
        name = UILabel()
        
        view.addSubview(name)
        
        instructions = UILabel()
        view.addSubview(instructions)
        
        instructionsTitle = UILabel()
        view.addSubview(instructionsTitle)
        
        image = UIImageView()
        view.addSubview(image)
        
        ingredients = UILabel()
        view.addSubview(ingredients)
        
        ingredientsTitle = UILabel()
        view.addSubview(ingredientsTitle)
        
        category = UILabel()
        view.addSubview(category)
        
        categoryText = UILabel()
        view.addSubview(categoryText)
        
        alcoholic = UILabel()
        view.addSubview(alcoholic)
        
        heart = UIImage(systemName: "heart")
        heartFill = UIImage(systemName: "heart.fill")
        
        favorites = UIImageView()
        favorites.image = heart
        favorites.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.updateFavorites)))
        favorites.isUserInteractionEnabled = true
        view.addSubview(favorites)

    }

    
    private func styleViews() {
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

        favorites.tintColor = .red
        
        categoryText.font = .systemFont(ofSize: 22, weight: .bold)
        categoryText.text = "Category:"
    }
    
    private func defineLayoutForViews() {
        
        name.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(95)
            $0.top.equalTo(image.snp.bottom).offset(10)
        }
        alcoholic.snp.makeConstraints{
            $0.top.equalTo(name.snp.bottom).offset(0)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(95)
        }
          
        favorites.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
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
        }
        
        image.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
        
    }
    
    private func reloadData() {
        name.text = drink.strDrink
        
        image.load(urlString: drink.strDrinkThumb)
        
        instructions.text = drink.strInstructions
        
        var textIngredient = ""
        if let i1 =  drink.strIngredient1 {
            textIngredient += " - " + i1 + "\n"
        }
        if let i2 =  drink.strIngredient2 {
            textIngredient += " - " + i2 + "\n"
        }
        if let i3 =  drink.strIngredient3 {
            textIngredient += " - " + i3 + "\n"
        }
        if let i4 =  drink.strIngredient4 {
            textIngredient += " - " + i4 + "\n"
        }
        if let i5 =  drink.strIngredient5 {
            textIngredient += " - " + i5 + "\n"
        }
        if let i6 =  drink.strIngredient6 {
            textIngredient += " - " + i6 + "\n"
        }
        ingredients.text = textIngredient
        
        category.text = drink.strCategory
        
        alcoholic.text = drink.strAlcoholic
    }
    
    @objc func updateFavorites() {
        let drinkFilter = DrinkFilter(strDrink: drink.strDrink, strDrinkThumb: drink.strDrinkThumb, idDrink: drink.idDrink)
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
