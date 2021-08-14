import { SyncOutlined } from "@ant-design/icons";
import { utils } from "ethers";
import { Button, Card, DatePicker, Divider, Input, List, Progress, Slider, Spin, Switch } from "antd";
import React, { useState } from "react";
import { Address, Balance } from "../components";

export default function Review({
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
	storeJson,
	getJson,
	product_array,
}) {
	// form constants to write reviews
	const [productID, setproductID] = useState('');
	const [review, setreview] = useState('');
	
	// used for viewing reviews
	const [productID2, setproductID2] = useState('');
	const [reviewIndex, setreviewIndex] = useState('');
	const [reviewHash, setreviewHash] = useState('');

	return (
		<div>
			<div style={{ border: "1px solid #cccccc", padding: 16, width: 400, margin: "auto", marginTop: 64, marginBottom: 64 }}>
				<h2> Enter Product Reviews 📝 </h2>
				<h4>(Only users with product review tokens 🟡 are able to enter reviews)</h4>
				<div style={{ margin: 8 }}>
					<Input 
						placeholder="Enter Product ID"
						onChange={e => {
							setproductID(e.target.value);
						}}
					/>
					<Input
						placeholder="Enter Review Comment"
						onChange={e => {
							setreview(e.target.value);
						}}
					/>
					<Button
						style={{ marginTop: 8 }}
						onClick={async () => {
							let reviewJson = {
								productID: productID,
								review: review,
							}
							const cid = storeJson(reviewJson, "review.json");
							const result = tx(writeContracts.YourContract.writeReview(productID, cid));
						}}
					>
						Enter Review
					</Button>
				</div>
				<Divider />
				<h2> View Reviews 📝 </h2>
				<h3> { reviewHash } </h3>
				<div style={{ margin: 8 }}>
					<Input
						placeholder="Enter Product ID"
						onChange={e => {
							setproductID2(e.target.value);
						}}
					/>
					<Input
						placeholder="Enter Review Index"
						onChange={e => {
							setreviewIndex(e.target.value);
						}}
					/>
					<Button
						style={{ marginTop: 8 }}
						onClick={async () => {
							writeContracts.YourContract.displayReview(address, productID2, reviewIndex)
							.then(result => {
								setreviewHash(result);
							});
						}}
					>
						Enter
					</Button>
				</div>
				<div style={{ margin: 8 }}>
					<Button
						style={{ marginTop: 8 }}
						onClick={async () => {
							let productReviewHashes;
							await writeContracts.YourContract.displayMultipleReviewsProduct(200)
								.then(result => {
									productReviewHashes = result;
								});
							await productReviewHashes.forEach(hash => {
								console.log(getJson(hash));
							});
						}}
					>
						Test
					</Button>
				</div>
			</div>
		</div>
	);
}
