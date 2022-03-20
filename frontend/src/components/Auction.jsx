/** @format */
import React, { useState } from "react"
import { newContextComponents } from "@drizzle/react-components"
import { drizzleReactHooks } from "@drizzle/react-plugin"
import AuctionList from "./list/AuctionList"

const { useDrizzle, useDrizzleState } = drizzleReactHooks
const { ContractData } = newContextComponents

const Auction = () => {
	const [isAdmin, setIsAdmin] = useState(false)
	const { drizzle } = useDrizzle()
	const state = useDrizzleState((state) => state)
	return (
		<>
			<div>
				<h3>All auctions</h3>
				<ContractData
					drizzle={drizzle}
					drizzleState={state}
					contract='Ebay'
					method='getAuctions'
					render={AuctionList}
				/>
			</div>
		</>
	)
}

export default Auction
