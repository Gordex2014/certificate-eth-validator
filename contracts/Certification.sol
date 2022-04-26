// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Agents} from "../libraries/Agents.sol";

contract Certification {
    using Agents for Agents.Academy;
    using Agents for Agents.User;
    using Agents for Agents.Certificate;

    mapping(address => bool) public Admins;
    mapping(address => Agents.Academy) public Academies;
    mapping(address => Agents.User) internal Students;
    mapping(address => Agents.Certificate[]) internal Certificates;

    /**
     * @dev New certificate issued event
     */
    event CertificateIssued(
        address indexed academy,
        address indexed certificate,
        string academyName,
        string courseName
    );

    /**
     * @dev New academy added event
     */
    event AcademyCreated(address indexed academyAddress, string academyName);

    /**
     * @dev Sets the contract deployer as the first admin.
     */
    constructor() {
        Admins[msg.sender] = true;
    }

    /**
     * @dev Gets the certificates for an specific student.
     * @param _studentAddress The student address.
     */
    function getUserCertificatesExperiences(address _studentAddress)
        public
        view
        returns (Agents.Certificate[] memory)
    {
        return Certificates[_studentAddress];
    }

    /**
     * @dev Adds a certificate to a registered student, this function can only be called by an academy address.
     * @param _studentAddress Is the address of the student.
     * @param _courseName The name of the course
     * @param _description A description of the course.
     * @param _issuedAt The date when the certificate was issued.
     */
    function addUserCertificate(
        address _studentAddress,
        string memory _courseName,
        string memory _description,
        uint256 _issuedAt
    ) public onlyAcademies {
        require(_isValidUser(_studentAddress));

        Certificates[_studentAddress].push(
            Agents.Certificate(
                _courseName,
                _description,
                msg.sender,
                Academies[msg.sender].name,
                _studentAddress,
                _issuedAt,
                true
            )
        );

        emit CertificateIssued(
            msg.sender,
            _studentAddress,
            Academies[msg.sender].name,
            _courseName
        );
    }

    /**
     * @dev Allows a normal user to register as a student.
     * @param _name The name of the user.
     * @param _identification The identification of the user (eg. ID).
     */
    function addStudent(string memory _name, string memory _identification)
        public
    {
        require(!_isValidUser(msg.sender));
        Students[msg.sender] = Agents.User(_name, _identification, true);
    }

    /**
     * @dev Adds a new academy to the list of companies.
     * @param _academyAddress The address of the academy to add.
     * @param _name The name of the academy.
     * @param _description The description of the academy.
     * @param _details Some details about the academy.
     */
    function addAcademy(
        address _academyAddress,
        string memory _name,
        string memory _description,
        string memory _details
    ) public onlyAdmin {
        require(_isValidAcademy(_academyAddress) == false);
        // Sets the company as registered.
        Academies[_academyAddress] = Agents.Academy(
            _name,
            _description,
            _details,
            true
        );

        emit AcademyCreated(_academyAddress, _name);
    }

    /**
     * @dev Add a new admin.
     * @param _adminAddress The address of the admin to add.
     */
    function addAdmin(address _adminAddress) public onlyAdmin {
        require(_isValidAcademy(_adminAddress) == false);
        // Sets the admin as registered.
        Admins[_adminAddress] = true;
    }

    /**
     * @dev Verifies if the message sender is the admin of the contract.
     */
    modifier onlyAdmin() {
        require(_isValidAdmin(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the message sender is a registered certificate issuer.
     */
    modifier onlyAcademies() {
        require(_isValidAcademy(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the address is a valid and a registered academy.
     * @param _addressToValidate The address to validate if it is a certificate issuer address.
     */
    function _isValidAcademy(address _addressToValidate)
        private
        view
        returns (bool)
    {
        return Academies[_addressToValidate].isRegistered;
    }

    /**
     * @dev Verifies if the address is a valid and registered user.
     * @param _addressToValidate The address to validate if it is a registered student address.
     */
    function _isValidUser(address _addressToValidate)
        private
        view
        returns (bool)
    {
        return Students[_addressToValidate].isRegistered;
    }

    /**
     * @dev Verifies if the address is a valid and registered admin.
     * @param _addressToValidate The address to validate if it is an admin address.
     */
    function _isValidAdmin(address _addressToValidate)
        private
        view
        returns (bool)
    {
        return Admins[_addressToValidate];
    }
}
