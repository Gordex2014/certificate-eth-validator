// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Certification {
    address superAdmin;
    address[] public certificateIssuers;
    address[] public companies;
    address[] public commonUsers;

    struct Certificate {
        address student;
        address issuer;
        string title;
        string description;
        uint256 date;
    }

    struct WorkExperience {
        address user;
        address company;
        string workPosition;
        string description;
        uint256 startDate;
        uint256 endDate;
    }

    /**
     * @dev Sets the super admin of the certification contract.
     */
    constructor() {
        superAdmin = msg.sender;
    }

    /**
     * @dev Verifies if the message sender is the super admin.
     */
    modifier onlySuperAdmin() {
        require(superAdmin == msg.sender);
        _;
    }

    /**
     * @dev Verifies if the message sender is a registered certificate issuer.
     */
    modifier onlyCertificateIssuer() {
        require(isCertificateIssuer(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the message sender is a registered company.
     */
    modifier onlyCompanies() {
        require(isCompany(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the address is a certificate issuer address
     * @param _addressToValidate The address to validate if it is a certificate issuer address.
     */
    function isCertificateIssuer(address _addressToValidate)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < certificateIssuers.length; i++) {
            if (certificateIssuers[i] == _addressToValidate) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev Verifies if the address is a company address
     * @param _addressToValidate The address to validate if it is a company address.
     */
    function isCompany(address _addressToValidate)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < companies.length; i++) {
            if (companies[i] == _addressToValidate) {
                return true;
            }
        }
        return false;
    }
}
