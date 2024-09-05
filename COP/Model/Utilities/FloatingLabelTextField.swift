//
//  FloatingLabelTextField.swift
//  COP
//
//  Created by Mac on 28/07/24.
//

import UIKit

class FloatingLabelTextField: UITextField {

    private let floatingLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override var placeholder: String? {
        didSet {
            floatingLabel.text = placeholder
        }
    }

    override var text: String? {
        didSet {
            updateFloatingLabel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFloatingLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFloatingLabel()
    }

    private func setupFloatingLabel() {
        addSubview(floatingLabel)
        NSLayoutConstraint.activate([
            floatingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            floatingLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -5)
        ])
        
        addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
        addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }

    @objc private func textFieldEditingDidBegin() {
        animateFloatingLabel(shouldShow: true)
    }

    @objc private func textFieldEditingDidEnd() {
        if text?.isEmpty ?? true {
            animateFloatingLabel(shouldShow: false)
        }
    }

    @objc private func textFieldEditingChanged() {
        updateFloatingLabel()
    }

    private func updateFloatingLabel() {
        if !(text?.isEmpty ?? true) {
            animateFloatingLabel(shouldShow: true)
        } else {
            animateFloatingLabel(shouldShow: false)
        }
    }

    private func animateFloatingLabel(shouldShow: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.floatingLabel.alpha = shouldShow ? 1 : 0
        }
    }
}
