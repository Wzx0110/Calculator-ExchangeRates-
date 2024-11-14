//
//  ContentView.swift
//  Calculator
//
//  Created by 翁子翔 on 2024/10/19.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var calculator = Calculator()
    @State private var fromCurrency = "TWD"
    @State private var toCurrency = "USD"
    @State private var showCurrencyConversion = false // 控制匯率顯示
    
    private let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["$", "0", ".", "="],
    ]
    
    var body: some View {
        VStack {
            Spacer()
            // 顯示畫面
            Text(calculator.display)
                .font(.system(size: 64))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .foregroundColor(.white)
                .background(Color.black)
            // 匯率換算
            if showCurrencyConversion {
                HStack {
                    // 左選擇
                    Picker("From", selection: $fromCurrency) {
                        ForEach(calculator.exchangeRates.keys.sorted(), id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    // 圖示
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                        .onTapGesture {
                            // 點擊交換方向
                            let temp = fromCurrency
                            fromCurrency = toCurrency
                            toCurrency = temp
                        }
                    // 右選擇
                    Picker("To", selection: $toCurrency) {
                        ForEach(calculator.exchangeRates.keys.sorted(), id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                // 匯率換算按鈕
                Button("Convert") {
                    calculator.convertCurrency(from: fromCurrency, to: toCurrency)
                }
                .font(.title)
                .frame(width: 200, height: 50)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(25)
                .padding(.bottom)
            }
            // 按鍵
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            if button == "$" {
                                showCurrencyConversion.toggle()
                            } else {
                                calculator.buttonTapped(button)
                            }
                        }) {
                            Text(button)
                                .font(.system(size: 32))
                                .frame(width: 80, height: 80)
                                .background(getButtonColor(for: button))
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    // 按鍵顏色
    private func getButtonColor(for button: String) -> Color {
        if button == "÷" || button == "x" || button == "-" || button == "+" || button == "=" {
            return Color.orange
        } else if button == "AC" || button == "+/-" || button == "%" {
            return Color.gray
        } else {
            return Color(red: 0.2, green: 0.2, blue: 0.2)
        }
    }
}

#Preview {
    ContentView()
}
