//
//  QRCodeDetailViewController.swift
//  qrcode-reader
//
//  Created by Chloe Tay on 29/10/26.
//

import UIKit
import CoreImage.CIFilterBuiltins

class QRCodeDetailViewController: UIViewController {

    private let qrImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let instructionLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let item: QRCodeItem
    
    //Create the sheet with one QRCodeItem
    init(item: QRCodeItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet   //Show as a sheet that slides up
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSheet()
        setUpViews()
        setUpLayout()
    }

    // Small grey handle at the top; sheet stops at half height
    private func setUpSheet() {
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [.medium()]
    }

    private func setUpViews() {
        titleLabel.text = "Scan Again"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        qrImageView.tintColor = .label
        qrImageView.contentMode = .scaleAspectFit
        // Show the real QR code. If it fails, keep the placeholder icon
        qrImageView.image = makeQRImage(from: item.text) ?? UIImage(systemName: "qrcode")
        //prevent blurriness when scaled up
        qrImageView.layer.magnificationFilter = .nearest
        //for dark mode
        qrImageView.backgroundColor = .white

        instructionLabel.text = "Hold another device to scan this code"
        instructionLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0

        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        dateLabel.text = "Scanned \(DateFormatter.qrCode.string(from: item.date))"

        // Grey circle with an X
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.backgroundColor = .systemGray5
        closeButton.layer.cornerRadius = 18
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        [titleLabel, qrImageView, instructionLabel, dateLabel, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setUpLayout() {
        NSLayoutConstraint.activate([
            // Title: top, centered
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Close button: top right, 36x36 circle
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            // QR image: big square under the title
            qrImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            qrImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 220),
            qrImageView.heightAnchor.constraint(equalTo: qrImageView.widthAnchor),

            // Instruction: under the QR, wraps if long
            instructionLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Date: smallest text, last
            dateLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 8),
            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // Turn a piece of text into a QR code picture
    private func makeQRImage(from text: String) -> UIImage? {
        //Get iOS's built-in QR code maker
        let filter = CIFilter.qrCodeGenerator()

        //Give it the text, converted into raw data
        filter.message = Data(text.utf8)

        // hands back a tiny image/nothing, if it failed
        guard let outputImage = filter.outputImage else { return nil }

        // Enlarge 10x so it's big and sharp enough to scan
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        // Render the recipe into a real picture (UIImageView can't show it directly)
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
    

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
}


extension DateFormatter {
    // Matches "16/10/25, 15:40"
    static let qrCode: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy, HH:mm"
        return formatter
    }()
}

#Preview {
    QRCodeDetailViewController(item: QRCodeItem(text: "https://www.apple.com", date: .now))
}
