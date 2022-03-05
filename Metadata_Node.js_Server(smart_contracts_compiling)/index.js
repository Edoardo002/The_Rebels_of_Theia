const pinataSDK = require('@pinata/sdk');
const pinata = pinataSDK('bf018409efd97d3c70fc', 'f77282464eb87c2214e07d04bd0f3e6875aa6ffda71bbecee801472f7ee89a4c');

pinata.testAuthentication().then((result) => {
    //handle successful authentication here
    console.log(result);
}).catch((err) => {
    //handle error here
    console.log(err);
});

const app = require('express')();

app.get('/metadata/:tid', (req, res) => {
    const tid = req.params.tid; //GET http://server-url/metadata/1 => tid = 1
    token_json = createtokenmetadata(tid);
    res.send(token_json);
})

app.get('/contract-metadata', (req, res) => {
    res.send({
        "name": "The Rebels of Theia",
        "description": "A space tale",
        "image": "", //logo
        "external_link": "", /*websiteURL*/
        "seller_free_basis_points": 250, //100=1%
        "free_recipient": "" //the deployed contract address
    })
})

app.post('/metadata/jsonblobs', (req, res) => {
    console.log(req.body);
    pinata.pinJSONToIPFS(req.body).then((result) => {
        //return json URI
        console.log(result);
        res.send(result.IpfsHash); //this is the IPFS multi-hash provided back for your content
    }).catch((err) => {
        //handle error here
        console.log(err);
    });
})

function createtokenmetadata(id) {
    //create metadata based on id
    const token = {
        name: "spaceship"+str(id),
        faction: "",
        rarity: "",
        components: "",
        image: "baseipfsURI"+id+".png"
    };
    return token;
}