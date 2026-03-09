import assert from "node:assert/strict";
import { describe, it } from "node:test";

import { network } from "hardhat";

import { createWalletClient, http } from 'viem'
import { privateKeyToAccount } from 'viem/accounts'

const player = privateKeyToAccount("0xde9be858da4a475276426320d5e9262ecfc3ba460bfac56360bfa6c4c28b4ee0") // 你生成的测试私钥
const playerAddress = player.address


const client = createWalletClient({
  account: player,
  chain: network,
  transport: http()
})


describe("Baccarat", async function () {
  const { viem } = await network.connect();
  const publicClient = await viem.getPublicClient();

  it("Should emit the Increment event when calling the inc() function", async function () {
    const baccarat = await viem.deployContract("Baccarat");

    const [owner, player] = await viem.getSigners();
    const playerAddress = player.address;
    
    await viem.assertions.emitWithArgs(
      baccarat.write.deposit({   args: [],value: 1000000000000000000n,account: playerAddress,client: client}),
      baccarat,
      "Deposit",
      [playerAddress, 100n],
    );
  });

});
