

protocol NetworkServiceProtocol{
    
    func getDrinksByName(string: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void)
    func getDrinkDetails(string: String, completionHandler: @escaping (Result<Drink, Error>) -> Void)
    func getRandomDrink(completionHandler: @escaping (Result<Drink, Error>) -> Void)

}
