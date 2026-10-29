//
//  QRCodeCell.swift
//  qrcode-reader
//
//  Created by Chloe Tay on 29/10/26.
//

import UIKit

class QRCodeCell: UICollectionViewCell {

    static let reuseIdentifier = "QRCodeCell"
    
    private let iconImageView = UIImageView()
    private let contentLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // English: "Add the three pieces into the cell and style them."
    private func setupViews() {
        //A white card with rounded corners and a thin grey border
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.clipsToBounds = true

        //The small blue QR icon
        iconImageView.image = UIImage(systemName: "qrcode")
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit

        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = .label
        contentLabel.numberOfLines = 2
        contentLabel.lineBreakMode = .byCharWrapping

        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = .secondaryLabel

        //A vertical stack: QR text on top, date underneath, 2pt apart
        let textStack = UIStackView(arrangedSubviews: [contentLabel, dateLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        [iconImageView, textStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),

            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    
    // Fills the cell with one item's text and formatted scan date
    func configure(with item: QRCodeItem) {
        contentLabel.text = item.text
        dateLabel.text = Self.dateFormatter.string(from: item.date)
    }

    // Shared formatter, matches "16/10/25, 15:40"
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy, HH:mm"
        return formatter
    }()

}



#Preview {
    // English: "Make a blank screen to hold the cell."
    let screen = UIViewController()
    screen.view.backgroundColor = .systemGroupedBackground

    // English: "Make one cell and fill it with a fake QR card."
    let cell = QRCodeCell()
    cell.configure(with: QRCodeItem(text: "https://www.apple.com", date: .now))
    cell.translatesAutoresizingMaskIntoConstraints = false
    screen.view.addSubview(cell)

    // English: "Place it near the top, 16pt side margins, fixed height of 80 (like a list row)."
    NSLayoutConstraint.activate([
        cell.topAnchor.constraint(equalTo: screen.view.safeAreaLayoutGuide.topAnchor, constant: 16),
        cell.leadingAnchor.constraint(equalTo: screen.view.leadingAnchor, constant: 16),
        cell.trailingAnchor.constraint(equalTo: screen.view.trailingAnchor, constant: -16),
        cell.heightAnchor.constraint(equalToConstant: 80)
    ])
    return screen
}
