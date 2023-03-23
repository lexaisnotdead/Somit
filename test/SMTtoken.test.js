const SMT = artifacts.require("SMTtoken");

contract("SMTtoken", (accounts) => {
    before(async () => {
        instance = await SMTtoken.deployed()
    })

})