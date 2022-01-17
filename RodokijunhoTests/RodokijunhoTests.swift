//
//  RodokijunhoTests.swift
//  RodokijunhoTests
//
//  Created by 福田正知 on 2022/01/17.
//

import XCTest
@testable import Rodokijunho

class RodokijunhoTests: XCTestCase {
        
    override func setUp(){
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    let shindanViewModel = ShindanViewModel()
    
    func testShindanViewModelCount() {
        XCTAssertEqual(shindanViewModel.count, 0)
    }
    
    func testShindanViewModelAddCount(){
        XCTAssertEqual(shindanViewModel.count, 0)
        shindanViewModel.addCount()
        XCTAssertEqual(shindanViewModel.count, 1)
    }
    
    let quizViewModel = QuizViewModel()
    
    func testQuizViewModelLoadCSV() {
        let csvArray = quizViewModel.loadCSV(fileName: "quiz1")
        XCTAssertEqual(csvArray.count, 30)
    }
    
    func testPerformance() {
        measure {
            let (a, b) = quizViewModel.getAnswerRecord(quizNumber: 1)
            XCTAssertNotNil(a)
            XCTAssertNotNil(b)
        }
    }
    
    let resultListViewModel = ResultListViewModel()
    
    func testResultListViewModel() {
        XCTAssertEqual(resultListViewModel.totalNumberOfQuiz, 30)
    }
    
}
