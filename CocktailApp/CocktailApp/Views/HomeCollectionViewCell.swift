import UIKit
import RandomColor

class HomeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HomeCollectionViewCell.self)

    private var descriptionLabel: UILabel!
    private var colors: [UIColor]!

    override init(frame: CGRect) {
        super.init(frame: .zero)

        colors = randomColors(count: 1, hue: .purple, luminosity: .bright)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        descriptionLabel.text = nil
    }

    func set(title: String) {
        descriptionLabel.text = title
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addContraints()
    }

    private func createViews() {
        descriptionLabel = UILabel()
    }

    private func addSubviews() {
        addSubview(descriptionLabel)
    }

    private func styleViews() {
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        self.backgroundColor = colors[0].withAlphaComponent(0.2)
    }

    private func addContraints() {
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(2)
            $0.centerY.equalToSuperview()
        }
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 8
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.1
    }
}
