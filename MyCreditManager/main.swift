//
//  main.swift
//  MyCreditManager
//
//  Created by 홍세은 on 2023/04/17.
//

import Foundation

private var flag = true
private var myCreditManager: [String:[String:String]] = [String:[String:String]]()

enum InputError: Error {
    case wrongInput
    case duplicated(name: String)
    
    var debugDescription: String {
        switch self {
        case .wrongInput: return "잘못된 입력입니다. 다시 확인해주세요."
        case .duplicated(let name): return "\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다."
        }
    }
}
private func isWrongInput(input: String) -> Bool { // 숫자, 영문만 가능
    let result = input.filter{ !(("0"..."9").contains($0) || ("a"..."z").contains($0) || ("A"..."Z").contains($0))}
    if result != "" {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
        return false }
    return true
}

private func gradeToScore(grade: String) -> Double {
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2
    case "D+":
        return 1.5
    case "D":
        return 1.0
    case "F":
        return 0
    default:
        return -1
    }
}

private func addStudent(name: String) throws{
    if myCreditManager[name] != nil {
        throw InputError.duplicated(name: name)
    }
    else {
        myCreditManager[name] = [String:String]()
        print("\(name) 학생을 추가했습니다.")
    }
}

private func removeStudent(name: String) {
    if myCreditManager[name] != nil {
        myCreditManager[name] = nil
        print("\(name) 학생을 삭제하였습니다.")
    }
    else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

private func addScore(name: String, subject: String, grade: String) {
    if myCreditManager[name] != nil {
        if gradeToScore(grade: grade) == -1 {
            print("성적이 잘못 입력되었습니다. A+,A,B+,B,C+,C,D+,D,F로 성적을 입력해주세요.")
            return
        }
        myCreditManager[name]?[subject] = grade
        print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
    }
    else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

private func removeScore(name: String, subject: String) {
    if myCreditManager[name] != nil {
        if  myCreditManager[name]?[subject] == nil {
            print("\(name) 학생의 \(subject) 과목을 찾지 못했습니다.")
            return
        }
        myCreditManager[name]?[subject] = nil
        print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
    }
    else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

private func showGrade(name: String) {
    var totalScore: Double = 0
    if let dic = myCreditManager[name] {
        if(dic.count == 0) {
            print("조회할 성적이 없습니다. 성적을 추가해 주세요")
            return
        }
        for key in dic.keys {
            if let value = dic[key] {
                totalScore += gradeToScore(grade: value)
                print("\(key): \(value)")
            }
        }
        let result: Double = totalScore / Double(dic.count)
        print("평점: \(floor(result * 100) / 100)")
    }
    else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

while(flag) {
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    let inputFunc = readLine()!
    switch inputFunc {
    case "1":
        print("추가할 학생의 이름을 입력해주세요")
        let inputName = readLine()!
        if !isWrongInput(input: inputName) { break }
        do { try addStudent(name: inputName)} catch { print(error)}
        break
    case "2":
        print("삭제할 학생의 이름을 입력해주세요")
        let inputName = readLine()!
        if !isWrongInput(input: inputName) { break }
        removeStudent(name: inputName)
        break
    case "3":
        print("성적을 추가할 학생의 이름, 과목이름, 성적(A+,A,F등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력 예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당과목이 존재하면 기존점수가 갱신됩니다.")
        let input = readLine()!
        let result = input.components(separatedBy: " ")
        if(result.count != 3) {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            break
        }
        addScore(name: result[0], subject: result[1], grade: result[2])
        break
    case "4":
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력 예) Mickey Swift")
        let input = readLine()!
        let result = input.components(separatedBy: " ")
        if(result.count != 2) {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            break
        }
        removeScore(name: result[0], subject: result[1])
        break
    case "5":
        print("평점을 알고싶은 학생의 이름을 입력해주세요")
        let inputName = readLine()!
        if !isWrongInput(input: inputName) { break }
        showGrade(name: inputName)
        break
    case "X":
        print("프로그램을 종료합니다...")
        flag = false
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5사이의 숫자 혹은 X를 입력해주세요.")
        break;
    }
}
