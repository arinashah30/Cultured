//
//  ActivityView.swift
//  Cultured
//
//  Created by Arina Shah on 2/6/24.
//

import SwiftUI

struct ActivityView: View {
    @ObservedObject var vm: ViewModel
    @State var badgePopUp: Bool = false
    @State var selectedBadge: String? = nil
    //let badges = ["1MonthStreakBadge", "3ContinentsCompleteBadge", "3CountriesBadge", "7DaysStreakBadge", "50PointsBadge", "100PointsBadge", "arTourBadge", "FranceBadge", "IndiaBadge", "MexicoBadge", "Top3Badge", "1MonthStreakBadge", "3ContinentsCompleteBadge", "3CountriesBadge", "7DaysStreakBadge", "50PointsBadge", "100PointsBadge", "arTourBadge", "FranceBadge", "IndiaBadge", "MexicoBadge", "Top3Badge"]
    var badges: [String]
    @State var maxRows = 2
    @State var columns = 5
    @State var showAllBadges = false

    var body: some View {
        let lightOrange = Color(red: 255/255, green: 241/255, blue: 220/255, opacity: 1)
        let rowNumber = (Int(ceil((Double(badges.count)/5.0))))

        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading){
                    Text("Activity")
                        .foregroundColor(.cDarkGray)
                        .font(Font.custom("Quicksand-SemiBold", size: 32))
                        .padding(.bottom, 10)
                    Text("Badges")
                        .font(Font.custom("Quicksand-Medium", size: 24))
                    
                        VStack(alignment: .leading, spacing: 10) {
                            
                            if (showAllBadges) {
                                ForEach(0..<(rowNumber)) { rowIndex in
                                    HStack(spacing: 10) {
                                        ForEach(0..<5) { columnIndex in
                                            let badgeIndex = rowIndex * self.columns + columnIndex
                                            if badgeIndex < self.badges.count {
                                                Image(self.badges[badgeIndex])
                                                    .resizable()
                                                    .frame(width: 58, height: 58)
                                                    .onTapGesture {
                                                        self.selectedBadge = self.badges[badgeIndex]
                                                        self.badgePopUp = true
                                                    }
                                            }
                                        }
                                    }
                                }
                            } else {
                                ForEach(0..<2) { rowIndex in
                                    HStack(spacing: 10) {
                                        ForEach(0..<5) { columnIndex in
                                            let badgeIndex = rowIndex * self.columns + columnIndex
                                            if badgeIndex < self.badges.count {
                                                Image(self.badges[badgeIndex])
                                                    .resizable()
                                                    .frame(width: 58, height: 58)
                                                    .onTapGesture {
                                                        self.selectedBadge = self.badges[badgeIndex]
                                                        self.badgePopUp = true
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                showAllBadges.toggle()
                            } label: {
                                Text(showAllBadges ? "See Less" : "See More")
                                    .padding(.leading, 270)
                                    .padding(.top, 5)
                                    .font(Font.custom("Quicksand-Medium", size: 15))
                                    .foregroundColor(.cMedGray)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.cBar)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    
                    Text("Streak")
                        .font(Font.custom("Quicksand-Medium", size: 24))
                        .padding(.bottom, 10)
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 177, height: 188)
                                .clipShape(.rect(cornerRadius: 14))
                                .foregroundColor(.cBar)
                            VStack {
                                Text("Current Streak")
                                    .font(.system(size: 20))
                                    .foregroundColor(.cDarkGray)
                                Image("Streak")
                                    .resizable()
                                    .frame(width: 60, height: 70)
                                Text("\(vm.current_user?.streak ?? 0) Days")
                                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                                    .foregroundColor(.cDarkGray)
                            }
                            
                        }
                        
                        ZStack {
                            Rectangle()
                                .frame(width: 177, height: 188)
                                .clipShape(.rect(cornerRadius: 14))
                                .foregroundColor(.cBar)
                            VStack {
                                Text("All Time Record")
                                    .font(.system(size: 20))
                                    .foregroundColor(.cDarkGray)
                                VStack {
                                    Image("Streak")
                                        .resizable()
                                        .frame(width: 31, height: 36)
                                        .padding(.bottom, -10)
                                    HStack {
                                        Image("Streak")
                                            .resizable()
                                            .frame(width: 31, height: 36)
                                        Image("Streak")
                                            .resizable()
                                            .frame(width: 31, height: 36)
                                    }
                                }
                                Text("\(vm.current_user?.streakRecord ?? 0) Days")
                                //Text("49 Days")
                                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                                    .foregroundColor(.cDarkGray)
                            }
                        }
                    }
                    .foregroundColor(.cPopover)
                    .padding(.top, -14)
                    Text("Points")
                        .font(Font.custom("Quicksand-Medium", size: 24))
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    ZStack {
                        Rectangle()
                            .foregroundColor(.cBar)
                            .frame(width: 361, height: 70)
                            .clipShape(.rect(cornerRadius: 14))
                            .padding(.top, -14)
                        //VStack {
                            HStack {
                                Text("Total")
                                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                                    .foregroundColor(.cDarkGray)
                                    //.padding(.trailing, 60)
                                Spacer()
                                Text("\(vm.current_user?.points ?? 0)")
                                    .font(Font.custom("Quicksand-SemiBold", size: 32))
                                    .foregroundColor(.cDarkGray)
                                Image("StarBadge")
                            }
                            .padding()
                            .padding(.bottom, 15)
                            //.frame(width: UIScreen.main.bounds.size.width - 20)
                            
//                            Divider()
//                                .frame(maxWidth: 320, minHeight: 4)
//                                .background(.gray)
//                            
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("Completed quiz")
//                                    Text("Date + Time")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(.cMedGray)
//                                }
//                                .padding(.trailing, 110)
//                                Text("+10")
//                                Image("StarBadge")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                            }
//                            .padding(.top, 15)
                            
                        //}
                        //.padding(.top, -70)
                    }
                    .frame(width: 361, height: 70)
                }
            }
        
            if badgePopUp {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        badgePopUp = false
                        selectedBadge = nil
                    }
                if let selectedBadge = selectedBadge {
                    BadgePopUp(badgePopUp: $badgePopUp, selectedBadge: selectedBadge)
                        .zIndex(1)
                    }
                BadgePopUp(badgePopUp: $badgePopUp, selectedBadge: selectedBadge)
                    .zIndex(1)
                }
            }
        }
    func calculateRowsToShow() -> Int {
            let maxRows = 2
            let totalRows = (Int(ceil((Double(badges.count) / Double(columns)))))
            return showAllBadges ? totalRows : maxRows
        }
    }


