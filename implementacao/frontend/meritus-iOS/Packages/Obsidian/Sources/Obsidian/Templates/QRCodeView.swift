//
//  QRCodeView.swift
//  Obsidian
//
//  Created by Arthur Porto on 28/11/25.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

public struct QRCodeView: View {
    private let string: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    public init(from string: String) {
        self.string = string
    }
    
    public var body: some View {
        if let uiImage = generateQRCode(from: string) {
            Image(uiImage: uiImage)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
        } else {
            Text("Não foi possível gerar o QR Code")
                .foregroundColor(.red)
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        filter.message = Data(string.utf8)
        
        guard let outputImage = filter.outputImage else { return nil }
        
        let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        
        if let cgimg = context.createCGImage(scaled, from: scaled.extent) {
            return UIImage(cgImage: cgimg)
        }
        
        return nil
    }
}
