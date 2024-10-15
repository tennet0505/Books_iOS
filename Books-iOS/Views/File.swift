//
//  File.swift
//  Books-iOS
//
//  Created by Oleg Ten on 15/10/2024.
//


 let book = viewModel.filteredBooks[indexPath.row]
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.bookId = book.id
        self.navigationController?.pushViewController(vc, animated: true)