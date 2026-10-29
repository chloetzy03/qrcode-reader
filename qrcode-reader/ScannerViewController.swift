//
//  ScannerViewController.swift
//  qrcode-reader
//
//  Created by Shofia Ghazali on 29/10/26.
//


import UIKit
import QRScanner

protocol ScannerViewControllerDelegate: AnyObject {
    func scannerViewController(
        _ controller: ScannerViewController,
        didScan code: String
    )
    
}
class ScannerViewController: UIViewController, QRScannerViewDelegate {

    weak var delegate: ScannerViewControllerDelegate?
    
    // MARK: - UI

    private let titleLabel = UILabel()
    private let instructionLabel = UILabel()
    private let scannerContainerView = UIView()
    private let scanFrameView = UIView()
    private let torchButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    // MARK: - Scanner

    // TODO: Create your QRScannerView property here.
    private let qrScannerView = QRScannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setUpUI()
        setUpLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        qrScannerView.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrScannerView.stopRunning()
    }
    
    // MARK: - UI Setup

    private func setUpUI() {
        titleLabel.text = "Scan QR Code"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center

        instructionLabel.text = "Position a QR code inside the frame"
        instructionLabel.font = .systemFont(ofSize: 15)
        instructionLabel.textColor = .secondaryLabel
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0

        scannerContainerView.backgroundColor = .black
        scannerContainerView.layer.cornerRadius = 20
        scannerContainerView.clipsToBounds = true

        scanFrameView.backgroundColor = .clear
        scanFrameView.layer.borderColor = UIColor.systemGreen.cgColor
        scanFrameView.layer.borderWidth = 3
        scanFrameView.layer.cornerRadius = 16
        scanFrameView.isUserInteractionEnabled = false

        torchButton.setImage(
            UIImage(systemName: "flashlight.off.fill"),
            for: .normal
        )
        torchButton.tintColor = .white
        torchButton.backgroundColor = .darkGray
        torchButton.layer.cornerRadius = 25

        closeButton.setImage(
            UIImage(systemName: "xmark"),
            for: .normal
        )
        closeButton.tintColor = .label
        closeButton.backgroundColor = .secondarySystemBackground
        closeButton.layer.cornerRadius = 18

        closeButton.addTarget(
            self,
            action: #selector(closeScanner),
            for: .touchUpInside
        )

        torchButton.addTarget(
            self,
            action: #selector(toggleTorch),
            for: .touchUpInside
        )

        [
            titleLabel,
            instructionLabel,
            scannerContainerView,
            scanFrameView,
            torchButton,
            closeButton,
            qrScannerView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(titleLabel)
        view.addSubview(instructionLabel)
        view.addSubview(scannerContainerView)
        scannerContainerView.addSubview(qrScannerView)
        scannerContainerView.addSubview(scanFrameView)
        view.addSubview(torchButton)
        view.addSubview(closeButton)
        
        qrScannerView.configure(delegate: self)
    }

    private func setUpLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 12
            ),
            closeButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),

            titleLabel.topAnchor.constraint(
                equalTo: closeButton.bottomAnchor,
                constant: 24
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),

            instructionLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10
            ),
            instructionLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 28
            ),
            instructionLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -28
            ),

            scannerContainerView.topAnchor.constraint(
                equalTo: instructionLabel.bottomAnchor,
                constant: 28
            ),
            scannerContainerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            scannerContainerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            scannerContainerView.heightAnchor.constraint(
                equalTo: scannerContainerView.widthAnchor
            ),

            scanFrameView.centerXAnchor.constraint(
                equalTo: scannerContainerView.centerXAnchor
            ),
            scanFrameView.centerYAnchor.constraint(
                equalTo: scannerContainerView.centerYAnchor
            ),
            scanFrameView.widthAnchor.constraint(
                equalTo: scannerContainerView.widthAnchor,
                multiplier: 0.65
            ),
            scanFrameView.heightAnchor.constraint(
                equalTo: scanFrameView.widthAnchor
            ),

            torchButton.topAnchor.constraint(
                equalTo: scannerContainerView.bottomAnchor,
                constant: 24
            ),
            torchButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            torchButton.widthAnchor.constraint(equalToConstant: 50),
            torchButton.heightAnchor.constraint(equalToConstant: 50),
            // QR scanner fills the container
            qrScannerView.topAnchor.constraint(
                equalTo: scannerContainerView.topAnchor
            ),
            qrScannerView.leadingAnchor.constraint(
                equalTo: scannerContainerView.leadingAnchor
            ),
            qrScannerView.trailingAnchor.constraint(
                equalTo: scannerContainerView.trailingAnchor
            ),
            qrScannerView.bottomAnchor.constraint(
                equalTo: scannerContainerView.bottomAnchor
            ),
        ])
    }

    // MARK: - Actions

    @objc private func closeScanner() {
        dismiss(animated: true)
    }

    @objc private func toggleTorch() {
        // TODO: Connect this button to QRScannerView.setTorchActive(isOn:).
    }

    // MARK: - QRScannerViewDelegate

    func qrScannerView(
        _ qrScannerView: QRScannerView,
        didSuccess code: String
    ) {
        delegate?.scannerViewController(self, didScan: code)
        dismiss(animated: true)
    }

    func qrScannerView(
        _ qrScannerView: QRScannerView,
        didFailure error: QRScannerError
    ) {
        print("Scanner error: \(error)")
    }
    
}

#Preview {
    ScannerViewController()
}
