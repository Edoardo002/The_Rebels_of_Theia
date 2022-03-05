// SPDX-License-Identifier: ROT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.4.2/security/Pausable.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts@4.4.2/utils/Counters.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract SpaceShipToken is ERC721, ERC721Enumerable, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public mintRate = 0.04 ether;
    uint public MAX_SUPPLY = 16000;
    enum BACKGROUND{}//for metadata
    enum CORE{}
    enum TAIL{}
    enum RIGHT_WING{}
    enum LEFT_WING{}
    enum ENGINE{}
    enum WEAPONS{}
    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(uint256 => BACKGROUND) public tokenIdToBACKGROUND;
    mapping(uint256 => CORE) public tokenIdToCORE;
    mapping(uint256 => TAIL) public tokenIdToTAIL;
    mapping(uint256 => RIGHT_WING) public tokenIdToRIGHT_WING;
    mapping(uint256 => LEFT_WING) public tokenIdToLEFT_WING;
    mapping(uint256 => ENGINE) public tokenIdToENGINE;
    mapping(uint256 => WEAPONS) public tokenIdToWEAPONS;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    event requestedCollectible(bytes32 indexed requestId);

    bytes32 internal keyHash;
    uint256 internal fee;

    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
    public 
    VRFConsumerBase(_VRFCoordinator, _LinkToken) ERC721("SpaceShipToken", "SST") {
        keyHash = _keyhash;
        fee = 0.1 * 10 ** 18;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function createCollectible(string memory URI) public returns (bytes32) {
        require(totalSupply() < MAX_SUPPLY, "Sold out, can't mint anymore");
        require(msg.value >= mintRate, "Not enough ether sent");
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        address ssOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = _tokenIdCounter.current();
        _safeMint(ssOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        BACKGROUND b = BACKGROUND(randomNumber % 22);
        CORE c = CORE(randomNumber % 30);
        TAIL t = TAIL(randomNumber % 20);
        RIGHT_WING rw = RIGHT_WING(randomNumber % 16);
        LEFT_WING lw = LEFT_WING(randomNumber % 16);
        ENGINE e = ENGINE(randomNumber % 97);
        WEAPONS w = WEAPONS(randomNumber % 21);
        tokenIdToBACKGROUND[newItemId] = b;
        tokenIdToCORE[newItemId] = c;
        tokenIdToTAIL[newItemId] = t;
        tokenIdToRIGHT_WING[newItemId] = rw;
        tokenIdToLEFT_WING[newItemId] = lw;
        tokenIdToENGINE[newItemId] = e;
        tokenIdToWEAPONS[newItemId] = w;
        requestIdToTokenId[requestId] = newItemId;
        _tokenIdCounter.increment();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    function withdraw() public onlyOwner {
        require(address(this).balance > 0, "Balance is 0");
        payable(owner()).transfer(address(this).balance);
    }
}
