//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Evi St on 4/8/22.
//

import SwiftUI

/*
 
 class User: ObservableObject, Codable {
 
 enum CodingKeys: CodingKey{
 case name
 }
 
 @Published var name = "Evi St"
 
 required init(from decoder: Decoder) throws {
 let container = try decoder.container(keyedBy: CodingKeys.self)
 name = try container.decode(String.self, forKey: .name)
 }
 
 func encode(to encoder: Encoder) throws {
 var container = encoder.container(keyedBy: CodingKeys.self)
 try container.encode(name, forKey: .name)
 }
 
 }
 /// container with keys instead of  _userdefaults_
 
 struct Resposne: Codable {
 var results: [Result]
 }
 
 struct Result: Codable {
 var trackId: Int
 var trackName: String
 var collectionName: String
 }
 
 */

struct ContentView: View {
    
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    Picker("Select your cupcake type", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Amount of cupcakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add sprinkles", isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
