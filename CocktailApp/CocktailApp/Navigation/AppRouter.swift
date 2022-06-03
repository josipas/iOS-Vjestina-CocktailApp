import UIKit

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController!
    private let navBarAppearance: UINavigationBarAppearance!
    private var randomNC: UINavigationController!
    private var searchNC: UINavigationController!
    private var homeNC: UINavigationController!
    private var favoritesNC: UINavigationController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navBarAppearance = UINavigationBarAppearance()
    }
    
    func setStartScreen(in window: UIWindow?) {
        navBarAppearance.backgroundColor = UIColor(hex: "#b88dbe")

        let tabBarController = setUpTabBar()

        navigationController.pushViewController(tabBarController, animated: false)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func setUpTabBar() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(hex: "#b88dbe")
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController.tabBar.layer.shadowRadius = 4.0
        tabBarController.tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.3
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = [createHomeViewController(), createSearchViewController(), createRandomCocktilViewController(), createFavoritesViewController()]

        return tabBarController
    }
    
    private func createHomeViewController() -> UINavigationController {
        let homeVC = HomeViewController(router: self)
        homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        homeNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        homeNC.navigationBar.standardAppearance = navBarAppearance
        
        return homeNC
    }
    
    private func createSearchViewController() -> UINavigationController {
        let searchVC = SearchViewController(router: self)
        searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.tabBarItem = UITabBarItem.init(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        searchNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        searchNC.navigationBar.standardAppearance = navBarAppearance
        
        return searchNC
    }
    
    private func createRandomCocktilViewController() -> UINavigationController {
        let randomVC = RandomCocktailViewController(router: self)
        randomNC = UINavigationController(rootViewController: randomVC)
        randomNC.tabBarItem = UITabBarItem.init(title: "Random", image: UIImage(systemName: "wand.and.stars"), tag: 2)
        randomNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        randomNC.navigationBar.standardAppearance = navBarAppearance
        
        return randomNC
    }
    
    private func createFavoritesViewController() -> UINavigationController {
        let favoritesVC = FavoritesViewController(router: self)
        favoritesNC = UINavigationController(rootViewController: favoritesVC)
        favoritesNC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 3)
        favoritesNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        favoritesNC.navigationBar.standardAppearance = navBarAppearance
        
        return favoritesNC
    }
    
    func showRandomDetailsViewController(idDrink: String) {
        let vc = CocktailDetailsViewController(router: self, idDrink: idDrink)
        randomNC.pushViewController(vc, animated: true)
    }
    
    func showDetailsViewControllerFromSearch(idDrink: String) {
        let vc = CocktailDetailsViewController(router: self, idDrink: idDrink)
        searchNC.pushViewController(vc, animated: true)
    }

    func showDrinksByFilterViewController(for filter: Filters, name: String) {
        let vc = CocktailsByFilterViewController(router: self, string: name, filter: filter)
        homeNC.pushViewController(vc, animated: true)
    }

    func showDetailsViewControllerFromHome(idDrink: String) {
        let vc = CocktailDetailsViewController(router: self, idDrink: idDrink)
        homeNC.pushViewController(vc, animated: true)
    }
    
    func showDetailsViewControllerFromFavorites(idDrink: String) {
        let vc = CocktailDetailsViewController(router: self, idDrink: idDrink)
        favoritesNC.pushViewController(vc, animated: true)
    }
}
