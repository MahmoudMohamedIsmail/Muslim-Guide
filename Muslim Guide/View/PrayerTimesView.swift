//
//  PrayerTimesView.swift
//  Muslim Guide
//
//  Created by macboock pro on 6/14/20.
//  Copyright © 2020 macboock pro. All rights reserved.
//

import SwiftUI
//MARK: - PrayerTimesView
struct PrayerTimesView: View {
    @ObservedObject var prayerTimesViewModel:PrayerTimesViewModel
    init() {
        self.prayerTimesViewModel=PrayerTimesViewModel()
    }
    var body: some View {
        ZStack{
            Image("sky").resizable().edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack{
                    TopPrayerTimesView(imageName: prayerTimesViewModel.earthRotationName, locationName: prayerTimesViewModel.currentCity.name, currentDate: prayerTimesViewModel.currentDate)
                    Spacer()
                }
                
                Spacer()
                //Remaining Time
                Text(prayerTimesViewModel.remainingTime).font(.headline)
                Spacer()
                VStack(spacing: 0){
                    
                    //Fajr Cell
                    PrayerTimeCell(prayerTimesViewModel: self.prayerTimesViewModel, alarmState:prayerTimesViewModel.alarmState.Fajr, prayerName: Constants.prayers[0], prayerTime: self.prayerTimesViewModel.todayPrayerTimes?.Fajr ?? "", backgroundWhite: true)
                    
                    //Dhuhr Cell
                    PrayerTimeCell(prayerTimesViewModel: self.prayerTimesViewModel, alarmState: prayerTimesViewModel.alarmState.Dhuhr , prayerName: Constants.prayers[1], prayerTime: self.prayerTimesViewModel.todayPrayerTimes?.Dhuhr ?? "", backgroundWhite: false)
                    
                    //Asr Cell
                    PrayerTimeCell(prayerTimesViewModel: self.prayerTimesViewModel, alarmState: prayerTimesViewModel.alarmState.Asr, prayerName: Constants.prayers[2], prayerTime: self.prayerTimesViewModel.todayPrayerTimes?.Asr ?? "", backgroundWhite: true)
                    
                    //Maghrib Cell
                    PrayerTimeCell(prayerTimesViewModel: self.prayerTimesViewModel, alarmState: prayerTimesViewModel.alarmState.Maghrib , prayerName: Constants.prayers[3], prayerTime: self.prayerTimesViewModel.todayPrayerTimes?.Maghrib ?? "", backgroundWhite: false)
                    
                    //Isha Cell
                    PrayerTimeCell(prayerTimesViewModel: self.prayerTimesViewModel, alarmState: prayerTimesViewModel.alarmState.Isha , prayerName: Constants.prayers[4], prayerTime: self.prayerTimesViewModel.todayPrayerTimes?.Isha ?? "", backgroundWhite: true)
                    
                    
                }.padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            }.padding(EdgeInsets(top: 20, leading: 1, bottom: 20, trailing: 0))
            
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.prayerTimesViewModel.setNextPrayer()
        }
    }
}

//MARK: - PrayerTimeCell
struct PrayerTimeCell:View
{
    @ObservedObject var prayerTimesViewModel:PrayerTimesViewModel
    var alarmState:Bool
    var prayerName:String
    var prayerTime:String
    var backgroundWhite:Bool
    var body: some View
    {
        HStack{
            Text(prayerName).padding()
            Spacer()
            Text(prayerTime).padding(.trailing, 20)
            Image(systemName: alarmState ? "bell":"bell.slash").padding().onTapGesture {
                
                if (self.prayerName=="Fajr") {
                    self.prayerTimesViewModel.updateAlarmSatate = 0
                }
                else if (self.prayerName=="Dhuhr")
                {
                    self.prayerTimesViewModel.updateAlarmSatate = 1
                }
                else if (self.prayerName=="Asr")
                {
                    self.prayerTimesViewModel.updateAlarmSatate = 2
                }
                else if (self.prayerName=="Maghrib")
                {
                    self.prayerTimesViewModel.updateAlarmSatate = 3
                }
                else if (self.prayerName=="Isha")
                {
                    self.prayerTimesViewModel.updateAlarmSatate = 4
                }
            }
            //.padding(.trailing, 1)
        }.background(backgroundWhite ? Color.white.opacity(0.7):Color.gray.opacity(0.7)).cornerRadius(5)
    }
}
//MARK: - Top view consist of  Earth rotation, location and date
struct TopPrayerTimesView:View {
    var imageName:String
    var locationName:String
    var currentDate:String
    @State var showLocation:Bool = false
    @State var showDate = false
    var body: some View
    {
        
        HStack(alignment: .top){
            ZStack(alignment: .leading){
                
                ZStack{
                    Rectangle().fill(Color.white).frame(height: (0.15*UIScreen.screenWidth))
                    HStack{
                        Image("location").resizable().frame(width: 25, height: 25)
                        Text(locationName)
                    }
                }.offset(x: showDate ? (0.30*UIScreen.screenWidth+20):20)
                
                ZStack{
                    Rectangle().fill(Color.white).frame(height: (0.15*UIScreen.screenWidth))
                    Text(currentDate)
                }.offset(x: showDate ? -UIScreen.screenWidth+20:-UIScreen.screenWidth-20)
                
                EarthRotationView(imageName: imageName, move: self.$showDate)
            }
        }.animation(.spring())
            .offset(x: showDate ? (0.70*UIScreen.screenWidth-20):20)
        
    }
}
//MARK: - Earth rotation
struct EarthRotationView:View {
    var imageName:String
    @Binding var move:Bool
    var body: some View
    {
        
        Image(imageName).resizable().frame(width: (0.30*UIScreen.screenWidth), height: (0.30*UIScreen.screenWidth)).clipShape(Circle()).shadow(radius:10).onTapGesture {
            self.move.toggle()
        }
    }
}

//struct PrayerTimesView_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
//MARK: - Extension to add two property (screenWidth and Height)
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
}

