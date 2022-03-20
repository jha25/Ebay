// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ebay {
    struct Auction {
        uint256 id;
        address payable seller;
        string name;
        string description;
        uint256 min;
        uint256 end;
        uint256 bestOfferId;
        uint256 bestOffer;
        uint256[] offerIds;
    }

    struct Offer {
        uint256 id;
        uint256 auctionId;
        address payable buyer;
        uint256 price;
    }
    mapping(uint256 => Auction) public auctions;
    mapping(uint256 => Offer) private offers;
    mapping(address => uint256[]) private userAuctions;
    mapping(address => uint256[]) private userOffers;
    uint256 private nextAuctionId = 1;
    uint256 private nextOfferId;

    function createAuction(
        string calldata _name,
        string calldata _description,
        uint256 _min,
        uint256 _duration
    ) external {
        require(_min > 0, "Min must be greater than 0");
        require(
            _duration > 86400 && _duration < 864000,
            "Duration must be comprised between 1 to 10 days"
        );
        uint256[] memory offerIds = new uint256[](0);
        auctions[nextAuctionId] = Auction(
            nextAuctionId,
            payable(msg.sender),
            _name,
            _description,
            _min,
            block.timestamp + _duration,
            0,
            0,
            offerIds
        );
        userAuctions[msg.sender].push(nextAuctionId);
        nextAuctionId++;
    }

    function createOffer(uint256 _auctionId)
        external
        payable
        auctionExists(_auctionId)
    {
        Auction storage auction = auctions[_auctionId];
        Offer storage bestOffer = offers[auction.bestOfferId];
        require(block.timestamp < auction.end, "Auction has ended");
        require(
            msg.value >= auction.min && msg.value > bestOffer.price,
            "Msg.value must be higher than min offer and best offer"
        );
        auction.bestOfferId = nextOfferId;
        auction.bestOffer = msg.value;
        auction.offerIds.push(nextOfferId);
        offers[nextOfferId] = Offer(
            nextOfferId,
            _auctionId,
            payable(msg.sender),
            msg.value
        );
        userOffers[msg.sender].push(nextOfferId);
        nextOfferId++;
    }

    function trade(uint256 _auctionId) external auctionExists(_auctionId) {
        Auction storage auction = auctions[_auctionId];
        Offer storage bestOffer = offers[auction.bestOfferId];
        for (uint256 i = 0; i < auction.offerIds.length; i++) {
            uint256 offerId = auction.offerIds[i];
            if (offerId != auction.bestOfferId) {
                Offer storage offer = offers[offerId];
                offer.buyer.transfer(offer.price);
            }
        }
        auction.seller.transfer(bestOffer.price);
    }

    function getAuctions() external view returns (Auction[] memory) {
        Auction[] memory _auctions = new Auction[](nextAuctionId - 1);
        for (uint256 i = 1; i < nextAuctionId; i++) {
            _auctions[i - 1] = auctions[i];
        }
        return _auctions;
    }

    function getUserAuctions(address _user)
        external
        view
        returns (Auction[] memory)
    {
        uint256[] storage userAuctionIds = userAuctions[_user];
        Auction[] memory _auctions = new Auction[](userAuctionIds.length);
        for (uint256 i = 0; i < userAuctionIds.length; i++) {
            uint256 auctionId = userAuctionIds[i];
            _auctions[i] = auctions[auctionId];
        }
        return _auctions;
    }

    function getUserOffers(address _user)
        external
        view
        returns (Offer[] memory)
    {
        uint256[] storage userOfferIds = userOffers[_user];
        Offer[] memory _offers = new Offer[](userOfferIds.length);
        for (uint256 i = 0; i < userOfferIds.length; i++) {
            uint256 offerId = userOfferIds[i];
            _offers[i] = offers[offerId];
        }
        return _offers;
    }

    modifier auctionExists(uint256 _auctionId) {
        require(
            _auctionId > 0 && _auctionId < nextAuctionId,
            "Auction does not exist"
        );
        _;
    }
}
