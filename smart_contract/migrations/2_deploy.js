/** @format */

const Ebay = artifacts.require("Ebay")

module.exports = async function (deployer, _network, accounts) {
	await deployer.deploy(Ebay)
	const ebay = await Ebay.deployed()

	await ebay.createAuction(
		"My awesome boredApe 1",
		"My awesome boredApe 1 can dance, jump and even invest in crypto and make you tons of money. You should definitely invest in one",
		1000,
		86500,
	)
	await ebay.createAuction(
		"My awesome mutantBoredApe 1",
		"My awesome mutantBoredApe 1 can dance, jump and even invest in crypto and make you tons of money. You should definitely invest in one",
		2000,
		86500,
	)
	await ebay.createOffer(1, { value: 1000, from: accounts[1] })
}
