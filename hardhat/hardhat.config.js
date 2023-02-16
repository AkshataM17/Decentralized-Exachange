require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({path: ".env"});

const ALCHEMY_HTTP_URL = process.env.ALCHEMY_HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: ALCHEMY_HTTP_URL,
      accounts: [PRIVATE_KEY],
    }
  },
  etherscan:{
    apiKey: ETHERSCAN_API_KEY,
  },
};

