//
//  UIViewCreator.swift
//  weatherApp
//
//  Created by Александра Кострова on 21.03.2023.
//

import UIKit

final class MakeSomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func makeImageView(_ image: UIImage) -> UIImageView {
        let someImage = UIImageView.init(image: image)
        someImage.contentMode = .scaleAspectFill
        return someImage
    }
    
    public func makeView() -> UIView {
        let newView = UIView()
        newView.backgroundColor = .clear
        newView.contentMode = .scaleToFill
        return newView
    }
    
    public func makeStackView(_ axis: NSLayoutConstraint.Axis,
                              _ alignment: UIStackView.Alignment,
                              _ spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = .fill
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.contentMode = .scaleToFill
        return stackView
    }
    
    public func makeLabel(_ title: String,
                          _ textAlignment: NSTextAlignment,
                          _ fontSize: CGFloat,
                          _ fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = title
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.textAlignment = textAlignment
        label.contentMode = .left
        label.isEnabled = true
        return label
    }
    
    public func makeButton(_ image: UIImage) -> UIButton {
        let button = UIButton()
        button.setBackgroundImage(image, for: .normal)
        button.titleLabel!.numberOfLines = 0
        button.tintColor = .label
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.buttonFontSize, weight: .regular)
        return button
    }
    
    public func makeTextField() -> UITextField {
        let someTF = UITextField()
        someTF.textColor = .label
        someTF.backgroundColor = .systemFill
        someTF.font = .systemFont(ofSize: Constants.textFieldFontSize, weight: .regular)
        someTF.placeholder = "Search"
        someTF.textAlignment = .right
        someTF.minimumFontSize = Constants.textFieldMinFontSize
        someTF.contentVerticalAlignment = .center
        someTF.clearButtonMode = .never
        someTF.borderStyle = .roundedRect
        someTF.autocapitalizationType = .words
        someTF.returnKeyType = .go
        return someTF
    }
    
    private enum Constants {
        static let buttonFontSize: CGFloat = 15.0
        static let textFieldFontSize: CGFloat = 25.0
        static let textFieldMinFontSize: CGFloat = 12.0
    }
}
