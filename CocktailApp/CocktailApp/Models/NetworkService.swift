import Foundation

enum RequestError: Error {
    case clientError
    case serverError
    case noDataError
    case dataDecodingError
}

enum Result<Success, Failure> where Failure : Error {
    /// A success, storing a `Success` value.
    case success(Success)
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}

class NetworkService: NetworkServiceProtocol{
    
    func getDrinksByName(string: String, completionHandler: @escaping (Result<[Drink], Error>) -> Void) {

            let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + string
            guard
                let url = URL(string: urlString)
            else {
                completionHandler(.failure(RequestError.clientError))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Drinks, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
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
                completionHandler(.failure(RequestError.clientError))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Drinks, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
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
                completionHandler(.failure(RequestError.clientError))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            executeUrlRequest(request) { (result: Result<Drinks, RequestError>) in
                switch result {
                case .failure:
                    completionHandler(.failure(RequestError.serverError))
                case .success(let value):
                    completionHandler(.success(value.drinks.first!))
                }
            }
    }
    
    
    
   
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
    @escaping (Result<T, RequestError>) -> Void) {
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
}
