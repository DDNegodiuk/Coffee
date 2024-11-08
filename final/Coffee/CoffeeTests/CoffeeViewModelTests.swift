/// Copyright (c) 2022 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import Coffee

@MainActor
final class CoffeeViewModelTests: XCTestCase {
  var model = CoffeeViewModel(coffeeDataStore: TestCoffeeDataStore())

  override func setUp() async throws {
    try await super.setUp()
    model = CoffeeViewModel(coffeeDataStore: TestCoffeeDataStore())
    try await model.updateCoffees()
  }

  func testCoffees() async throws {
    XCTAssertEqual(model.coffees.count, 2)
  }

  func testSaveNewCoffee() async throws {
    var coffeeToSave = CoffeeViewModel.newCoffee
    coffeeToSave.name = "Coffee"

    try await model.saveCoffee(coffeeToSave)

    XCTAssertEqual(model.coffees.count, 3)
  }

  func testSaveExistingCoffee() async throws {
    var coffeeToEdit = model.coffees[0]
    let newName = "New Coffee Name"
    coffeeToEdit.name = newName

    try await model.saveCoffee(coffeeToEdit)

    XCTAssertEqual(model.coffees[0].name, newName)
    XCTAssertEqual(model.coffees.count, 2)
  }

  func testSaveCoffeeWithEmptyName() async throws {
    var coffeeToSave = CoffeeViewModel.newCoffee
    coffeeToSave.name = ""

    do {
      try await model.saveCoffee(coffeeToSave)
      XCTFail("Coffee with no name should throw empty name error")
    } catch CoffeeViewModel.CoffeeError.emptyName {
      XCTAssert(model.showCoffeeErrorAlert)
      XCTAssertEqual(model.saveCoffeeError, .emptyName)
    } catch {
      XCTFail("Coffee with no name should throw empty name error")
    }
  }
}
