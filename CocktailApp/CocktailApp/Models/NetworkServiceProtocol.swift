protocol NetworkServiceProtocol {
    func getDrinksByName(string: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void)
    func getDrinkDetails(string: String, completionHandler: @escaping (Result<Drink, Error>) -> Void)
    func getRandomDrink(completionHandler: @escaping (Result<Drink, Error>) -> Void)
    func getListOfAllIngredients(completionHandler: @escaping (Result<[Ingredient], Error>) -> Void)
    func getListOfAllCategories(completionHandler: @escaping (Result<[Category], Error>) -> Void)
    func getDrinksByFilter(filter: Filters, string: String, completionHandler: @escaping (Result<[DrinkFilter], Error>) -> Void)
}
