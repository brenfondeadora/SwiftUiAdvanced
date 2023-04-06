//
//  ProfileView.swift
//  SwiftUiAdvanced
//
//  Created by Brenda Saavedra  on 04/04/23.
//

import SwiftUI
import RevenueCat

struct ProfileView: View {
    @State private var showLoader: Bool = false
    @State private var iapButtonTitle = "Purchase Lifetime Pro Plan"
   
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("pink-gradient-1"))
                                .frame(width: 66, height: 66, alignment: .center)
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium, design: .rounded))
                        }
                        .frame(width: 66, height: 66, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("Brenda Saavedra")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            TextFieldIcon(iconName:"gearshape.fill", currentlyEditing: .constant(true))
                        })
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    Text("Student at Design+Code")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    Label("Awarded 10 certificates since July 2020", systemImage: "calendar")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    HStack(spacing: 16) {
                        Image("Twitter")
                            .resizable()
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 24, height: 24, alignment: .center)
                        Image(systemName: "link")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Text("brenda.saavedra.com")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }
                .padding(16)
                
                GradientButton(buttonTitle: iapButtonTitle, buttonAction: {
                    showLoader = true
                    Purchases.shared.getOfferings { offerings, error in
                        if let packages = offerings?.current?.availablePackages {
                            Purchases.shared.purchase(package: packages.first!) { transaction, purchaserInfo, error, userCancelled in
                                print("TRANSACTION: \(transaction)")
                                print("PURCHASER INFO: \(purchaserInfo)")
                                print("ERROR: \(error)")
                                print("USERCANCELLED: \(userCancelled)")
                                
                                showLoader = false
                                
                                if purchaserInfo?.entitlements["pro"]?.isActive == true {
                                    iapButtonTitle = "Purchase Successful"
                                } else{
                                    iapButtonTitle = "Purchase Failed"
                                }
                            }
                        } else{
                            showLoader = false
                        }
                    }
                })
                .padding(.horizontal, 16)
                
                Spacer().frame(height: 30)
                
                Button(action:{
                    showLoader = true
                    Purchases.shared.restorePurchases { purchaserInfo, error in
                        if let info = purchaserInfo {
                            showLoader = false
                            if info.allPurchasedProductIdentifiers.contains("lifetim_pro_plan") {
                                iapButtonTitle = "Restore Successful"
                            } else {
                                iapButtonTitle = "No Purchases Found"
                            }
                        } else {
                            showLoader = false
                            iapButtonTitle = "Restore Failed"
                        }
                    }
                }, label: {
                    GradientText(text:"Restore Purchases").font(.footnote.bold())
                })
                .padding(.bottom)
                
                Spacer().frame(height: 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 60)
            )
            .cornerRadius(30)
            .padding(.horizontal)
            
            VStack {
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0.0, y: 0.0, z:1.0))
                        .background(
                            Circle()
                                .stroke( Color.white.opacity(0.2), lineWidth: 1 )
                                .frame(width: 42, height: 42, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                )
                        )
                })
            }
            .padding(.bottom, 64)
            
            if showLoader {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .colorScheme(.dark)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
