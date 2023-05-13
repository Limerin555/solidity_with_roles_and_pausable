// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract AccessControlWithRoles is ERC1155, AccessControl, Pausable {
    bytes32 public constant SECOND_ADMIN_ROLE = keccak256("SECOND_ADMIN_ROLE");

    uint256 private defAdminCount = 0;
    uint256 private secAdminCount = 0;
    uint256 private mintsLeft = 1000;

    constructor(
        address _defAdmin, 
        address _secAdmin
    ) ERC1155("default") {
        _setupRole(DEFAULT_ADMIN_ROLE, _defAdmin);
        _setupRole(SECOND_ADMIN_ROLE, _secAdmin);
    }

    // Allows Default Admin to pause the contract
    function pause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    // Allows Default Admin to unpause the contract
    function unpause() public onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    // Increments defAdminCount's count
    function incDefAdminCount() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Unauthorized: You do not have the DEFAULT_ADMIN_ROLE");
        defAdminCount++;
    }

    // Increments secAdminCount's count
    function incSecAdminCount() public {
        require(hasRole(SECOND_ADMIN_ROLE, msg.sender), "Unauthorized: You do not have the SECOND_ADMIN_ROLE");
        secAdminCount++;
    }

    // Decrements mintsLeft
    function mintNft() public whenNotPaused {
        require(mintsLeft > 0, "Error: No more mints left");
        mintsLeft--;
    }

    // Returns defAdminCount when called
    function getDefAdminCount() public view returns (uint256) {
        return defAdminCount;
    }

    // Returns secAdminCount when called
    function getSecAdminCount() public view returns (uint256) {
        return secAdminCount;
    }

    // Returns mintsLeft when called
    function getMintsLeft() public view returns (uint256) {
        return mintsLeft;
    }

    // Override required by Solidity
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}