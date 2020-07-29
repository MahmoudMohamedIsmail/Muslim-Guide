//
//  QiblaDirectionView.swift
//  Muslim Guide
//
//  Created by macboock pro on 7/26/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import SwiftUI

struct QiblaDirectionView: View {
  @ObservedObject var qiblaDirectionViewModel:QiblaDirectionViewModel
    init() {
        self.qiblaDirectionViewModel = QiblaDirectionViewModel()
    }
    var body: some View {
        
        
        ZStack(alignment: .center){
            ZStack(alignment: .top){
                ZStack(alignment: .top){
                    
                    Circle().stroke(lineWidth: 10)
                        .fill(Color.gray)
                        .frame(width: 0.80*UIScreen.screenWidth, height:  0.80*UIScreen.screenWidth)
        
                    Image(systemName: "arrowtriangle.up.fill")
                        .resizable()
                        .frame(width: 0.10*UIScreen.screenWidth, height: 0.325*UIScreen.screenWidth)
                        .foregroundColor(qiblaDirectionViewModel.trueDirection ? .green:.red).offset( y:  0.075*UIScreen.screenWidth)
                }.rotationEffect(Angle(degrees: Double(qiblaDirectionViewModel.angel)))
                
                    Image("kaaba2").resizable().frame(width: 0.15*UIScreen.screenWidth, height: 0.15*UIScreen.screenWidth).offset( y:  -0.075*UIScreen.screenWidth)
            }
            
            Circle()
                .fill(Color.white)
                .frame(width: 0.12*UIScreen.screenWidth, height:  0.12*UIScreen.screenWidth)
           Circle()
            .fill(Color.gray)
            .frame(width: 0.10*UIScreen.screenWidth, height:  0.10*UIScreen.screenWidth)
            Circle().fill(qiblaDirectionViewModel.trueDirection ? Color.green:Color.red)
                .frame(width: 0.05*UIScreen.screenWidth, height:  0.05*UIScreen.screenWidth)
        }
        
    }
}

struct QiblaDirectionView_Previews: PreviewProvider {
    static var previews: some View {
        QiblaDirectionView()
    }
}
