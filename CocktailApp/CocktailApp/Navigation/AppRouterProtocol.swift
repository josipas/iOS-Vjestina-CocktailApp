import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func showRandomDetailsViewController(idDrink: String)
    func showDetailsViewController(idDrink: String)
}
