// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Agents} from "../libraries/Agents.sol";

contract WorkExperience {
    using Agents for Agents.Company;
    using Agents for Agents.User;
    using Agents for Agents.WorkExperience;

    mapping(address => bool) public Admins;
    mapping(address => Agents.Company) public Companies;
    mapping(address => Agents.User) internal Employees;
    mapping(address => Agents.WorkExperience[]) internal WorkExperiences;

    /**
     * @dev Work Experience event
     */
    event WorkExperienceCreated(
        address indexed company,
        address indexed workExperience,
        string companyName,
        string position
    );

    /**
     * @dev New company added event
     */
    event CompanyCreated(address indexed company, string companyName);

    /**
     * @dev Sets the contract deployer as the admin.
     */
    constructor() {
        Admins[msg.sender] = true;
    }

    /**
     * @dev Gets the work experiences registered for a specific employee.
     * @param _employee The employee address.
     */
    function getUserWorkExperiences(address _employee)
        public
        view
        returns (Agents.WorkExperience[] memory)
    {
        return WorkExperiences[_employee];
    }

    /**
     * @dev Adds work experience to a registered employee, this function can only be called by a company address.
     * @param _employee Is the address of the employee.
     * @param _position The position of the employee.
     * @param _description A description of the job.
     * @param _startedAt The date when the employee started the job.
     * @param _endedAt A description of the job.
     */
    function addUserWorkExperience(
        address _employee,
        string memory _position,
        string memory _description,
        uint256 _startedAt,
        uint256 _endedAt
    ) public onlyCompanies {
        require(_isValidUser(_employee));

        WorkExperiences[_employee].push(
            Agents.WorkExperience(
                _position,
                _description,
                msg.sender,
                Companies[msg.sender].name,
                _employee,
                _startedAt,
                _endedAt,
                true
            )
        );

        emit WorkExperienceCreated(
            msg.sender,
            _employee,
            Companies[msg.sender].name,
            _position
        );
    }

    /**
     * @dev Allows a normal user to register as a employee.
     * @param _name The name of the user.
     * @param _identification The identification of the user (eg. ID).
     */
    function addEmployee(string memory _name, string memory _identification)
        public
    {
        require(!_isValidUser(msg.sender));
        Employees[msg.sender] = Agents.User(_name, _identification, true);
    }

    /**
     * @dev Adds a new company to the list of companies.
     * @param _companyAddress The address of the company to add.
     * @param _name The name of the company.
     * @param _description The description of the company.
     * @param _details Some details about the company.
     */
    function addCompany(
        address _companyAddress,
        string memory _name,
        string memory _description,
        string memory _details
    ) public onlyAdmin {
        require(_isValidCompany(_companyAddress) == false);
        // Sets the company as registered.
        Companies[_companyAddress] = Agents.Company(
            _name,
            _description,
            _details,
            true
        );

        emit CompanyCreated(_companyAddress, _name);
    }

    /**
     * @dev Add a new admin.
     * @param _adminAddress The address of the admin to add.
     */
    function addCompany(address _adminAddress) public onlyAdmin {
        require(_isValidCompany(_adminAddress) == false);
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
    modifier onlyCompanies() {
        require(_isValidCompany(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the address is a valid and a registered company.
     * @param _addressToValidate The address to validate if it is a certificate issuer address.
     */
    function _isValidCompany(address _addressToValidate)
        private
        view
        returns (bool)
    {
        return Companies[_addressToValidate].isRegistered;
    }

    /**
     * @dev Verifies if the address is a valid and registered user.
     * @param _addressToValidate The address to validate if it is a certificate issuer address.
     */
    function _isValidUser(address _addressToValidate)
        private
        view
        returns (bool)
    {
        return Employees[_addressToValidate].isRegistered;
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
