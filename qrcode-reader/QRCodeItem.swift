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

struct QRCodeItem: Codable, Identifiable {
    var id = UUID() //unique ID for each card
    let text: String //the text hidden inside the QR code
    let date: Date //the date and time user scanned it
}
