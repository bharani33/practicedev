// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainBasedHealthcare {
    uint public patientCount;
    
    struct Doctor {
        string name;
        string designation;
        bool isRegistered;
    }

    struct Patient {
        bool isUIDGenerated;
        string name;
        uint age;
        string dob;
        uint cholesterol;
        uint restECG;
        uint bloodPressure;
    }

    mapping(address => Doctor) public doctorMapping;
    mapping(bytes32 => Patient) public patientMapping;
    mapping(uint => bytes32) public pid;

    // Step 1: Register a doctor with Ganache account address
    function registerDoctor(address _doctorAddress, string memory _name, string memory _designation) public {
        require(!doctorMapping[_doctorAddress].isRegistered, "Doctor already registered");
        
        doctorMapping[_doctorAddress] = Doctor({
            name: _name,
            designation: _designation,
            isRegistered: true
        });
    }

    // Step 2: Generate a Unique ID using a given ID input
    function generateUniqueID(uint _id) public view returns (bytes32) {
        return sha256(abi.encodePacked(_id, block.timestamp, msg.sender));
    }

    // Step 3: Register the patient using the generated Unique ID
    function registerPatient(
        bytes32 uniqueID,
        string memory _name,
        uint _age,
        string memory _dob,
        uint _cholesterol,
        uint _restECG,
        uint _bloodPressure
    ) public {
        require(!patientMapping[uniqueID].isUIDGenerated, "Unique ID already exists");

        patientMapping[uniqueID] = Patient({
            isUIDGenerated: true,
            name: _name,
            age: _age,
            dob: _dob,
            cholesterol: _cholesterol,
            restECG: _restECG,
            bloodPressure: _bloodPressure
        });

        pid[patientCount] = uniqueID;
        patientCount++;
    }

    // Function to retrieve patient details using Unique ID
    function getPatientDetails(bytes32 _uniqueID)
        public
        view
        returns (
            string memory,
            uint,
            string memory,
            uint,
            uint,
            uint
        )
    {
        require(patientMapping[_uniqueID].isUIDGenerated, "Patient not found");

        Patient memory p = patientMapping[_uniqueID];
        return (p.name, p.age, p.dob, p.cholesterol, p.restECG, p.bloodPressure);
    }

    // Function to get doctor details using their address
    function getDoctorDetails(address _doctorAddress) public view returns (string memory, string memory) {
        require(doctorMapping[_doctorAddress].isRegistered, "Doctor not found");
        return (doctorMapping[_doctorAddress].name, doctorMapping[_doctorAddress].designation);
    }
}