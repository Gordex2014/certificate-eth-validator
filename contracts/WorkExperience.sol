// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import {Agents} from "../libraries/Agents.sol";

contract WorkExperience {
    address public admin;

    using Agents for Agents.Company;
    using Agents for Agents.User;
    using Agents for Agents.WorkExperience;

    mapping(address => Agents.Company) public Companies;
    mapping(address => Agents.User) public Employees;

    /**
     * @dev Sets the contract deployer as the admin.
     */
    constructor() {
        admin = msg.sender;
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
    }

    /**
     * @dev Verifies if the message sender is the admin of the contract.
     */
    modifier onlyAdmin() {
        require(msg.sender == admin);
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
}
