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
    res.send(/*find "tid" in pinata (with pinata APIs) storage and send it back*/);
})

app.get('/contract-metadata', (req, res) => {
    res.send({
        "name": "The Rebels of Theia",
        "description": "A space tale",
        "image": "", //URL
        "external_link": "", /*websiteURL*/
        "seller_free_basis_points": 250, //100=1%
        "free_recipient": "" //the deployed contract address
    })
})