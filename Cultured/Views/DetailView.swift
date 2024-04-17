//
//  DetailView.swift
//  Cultured
//
//  Created by Arina Shah on 4/15/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var vm: ViewModel
    @Binding var image: String
    @Binding var title: String
    @Binding var description: String
    @State var uiImage: UIImage? = nil
    //var color: Color = Color.cBar
    var body: some View {
        ZStack {
            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 10) // Adjust corner radius as needed
                .fill(Color.cPopover) // Set the fill color of the rounded rectangle
            
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(color, lineWidth: 5) // Set border color and width
//                )
                .frame(width: 304, height: 550)
            
            VStack(alignment: .center) {
                if let uiImage = uiImage {
                    Image(uiImage: uiImage).resizable().scaledToFill().frame(width: 304, height: 200)//.clipShape(RoundedRectangle(cornerRadius: 10))
                        //.offset(y: 5)
                        .clipShape(TopRoundedRectangle(topLeftRadius: 10, topRightRadius: 10))
                } else {
                    // Placeholder image or loading indicator
                    ProgressView()
                        .frame(width: 304, height: 100)
                }
                
                                
                Text(title).font(Font.custom("Quicksand-Bold", size: 35)).multilineTextAlignment(.center).padding().background(Color.cPopover)
                ScrollView(.vertical) {
                    Text(description).padding().font(Font.custom("Quicksand-Medium", size: 20)).minimumScaleFactor(0.3)
                }
                Spacer()
            }.frame(width: 304, height: 550)
        }.onAppear {
            vm.getImage(imageName: image) { img in
                uiImage = img
            }
        }
    }
}

struct TopRoundedRectangle: Shape {
    var topLeftRadius: CGFloat = 10
    var topRightRadius: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start at the top left, moving in by the radius to begin the arc
        path.move(to: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY))

        // Top left corner arc
        path.addArc(center: CGPoint(x: rect.minX + topLeftRadius, y: rect.minY + topLeftRadius),
                    radius: topLeftRadius,
                    startAngle: Angle(degrees: 180),
                    endAngle: Angle(degrees: 270),
                    clockwise: false)

        // Top edge
        path.addLine(to: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY))

        // Top right corner arc
        path.addArc(center: CGPoint(x: rect.maxX - topRightRadius, y: rect.minY + topRightRadius),
                    radius: topRightRadius,
                    startAngle: Angle(degrees: 270),
                    endAngle: Angle(degrees: 0),
                    clockwise: false)

        // Right vertical edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))

        // Close the path by connecting back to the start
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeftRadius))

        return path
    }
}

//#Preview {
//    DetailView(title: "Title", description: "Description")
//}
