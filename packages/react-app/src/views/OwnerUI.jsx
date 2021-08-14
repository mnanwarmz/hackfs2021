import { SyncOutlined } from "@ant-design/icons";
import { utils } from "ethers";
import { Button, Card, DatePicker, Divider, Input, List, Progress, Slider, Spin, Switch, Select } from "antd";
import React, { useState } from "react";
import { Address, Balance } from "../components";

const { Option } = Select;

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
				<h2>🟡 View number of tokens 🟡</h2>
				<h3> { tokenNum } token(s) for product { productID2 } </h3>
				<div style={{ margin: 8 }}>
					<Select 
						placeholder="Enter Product ID"
						onSelect={(value) => {
							setproductID2(value);
						}}
					>
						<Option value="1">Earthen Bottle</Option>
						<Option value="2">Nomad Tumbler</Option>
						<Option value="3">Focus Paper Refill</Option>
						<Option value="4">Machined Mechanical Pencil</Option>
					</Select>
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
