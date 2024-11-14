//
//  Calculator.swift
//  Calculator
//
//  Created by 翁子翔 on 2024/10/19.
//

import SwiftUI

class Calculator: ObservableObject {
    @Published var display = "0"      // 顯示結果
    private var inputExpression = ""  // 計算式
    // 匯率
    let exchangeRates: [String: Double] = [
        "TWD": 1.0,
        "USD": 0.03,
        "JPY": 4.79,
        "KRW": 43.06,
        "CNY": 0.22,
        "EUR": 0.03,
        "GBP": 0.02
    ]
    // 按鈕點擊
    func buttonTapped(_ button: String) {
        switch button {
        case "AC":
            inputExpression = ""
            display = "0"
        case "+/-":
            if let firstChar = inputExpression.first, firstChar == "-" {
                inputExpression.removeFirst()
            } else {
                inputExpression = "-" + inputExpression
            }
            display = inputExpression
        case "=":
            calculateResult()
        default:
            if inputExpression == "0" && button != "." {
                inputExpression = button
            } else {
                inputExpression += button
            }
            display = inputExpression
        }
    }
    // 匯率轉換
    func convertCurrency(from: String, to: String) {
        guard let fromRate = exchangeRates[from], let toRate = exchangeRates[to],
              let inputValue = Double(display) else {
            display = "Error"
            return
        }
        let result: Double
        let baseValue = inputValue / fromRate
        result = baseValue * toRate
        display = formatNumber(result)
    }
    // 計算
    private func calculateResult() {
        inputExpression.replace("x", with: "*") // NSExpression讀 ＊
        inputExpression.replace("÷", with: "/") // NSExpression讀 /
        // NSExpression 中沒有 ％
        if inputExpression.contains("%") {
            let components = inputExpression.split(separator: "%")
            if components.count == 2,
               let leftValue = Double(components[0]),
               let rightValue = Double(components[1]) {
                let result = leftValue.truncatingRemainder(dividingBy: rightValue)
                if result == floor(result) {
                    display = String(Int(result))
                } else {
                    display = formatNumber(result)
                }
                inputExpression = display
                return
            }
        }
        // NSExpression 中 / 會整除
        if inputExpression.contains("/") {
            let components = inputExpression.split(separator: "/")
            if components.count == 2,
               let leftValue = Double(components[0]),
               let rightValue = Double(components[1]) {
                if rightValue == 0 {
                    display = "除以零"
                    return
                }
                let result = leftValue / rightValue
                if result == floor(result) {
                    display = String(Int(result))
                } else {
                    display = formatNumber(result)
                }
                inputExpression = display
                return
            }
        }
        // 使用 NSExpression 來計算
        let expr = NSExpression(format: inputExpression)
        if let result = expr.expressionValue(with: nil, context: nil) as? NSNumber {
            display = result.stringValue // NSNumber 轉換 String
            inputExpression = display
        } else {
            display = "Error"
        }
    }
    // 去除多餘的0
    private func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0 // 數字後沒有小數位，不顯示小數點
        formatter.maximumFractionDigits = 7 // 最多顯示7位小數
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}
