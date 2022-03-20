/** @format */

import React, { useState } from "react"
import { drizzleReactHooks } from "@drizzle/react-plugin"
import { newContextComponents } from "@drizzle/react-components"
import AuctionList from "./list/AuctionList"

const { useDrizzle, useDrizzleState } = drizzleReactHooks
const { ContractData } = newContextComponents

const Home = () => {
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

export default Home
