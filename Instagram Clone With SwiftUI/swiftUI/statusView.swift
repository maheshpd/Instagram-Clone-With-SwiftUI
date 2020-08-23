//
//  statusView.swift
//  Instagram Clone With SwiftUI
//
//  Created by Mahesh Prasad on 23/08/20.
//  Copyright © 2020 CreatesApp. All rights reserved.
//

import SwiftUI
import  SDWebImageSwiftUI

struct statusView : View {
    
    var url = ""
    var name = ""
    var body: some View {
        
        
        ZStack {
            AnimatedImage(url: URL(string: url)).resizable().edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text(name).font(.headline).fontWeight(.heavy).padding()
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
}
