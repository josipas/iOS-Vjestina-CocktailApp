import UIKit
import SnapKit

protocol SearchFilterDelegate: AnyObject {
    func filter(text: String)
}

class SearchBarView: UIView {
    private var searchImage: UIImageView!
    private var textInput: UITextField!
    private var xButton: UIButton!
    private var cancelButton: UIButton!
    private var grayLayout: UIView!
    private var grayLayout2: UIView!

    weak var delegateFilter: SearchFilterDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildViews() {
        createViews()
        addSubviews()
        styleViews()
        defineLayoutForViews()
    }
    
    func createViews() {
        grayLayout = UIView()

        grayLayout2 = UIView()

        searchImage = UIImageView()

        textInput = UITextField()

        xButton = UIButton()
        xButton.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        
        cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }

    private func addSubviews() {
        addSubview(grayLayout)
        addSubview(grayLayout2)
        addSubview(searchImage)
        addSubview(textInput)
        addSubview(xButton)
        addSubview(cancelButton)
    }

    private func styleViews() {
        self.backgroundColor = .white

        grayLayout.layer.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.921, alpha: 1).cgColor
        grayLayout.layer.cornerRadius = 10
        
        grayLayout2.layer.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.921, alpha: 1).cgColor
        grayLayout2.layer.cornerRadius = 10
        
        textInput.placeholder = "Search"
        textInput.textColor = .gray
        textInput.delegate = self
        
        let imageMagnifyingGlass = UIImage(systemName: "magnifyingglass")
        searchImage.image = imageMagnifyingGlass
        searchImage.tintColor = .black.withAlphaComponent(0.8)

        let xmark = UIImage(systemName: "xmark")
        xButton.setImage(xmark, for: .normal)
        xButton.tintColor = .black.withAlphaComponent(0.8)
        xButton.isHidden = true
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.black.withAlphaComponent(0.8), for: .normal)
        cancelButton.isHidden = true
    }

    func defineLayoutForViews() {
        grayLayout.snp.makeConstraints{
            $0.leading.top.trailing.bottom.equalToSuperview().inset(0)
        }
        
        grayLayout2.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview().inset(0)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(60)
        }
        
        textInput.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.trailing.equalToSuperview().inset(87)
            $0.top.equalToSuperview().inset(10)
        }
        
        searchImage.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        
        xButton.snp.makeConstraints{
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(70)
            $0.top.equalToSuperview().inset(10)
        }
        
        cancelButton.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(5)
        }
    }
    
    @objc func onClick(sender: UIButton!){
        textInput.text = nil
        xButton.isHidden = true
    }
    
    @objc func cancelAction() {
        textFieldDidEndEditing(textInput)
    }
}

extension SearchBarView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
        grayLayout.isHidden = true
        if textField.hasText {
            xButton.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        xButton.isHidden = true
        cancelButton.isHidden = true
        grayLayout.isHidden = false
        textInput.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        xButton.isHidden = false
        if textInput.text == "" {
            xButton.isHidden = true
        }
        delegateFilter?.filter(text: textInput.text!)
    }
}

