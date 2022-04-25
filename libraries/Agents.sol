// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

library Agents {
    struct Company {
        string name;
        string description;
        string details;
        bool isRegistered;
    }

    struct Academy {
        string name;
        string description;
        string details;
        bool isRegistered;
    }

    struct User {
        string name;
        string identification;
        bool isRegistered;
    }

    struct Certificate {
        string course;
        string description;
        address issuer;
        address student;
        int256 issuedAt;
        bool isRegistered;
    }

    struct WorkExperience {
        string position;
        string description;
        address company;
        address employee;
        int256 startedAt;
        int256 endedAt;
        bool isRegistered;
    }
}
