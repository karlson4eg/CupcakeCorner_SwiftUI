//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Evi St on 4/13/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var alertTitle = ""
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showingConfirmation){
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        // 1 conver order object to JSON
        // 2 tell sqift how to send the ddata
        // 3 run the request
        
        //1
        guard let encoded =  try? JSONEncoder().encode(order) else {
            print("Failed to encode the order")
            return
        }
        
        //2
        let url = URL(string: "https://reqres.in/api/cupcakes")! // can fail so we force unwrap it
        var request = URLRequest(url: url)
        request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //3
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //handle the result
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Thank you!"
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcake is on its way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed")
            alertTitle = "Oopsie daisy!"
            confirmationMessage = "Something went wrong, please try again sometime =)"
            showingConfirmation = true

        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
