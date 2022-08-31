//
//  CreateFormValidatorTests.swift
//  K-BattleTests
//
//  Created by Alexis Orellano on 8/31/22.
//

import XCTest
@testable import K_Battle

class CreateFormValidatorTests: XCTestCase {
    private var validator: CreateValidator!
    
    override func setUp() {
        validator = CreateValidator()
    }
    
    override func tearDown() {
        validator = nil
    }
    
    func test_with_empty_user_username_error_thrown() {
        let user = RegistrationDetails.new
        
        XCTAssertThrowsError(try validator.validate(user, and: UIImage()), "Error for an empty username should be thrown")
        
        do {
            _ = try validator.validate(user, and: UIImage())
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidUsername, "Expecting an error where we have an inavalid username")
        }
        
    }
    
    func test_with_empty_email_error_thrown() {
        let user = RegistrationDetails(email: "", password: "password", username: "username", profilePicUrl: "pic")

        XCTAssertThrowsError(try validator.validate(user, and: UIImage(named: "pic")))
        
        do {
            _ = try validator.validate(user, and: UIImage(named: user.profilePicUrl))
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidEmail, "Expecting an error where we have a invalid email")
        }
        
    }
    
    func test_with_empty_password_error_thrown() {
        let user = RegistrationDetails(email: "email", password: "", username: "username", profilePicUrl: "pic")
        
        XCTAssertThrowsError(try validator.validate(user, and: UIImage(named: "pic")))
        
        do {
            _ = try validator.validate(user, and: UIImage(named: user.profilePicUrl))
        } catch {
            guard let validationError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            XCTAssertEqual(validationError, CreateValidator.CreateValidatorError.invalidPassword, "Expecting an error where we have a invalid password")
        }
    }
    
    func test_with_empty_profilePic_error_thrown() {
        let user = RegistrationDetails(email: "email", password: "password", username: "username", profilePicUrl: "")
        XCTAssertThrowsError(try validator.validate(user, and: UIImage(named: "")))
        
        do {
            _ = try validator.validate(user, and: UIImage(named: user.profilePicUrl))
        } catch {
            guard let validatorError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got the wrong type of error expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validatorError, CreateValidator.CreateValidatorError.invalidProfilePic)
        }
        
    }
    
    func test_with_valid_user_error_not_thrown() {
        let user = RegistrationDetails(email: "email", password: "password", username: "username", profilePicUrl: "pic")
        
        do {
            _ = try validator.validate(user, and: UIImage(named: user.profilePicUrl))
        } catch {
            XCTFail("No errors should be thrown, cince the person should be valid object")
        }
    }
}
