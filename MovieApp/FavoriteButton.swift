import UIKit

class FavoriteButton: UIButton {
    
    var isFavorite: Bool = false {
        didSet {
            updateButtonImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        isUserInteractionEnabled = true
        updateButtonImage()
    }
    
    private func updateButtonImage() {
        let imageName = isFavorite ? "star.fill" : "star"
        
        if isFavorite {
            tintColor = .systemYellow
        } else {
            tintColor = UIColor.white.withAlphaComponent(0.7)
        }
        
        let image = UIImage(systemName: imageName)
        image?.withRenderingMode(.alwaysTemplate)
        
        setImage(image, for: .normal)
    }
    
    @objc private func buttonTapped() {
        isFavorite.toggle()
    }
}
