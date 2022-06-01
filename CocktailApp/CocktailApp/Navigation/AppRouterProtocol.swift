import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showRandomDetailsViewController(idDrink: String)
    func showDetailsViewController(idDrink: String)
    func showDetailsViewControllerFromHome(idDrink: String)
    func showDrinksByFilterViewController(for filter: Filters, name: String)
}
