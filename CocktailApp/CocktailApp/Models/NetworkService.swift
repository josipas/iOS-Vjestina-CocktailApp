import Foundation

enum Result<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}

class NetworkService: NetworkServiceProtocol {
    private func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
                                                 @escaping (Result<T, CustomError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      completionHandler(.failure(.serverError))
                      return
                  }
            guard let data = data else {
                completionHandler(.failure(.noDataError))
                return
            }
            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completionHandler(.failure(.dataDecodingError))
                return
            }
            completionHandler(.success(value))
        }
        dataTask.resume()
    }

    func getDrinksByFilter(filter: Filters, string: String, completionHandler: @escaping (Result<[DrinkFilter], Error>) -> Void) {
        var urlString = ""
        switch filter {
        case .ingredient:
            urlString = "\(Constants.apiUrl)/filter.php?i=\(string)"
        case .category:
            urlString = "\(Constants.apiUrl)/filter.php?c=\(string)"
        }

        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        executeUrlRequest(request) { (result: Result<DrinkFilters, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks))
            }
        }
    }

    func getListOfAllCategories(completionHandler: @escaping (Result<[Category], Error>) -> Void) {
        let urlString = "\(Constants.apiUrl)/list.php?c=list"

        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        executeUrlRequest(request) { (result: Result<Categories, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks))
            }
        }
    }

    func getListOfAllIngredients(completionHandler: @escaping (Result<[Ingredient], Error>) -> Void) {
        let urlString = "\(Constants.apiUrl)/list.php?i=list"

        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        executeUrlRequest(request) { (result: Result<Ingredients, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks))
            }
        }
    }

    func getDrinksByName(string: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {

        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + string
        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        executeUrlRequest(request) { (result: Result<Drinks, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks))
            }
        }
    }
    
    func getDrinkDetails(string: String, completionHandler: @escaping (Result<Drink, Error>) -> Void) {

        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + string
        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        executeUrlRequest(request) { (result: Result<Drinks, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks.first!))
            }
        }
    }
    
    func getRandomDrink(completionHandler: @escaping (Result<Drink, Error>) -> Void) {

        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
        guard
            let url = URL(string: urlString)
        else {
            completionHandler(.failure(CustomError.clientError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        executeUrlRequest(request) { (result: Result<Drinks, CustomError>) in
            switch result {
            case .failure:
                completionHandler(.failure(CustomError.serverError))
            case .success(let value):
                completionHandler(.success(value.drinks.first!))
            }
        }
    }
}
