//
//  PDFViewController.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    var pdfUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView.autoScales = true
        
        if let url = URL(string: pdfUrl) {
            loadPDF(from: url)
        }
    }
    
    func loadPDF(from url: URL) {
        DispatchQueue.global().async {
            if let pdfDocument = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    self.pdfView.document = pdfDocument
                }
            } else {
                print("Failed to load PDF document.")
            }
        }
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
