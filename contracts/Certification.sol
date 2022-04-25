// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Certification {
    mapping(address => bool) public Issuers;
    mapping(address => bool) public Students;

    /**
     * @dev Verifies if the message sender is a registered certificate issuer.
     */
    modifier onlyCertificateIssuer() {
        require(isCertificateIssuer(msg.sender));
        _;
    }

    /**
     * @dev Verifies if the address is a certificate issuer address
     * @param _addressToValidate The address to validate if it is a certificate issuer address.
     */
    function isCertificateIssuer(address _addressToValidate)
        public
        view
        returns (bool)
    {
        return Issuers[_addressToValidate];
    }
}
