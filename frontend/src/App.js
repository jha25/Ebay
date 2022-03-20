/** @format */

import "./App.css"
import React from "react"
import { DrizzleContext } from "@drizzle/react-plugin"
import { Drizzle } from "@drizzle/store"
import { BrowserRouter as Router, Routes, Route } from "react-router-dom"

import drizzleOptions from "./utils/drizzleOptions"
import Home from "./components/Home"
import Auction from "./components/Auction"
import Merchant from "./components/Merchant"
import User from "./components/User"
import Navbar from "./components/Navbar"

const drizzle = new Drizzle(drizzleOptions)

function App() {
	return (
		<Router>
			<DrizzleContext.Provider drizzle={drizzle}>
				<DrizzleContext.Consumer>
					{(drizzleContext) => {
						const { drizzle, drizzleState, initialized } = drizzleContext
						console.log(drizzle)
						console.log(drizzleState)
						// if (!initialized) {
						// 	return "Loading..."
						// }
						return (
							<>
								<div className='container'>
									<div className='row'>
										<div className='col-sm-12'>
											<Navbar />
										</div>
									</div>
								</div>
								<div className='row'>
									<div className='col-sm-12'>
										<Routes>
											<Route exact path='/' component={Home} />
											<Route path='/auctions/:auctionId' component={Auction} />
											<Route path='/merchant' component={Merchant} />
											<Route path='/user' component={User} />
										</Routes>
									</div>
								</div>
							</>
						)
					}}
				</DrizzleContext.Consumer>
			</DrizzleContext.Provider>
		</Router>
	)
}

export default App
