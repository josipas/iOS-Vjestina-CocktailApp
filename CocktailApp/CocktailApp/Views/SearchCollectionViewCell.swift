

import Foundation
import UIKit
import RandomColor

class SearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SearchCollectionViewCell.self)

    private var drinkName: UILabel!
    private var drinkImage: UIImageView!
    private var drinkCategory: UILabel!
    private var alcoholic: UILabel!
    private var drink: Drink!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        drinkImage.image = nil
    }

    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        addConstraints()
    }

    private func createViews() {
        drinkImage = UIImageView()

        drinkName = UILabel()

        drinkCategory = UILabel()

        alcoholic = UILabel()
    }

    private func addSubviews() {
        contentView.addSubview(drinkImage)
        contentView.addSubview(drinkName)
        contentView.addSubview(drinkCategory)
        contentView.addSubview(alcoholic)
    }
        
    private func styleViews() {
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)

        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        drinkImage.contentMode = .scaleAspectFill
            
        drinkName.font = .systemFont(ofSize: 20, weight: .bold)
            
        drinkCategory.numberOfLines = 0
    }

    func addConstraints() {
        drinkImage.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(0)
            $0.width.equalTo(110)
        }
            
        drinkName.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalTo(drinkImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
            
        drinkCategory.snp.makeConstraints{
            $0.top.equalTo(drinkName.snp.bottom).offset(5)
            $0.leading.equalTo(drinkImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        alcoholic.snp.makeConstraints{
            $0.top.equalTo(drinkCategory.snp.bottom).offset(0)
            $0.leading.equalTo(drinkImage.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
        
    func set(strDrink: String, strCategory: String?, strAlcoholic: String?, strDrinkThumb: String) {
        self.drinkName.text = "\(strDrink)"
        if let strCategory = strCategory {
            drinkCategory.text = "Category: \(strCategory)"
        } else {
            drinkCategory.isHidden = true
        }

        if let strAlcoholic = strAlcoholic {
            if strAlcoholic == "Alcoholic" {
                alcoholic.text = "Alcoholic: Yes"
            } else {
                alcoholic.text = "Alcoholic: No"
            }
        } else {
            alcoholic.isHidden = true
        }

        drinkImage.load(urlString: strDrinkThumb)
    }
}
