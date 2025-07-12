//
//  ColorCell.swift
//  Tracker
//
//  Created by Alexander Agafonov on 04.07.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var selectionBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 3
        view.layer.opacity = 0.3
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
        contentView.addSubview(selectionBorderView)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            selectionBorderView.widthAnchor.constraint(equalToConstant: 52),
            selectionBorderView.heightAnchor.constraint(equalToConstant: 52),
            selectionBorderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with color: UIColor) {
        colorView.backgroundColor = color
        selectionBorderView.layer.borderColor = color.cgColor
    }
    
    func setSelected(_ selected: Bool) {
        selectionBorderView.isHidden = !selected
    }
}
