import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showRandomDetailsViewController(idDrink: String)
    func showDetailsViewControllerFromSearch(idDrink: String)
    func showDetailsViewControllerFromFavorites(idDrink: String)
    func showDetailsViewControllerFromHome(idDrink: String)
    func showDrinksByFilterViewController(for filter: Filters, name: String)
}
