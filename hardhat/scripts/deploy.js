const {ethers} = require("hardhat");

async function main(){

  const exchangeFactory =  await ethers.getContractFactory("Exchange");

  //put constructor arguments here
  const exchangeContract = await exchangeFactory.deploy();
  await exchangeContract.deployed;

  console.log(`Your Exchange contract address is ${exchangeContract.address}`)
}

main().then(() => process.exit(0)).catch((err) => {
  console.log(err);
  process.exit(1);
})