//
//  QRCodesViewController.swift
//  qrcode-reader
//
//  Created by Shofia Ghazali on 29/10/26.
//


import UIKit

class QRCodesViewController: UIViewController {

    private let items: [QRCodeItem] = [
        QRCodeItem(text: "https://www.apple.com", date: .now, imageData: nil),
        QRCodeItem(text: "WIFI:T:WPA;S:MyNetwork;P:password123;;", date: .now.addingTimeInterval(-3600), imageData: nil),
        QRCodeItem(text: "mailto:hello@example.com", date: .now.addingTimeInterval(-7200), imageData: nil),
        QRCodeItem(text: "tel:+1234567890", date: .now.addingTimeInterval(-10800), imageData: nil)
    ]
    
    private var collectionView: UICollectionView!
    
    //MARK: create headerView
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    
    private let segmentedControl = UISegmentedControl(
        items: ["Grid", "List"]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        setUpLayout()
    }
    
    private func setUpUI(){
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerView)
        view.addSubview(segmentedControl)

        setUpHeaderView()
        setUpSegmentedControl()
    }
    
    private func setUpLayout(){
        
        // Constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            
            scanButton.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor
            ),
            scanButton.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            scanButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Segmented control
            segmentedControl.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 24
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            segmentedControl.heightAnchor.constraint(
                equalToConstant: 36
            )
        ])
    }
    
    private func setUpHeaderView() {
        // Title
        titleLabel.text = "QRCode"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // Scan button
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setImage(
            UIImage(systemName: "qrcode.viewfinder"),
            for: .normal
        )
        scanButton.tintColor = .white
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.layer.cornerRadius = 10
        scanButton.configuration = .plain()
        scanButton.configuration?.image = UIImage(
            systemName: "qrcode.viewfinder"
        )
        scanButton.configuration?.title = "Scan"
        scanButton.configuration?.imagePadding = 8
        scanButton.configuration?.baseForegroundColor = .white
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(scanButton)
    }

    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0

        segmentedControl.addTarget(
            self,
            action: #selector(layoutChanged),
            for: .valueChanged
        )
    }
    
    @objc private func layoutChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Grid selected")
        case 1:
            print("List selected")
        default:
            break
        }
    }
}


#Preview {
    UINavigationController(rootViewController: QRCodesViewController()) 
}
