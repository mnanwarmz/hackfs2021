import { Web3Storage, File } from 'web3.storage/dist/bundle.esm.min.js';

function getAccessToken() {
  // If you're just testing, you can paste in a token
  // and uncomment the following line:
  return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweDg5MzgwMGIwN2JjYjkxMWYxOEQ5RDAxQzYwN0UzYjYwNjMyZTNiYkEiLCJpc3MiOiJ3ZWIzLXN0b3JhZ2UiLCJpYXQiOjE2Mjc4ODgxNTE0NTgsIm5hbWUiOiJqaWFyZW4ifQ.u-722IbskHz5uo3LGD9Os5VWaOj8jo6UOeJ0g6R3aO8'
  // In a real app, it's better to read an access token from an 
  // environement variable or other configuration that's kept outside of 
  // your code base. For this to work, you need to set the
  // WEB3STORAGE_TOKEN environment variable before you run your code.
  return process.env.WEB3STORAGE_TOKEN
}

function makeStorageClient() {
  return new Web3Storage({ token: getAccessToken() })
}

export default async function storeJson(json_obj, filename) {
	// Reads 1st argument json and converts to json string 
	const buffer = Buffer.from(JSON.stringify(json_obj));
	// creates file object using json string an filenam arg
	const files = [new File([buffer], filename)]
	// store files
	const client = makeStorageClient()
	const cid = await client.put(files)
	return cid
}
