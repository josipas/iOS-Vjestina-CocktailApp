import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func getItemCount(for filter: Filters) -> Int
    func getItemTitle(for filter: Filters, at indexPath: IndexPath) -> String
    func didSelectItem(for filter: Filters, at indexPath: IndexPath)
}

class HomeTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: HomeTableViewCell.self)

    private var firstLabel: UILabel!
    private var secondLabel: UILabel!
    private var collectionView: UICollectionView!
    private var filter = Filters.ingredient

    weak var delegate: HomeTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        buildViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(firstText: String, secondText: String, filter: Filters) {
        firstLabel.text = firstText
        secondLabel.text = secondText
        self.filter = filter

        collectionView.reloadData()
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        firstLabel = UILabel()
        secondLabel = UILabel()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
    }

    private func addSubviews() {
        addSubview(firstLabel)
        addSubview(secondLabel)
        addSubview(collectionView)
    }

    private func styleViews() {
        firstLabel.textColor = UIColor(hex: "#f54242")
        firstLabel.font = UIFont.italicSystemFont(ofSize: 20)

        secondLabel.textColor = UIColor(hex: "#f54242")
        secondLabel.font = UIFont.italicSystemFont(ofSize: 20)
    }

    private func addConstraints() {
        firstLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(16)
        }

        secondLabel.snp.makeConstraints {
            $0.leading.equalTo(firstLabel.snp.leading).offset(30)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(firstLabel.snp.bottom).offset(5)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(secondLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(80)
        }
    }

}

extension HomeTableViewCell: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(for: filter, at: indexPath)
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        delegate?.getItemCount(for: filter) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeCollectionViewCell
        else {
            fatalError()
        }

        let title = delegate?.getItemTitle(for: filter, at: indexPath) ?? ""
        cell.set(title: title)

        return cell
    }
}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
}

extension UITableViewCell {
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        sendSubviewToBack(contentView)
    }
}
