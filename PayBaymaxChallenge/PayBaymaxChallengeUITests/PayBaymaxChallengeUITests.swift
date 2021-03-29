//
//  PayBaymaxChallengeUITests.swift
//  PayBaymaxChallengeUITests
//
//  Created by Tung Vu on 12/20/20.
//  Copyright © 2020 news. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxBlocking

class PayBaymaxChallengeUITests: XCTestCase {
    let disposeBag: DisposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInputAmount() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        runInputTest(with: app, amount: 10000, textFieldId: Constants.ExRateResultScene.amountTextFieldId)
        runInputTest(with: app, amount: 1500, textFieldId: Constants.ExRateResultScene.amountTextFieldId)
        runInputTest(with: app, amount: 4000, textFieldId: Constants.ExRateResultScene.amountTextFieldId)
        runInputTest(with: app, amount: 5000, textFieldId: Constants.ExRateResultScene.amountTextFieldId)
        runInputTest(with: app, amount: 7000, textFieldId: Constants.ExRateResultScene.amountTextFieldId)
    }
    
    private func runInputTest(with app:XCUIApplication , amount: Int, textFieldId: String ) {
        let txtAmount = app.otherElements.textFields[textFieldId]
        txtAmount.clearAndEnterText(text: "\(amount)")
        XCTAssertEqual(txtAmount.value as! String, "\(amount)", "Text field value is not correct")
    }
    
    func testExRateDisplayResult() {
        let app = XCUIApplication()
        app.launch()
        // first launch
        let exRateViewModel = injector.resolve(GetExchangeRateUseCase.self)!
        let apiExResultCount        = (try? exRateViewModel.execute(with: "USD").toBlocking().last()?.quotes.count) ?? -1
        let displayExResultCount    = app.otherElements.tables.cells.count
        XCTAssertEqual(apiExResultCount, displayExResultCount, "Number of exchange rate is not correct")
    }
}

fileprivate struct Constants {
    struct ExRateResultScene {
        static let amountTextFieldId    = "txtAmountTest"
        static let exRateCode           = "ExRateCode"
        static let exRateAmount         = "ExRateAmount"
        static let exRateValue          = "ExRateValue"
        
    }
}


extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
