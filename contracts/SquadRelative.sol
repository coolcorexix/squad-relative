//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "./PancakeSquad.sol";

contract SquadRelativeMaster is AccessControlEnumerable {
    SquadRelative private squadRelative;
    mapping(uint256 => uint256) private pancakeSquadIdToRelativeSquadId;

    constructor(
        string memory name,
        string memory symbol,
        uint256 maxSupply,
        address pancakeSquadAddress
    ) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        squadRelative = new SquadRelative(
            name,
            symbol,
            maxSupply,
            pancakeSquadAddress
        );
        pancakeSquadIdToRelativeSquadId[8483] = 8;
    }

    function getSquadRelativeAddress() public view returns (address) {
        return address(squadRelative);
    }

    function mintOnBehalfOfCaller(uint256 tokenId) public {
        require(
            squadRelative.getPancakeSquad().ownerOf(tokenId) == _msgSender(),
            "Not the owner"
        );
        require(pancakeSquadIdToRelativeSquadId[tokenId] != 0, "No GIF made");
        uint256 squadRelativeId = pancakeSquadIdToRelativeSquadId[tokenId];
        squadRelative.mint(_msgSender(), squadRelativeId);
    }
}

contract SquadRelative is ERC721Enumerable, Ownable {
    using SafeERC20 for IERC20;
    using Strings for uint256;

    uint256 public immutable maxSupply;

    bool public isLocked;
    string public baseURI;

    event Lock();

    PancakeSquad private pancakeSquad;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        address _pancakeSquadAddress
    ) ERC721(_name, _symbol) {
        require(
            (_maxSupply == 130) || (_maxSupply == 13),
            "Operations: Wrong max supply"
        );
        maxSupply = _maxSupply;
        pancakeSquad = PancakeSquad(_pancakeSquadAddress);
    }

    function getPancakeSquad() external view returns (PancakeSquad) {
        return pancakeSquad;
    }

    /**
     * @notice Allows the owner to lock the contract
     * @dev Callable by owner
     */
    function lock() external onlyOwner {
        require(!isLocked, "Operations: Contract is locked");
        isLocked = true;
        emit Lock();
    }

    /**
     * @notice Allows the owner to mint a token to a specific address
     * @param _to: address to receive the token
     * @param _tokenId: tokenId
     * @dev Callable by owner
     */
    function mint(address _to, uint256 _tokenId) external onlyOwner {
        require(totalSupply() < maxSupply, "NFT: Total supply reached");
        _mint(_to, _tokenId);
    }

    /**
     * @notice Allows the owner to set the base URI to be used for all token IDs
     * @param _uri: base URI
     * @dev Callable by owner
     */
    function setBaseURI(string memory _uri) external onlyOwner {
        require(!isLocked, "Operations: Contract is locked");
        baseURI = _uri;
    }

    /**
     * @notice Returns a list of token IDs owned by `user` given a `cursor` and `size` of its token list
     * @param user: address
     * @param cursor: cursor
     * @param size: size
     */
    function tokensOfOwnerBySize(
        address user,
        uint256 cursor,
        uint256 size
    ) external view returns (uint256[] memory, uint256) {
        uint256 length = size;
        if (length > balanceOf(user) - cursor) {
            length = balanceOf(user) - cursor;
        }

        uint256[] memory values = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            values[i] = tokenOfOwnerByIndex(user, cursor + i);
        }

        return (values, cursor + length);
    }

    /**
     * @notice Returns the Uniform Resource Identifier (URI) for a token ID
     * @param tokenId: token ID
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
                : "";
    }
}