struct BadgePopUp: View {
    
    @Binding var badgePopUp: Bool
    var selectedBadge: String?
    
    var body: some View {
        
        ZStack {
            VStack (alignment: .leading) {
                ZStack (alignment: .leading) {
                    VStack {
                        Image(selectedBadge ?? "ShieldBadge")
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                    }
                    HStack {
                        Spacer()
                        Text("Badge Title")
                            .font(Font.custom("Quicksand-medium", size: 24))
                        Spacer()
                    }
                }
                
                Text("Date...")
                    .font(Font.custom("Quicksand-medium", size: 20))
                Text("Badge Information...")
                    .font(Font.custom("Quicksand-medium", size: 16))
            }
            .padding(20)
            .frame(maxWidth: 303, maxHeight: 151, alignment: .leading)
            .background(Color.cOrange)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .foregroundColor(Color("cDarkGrayConstant"))
            
            
            
            GeometryReader { geometry in
                Button(action: {
                    self.badgePopUp = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("cDarkGrayConstant"))
                        .frame(width: 12, height: 12)
                }.position(x: geometry.size.width - ((geometry.size.width - 303) / 2) - 12 - 12, y: ((geometry.size.height - 151) / 2) + 12 + 12)
            }
        }
        
    }
}

//#Preview {
//    ActivityView(vm: ViewModel())
//}

