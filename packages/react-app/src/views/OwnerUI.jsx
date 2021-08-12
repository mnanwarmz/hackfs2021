import { SyncOutlined } from "@ant-design/icons";
import { utils } from "ethers";
import { Button, Card, DatePicker, Divider, Input, List, Progress, Slider, Spin, Switch } from "antd";
import React, { useState } from "react";
import { Address, Balance } from "../components";

export default function OwnerUI({
	purpose,
	setPurposeEvents,
	address,
	mainnetProvider,
	localProvider,
	yourLocalBalance,
	price,
	tx,
	readContracts,
	writeContracts,
}) {
	// form constants to provide user tokens
	const [userAdd, setuserAdd] = useState('');
	const [productID, setproductID] = useState('');
	
	// used for viewing tokens
	const [productID2, setproductID2] = useState('');
	const [tokenNum, settokenNum] = useState('');

	return (
		<div>
			<div style={{ border: "1px solid #cccccc", padding: 16, width: 400, margin: "auto", marginTop: 64, marginBottom: 64 }}>
				<h2>🟡 Give Tokens 🟡</h2>
				<h3>Please enter user address and product ID</h3>
				<h4>(Only owners are able to distribute tokens to users)</h4>
				<div style={{ margin: 8 }}>
					<Input 
						placeholder="Enter user Address"
						onChange={e => {
							setuserAdd(e.target.value);
						}}
					/>
					<Input
						placeholder="Enter Product ID"
						onChange={e => {
							setproductID(e.target.value);
						}}
					/>
					<Button
						style={{ marginTop: 8 }}
						onClick={async () => {
							const result = tx(writeContracts.YourContract.giveToken(userAdd, productID));
						}}
					>
						Give Token
					</Button>
				</div>
				<Divider />

				<h2>🟡 View number of tokens 🟡</h2>
				<h3> { tokenNum } token(s) for product { productID2 } </h3>
				<div style={{ margin: 8 }}>
					<Input
						placeholder="Enter Product ID"
						onChange={e => {
							setproductID2(e.target.value);
						}}
					/>
					<Button
						style={{ marginTop: 8 }}
						onClick={async () => {
							writeContracts.YourContract.displayTokens(address, productID2)
							.then(result => {
								settokenNum(result.toNumber());
							});
						}}
					>
						Enter
					</Button>
				</div>
			</div>
		</div>
	);
}
