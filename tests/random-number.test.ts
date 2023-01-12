import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v1.0.5/index.ts";
import { assert } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "Ensure that addition of traits for pirates, works for common and rare both",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    const wallet_1 = accounts.get("wallet_1")!;
    for (let turn = 1; turn < 1000; turn++) {
      let max = Math.floor(Math.random() * 10000);
      let ms = Date.now();
      let block = chain.mineBlock([
        Tx.contractCall(
          "random-number",
          `get-random`,
          [types.uint(max), types.uint(ms)],
          wallet_1.address
        ), // increment counter by 3
      ]);
      assert(
        parseInt(block.receipts[0].result.expectOk().slice(1)) < max,
        "failed, rd number >= max"
      );
    }
  },
});
