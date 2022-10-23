// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *  @title Students register
 *. @notice StudentsRegister is a smart contract to register the marks of students. The number of
 *          marks per student and its names are decided at contruct time. Only the contract owner
 *          can register a new student.
 */
contract StudentsRegister {
    struct Student {
        uint256 ID;
        string name;
        string surname;
        uint8[] marks;
        bool added;
    }
    address public owner;
    uint256 public nStudents;
    uint8 public nMarks;
    string[] public markNames;
    mapping(address => Student) public students;

    constructor(string[] memory markNames_) {
        require(
            markNames_.length > 0,
            "Length of markNames must be larger than 0"
        );
        owner = msg.sender;
        nMarks = uint8(markNames_.length);
        markNames = markNames_;
        nStudents = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyNewStudent(address student_) {
        require(students[student_].added == false, "Not new student");
        _;
    }

    modifier onlyAddedStudent(address student_) {
        require(students[student_].added == true, "Not added student");
        _;
    }

    modifier correctNumberMarks(uint8[] calldata marks_) {
        require(marks_.length == nMarks, "Bad length of marks vector");
        _;
    }

    function registerStudent(
        address student_,
        string calldata name_,
        string calldata surname_,
        uint8[] calldata marks_
    ) external onlyOwner onlyNewStudent(student_) correctNumberMarks(marks_) {
        nStudents += 1;
        students[student_] = Student(nStudents, name_, surname_, marks_, true);
    }

    function getAverageMark(address student_)
        external
        view
        onlyAddedStudent(student_)
        returns (uint8)
    {
        uint8 sum = 0;
        Student storage myStudent = students[student_];
        for (uint8 i = 0; i < nMarks; ++i) {
            sum += myStudent.marks[i];
        }
        //Round-off applied
        uint8 average = (sum + nMarks / 2) / nMarks;
        return (average);
    }

    function getTotalMark(address student_)
        external
        view
        onlyAddedStudent(student_)
        returns (uint8)
    {
        uint8 sum = 0;
        Student storage myStudent = students[student_];
        for (uint8 i = 0; i < nMarks; ++i) {
            sum += myStudent.marks[i];
        }
        return (sum);
    }

    function getStudentDetails(address student_)
        external
        view
        onlyAddedStudent(student_)
        returns (Student memory)
    {
        return students[student_];
    }

    function getMarkName(uint8 markID_) external view returns (string memory) {
        require(markID_ < nMarks, "markID_ out of range");
        return markNames[markID_];
    }

    function getStudentMark(address student_, uint8 markID_)
        external
        view
        onlyAddedStudent(student_)
        returns (uint8)
    {
        require(markID_ < nMarks, "markID_ out of range");
        return students[student_].marks[markID_];
    }
}
