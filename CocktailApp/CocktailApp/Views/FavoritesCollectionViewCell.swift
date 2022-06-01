import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: FavoritesCollectionViewCell.self)

    private var image: UIImage!
    private var imageView: UIImageView!
    private var view: UIView!
    private var drink: DrinkFilter?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
    }

    func set(drink: DrinkFilter, isFavorite: Bool) {
        self.drink = drink
        imageView.load(urlString: drink.strDrinkThumb)
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
    }

    private func createViews() {
        imageView = UIImageView()
    }

    private func addSubviews() {
        addSubview(imageView)
    }

    private func styleViews() {
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }

    private func addContraints() {
        imageView.snp.makeConstraints {
            $0.leading.top.bottom.trailing.equalToSuperview()
        }
    }
}

