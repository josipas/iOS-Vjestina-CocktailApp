import UIKit

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController!
    private let navBarAppearance: UINavigationBarAppearance!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navBarAppearance = UINavigationBarAppearance()
    }
    
    func setStartScreen(in window: UIWindow?) {
        navBarAppearance.backgroundColor = .cyan
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [createHomeViewController(), createSearchViewController(), createDetailsViewController(), createFavoritesViewController()]

        navigationController.pushViewController(tabBarController, animated: false)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    private func createHomeViewController() -> UINavigationController {
        let homeVC = HomeViewController(router: self)
        let homeNC = UINavigationController(rootViewController: homeVC)
        homeNC.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "home"), tag: 0)
        homeNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        homeNC.navigationBar.standardAppearance = navBarAppearance
        
        return homeNC
    }
    
    private func createSearchViewController() -> UINavigationController {
        let searchVC = SearchViewController(router: self)
        let searchNC = UINavigationController(rootViewController: searchVC)
        searchNC.tabBarItem = UITabBarItem.init(title: "Search", image: UIImage(named: "favorites"), tag: 1)
        searchNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        searchNC.navigationBar.standardAppearance = navBarAppearance
        
        return searchNC
    }
    
    private func createDetailsViewController() -> UINavigationController {
        let detailsVC = CocktailDetailsViewController(router: self)
        let detailsNC = UINavigationController(rootViewController: detailsVC)
        detailsNC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(named: "favorites"), tag: 2)
        detailsNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        detailsNC.navigationBar.standardAppearance = navBarAppearance
        
        return detailsNC
    }
    
    private func createFavoritesViewController() -> UINavigationController {
        let favoritesVC = FavoritesViewController(router: self)
        let favoritesNC = UINavigationController(rootViewController: favoritesVC)
        favoritesNC.tabBarItem = UITabBarItem.init(title: "Favorites", image: UIImage(named: "favorites"), tag: 3)
        favoritesNC.navigationBar.scrollEdgeAppearance = navBarAppearance
        favoritesNC.navigationBar.standardAppearance = navBarAppearance
        
        return favoritesNC
    }
}
