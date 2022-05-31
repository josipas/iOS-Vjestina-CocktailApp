

import Foundation
import UIKit
import RandomColor

class  SearchCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: SearchCollectionViewCell.self)

    private var drinkName: UILabel!
    private var drinkImage: UIImageView!
    private var drinkCategory: UILabel!
    private var alcoholic: UILabel!
    private var drink: Drink!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
        styleViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func buildViews() {
        drinkImage = UIImageView()
        contentView.addSubview(drinkImage)
            
        drinkName = UILabel()
        contentView.addSubview(drinkName)
        
        drinkCategory = UILabel()
        contentView.addSubview(drinkCategory)
        
        alcoholic = UILabel()
        contentView.addSubview(alcoholic)
    }
        
    private func styleViews(){
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)

        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
//        let randomColor = randomColor(hue: .random, luminosity: .light)
//        let darkPinkColors = randomColors(count: 10, hue: .red, luminosity: .light)
//        contentView.layer.backgroundColor = darkPinkColors[0].cgColor
//        contentView.layer.backgroundColor = randomColor.cgColor
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
        
    func set(searchData: Drink) {
        drink = searchData
        print("\(searchData.strDrink)")
        drinkName.text = "\(searchData.strDrink)"
        drinkCategory.text = "Category: \(searchData.strCategory)"
        if searchData.strAlcoholic == "Alcoholic" {
            alcoholic.text = "Alcoholic: Yes"
        } else {
            alcoholic.text = "Alcoholic: No"
        }
        drinkImage.load(urlString: searchData.strDrinkThumb)
    }
}

extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


