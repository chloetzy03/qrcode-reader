//
//  QRCodeItem.swift
//  qrcode-reader
//
//  Created by Chloe Tay on 29/10/26.
//

/* It needs to hold:

The text inside the QR (e.g. https://www.apple.com)
The date you scanned it
A unique ID (so the app can tell two cards apart even if the text is identical)
*/

import Foundation
import UIKit

struct QRCodeItem: Codable, Identifiable {
    var id = UUID()          // Unique ID for each card
    let text: String         // The text hidden inside the QR code
    let date: Date           // The date and time user scanned it
    let imageData: Data? = nil   // Stored as Data so it works with Codable
    
    // A helper property to easily get a UIImage when you need to display it
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}
