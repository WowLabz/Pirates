import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v1.0.5/index.ts";

Clarinet.test({
  name: "Ensure that addition of traits for ship factory, works for common and rare both",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!; // instantiate a deployer
    let wallet_1 = accounts.get("wallet_1")!;

    const traits: any = [
      "body",
      "mast",
      "telescope",
      "sail",
      "anchor",
      "window",
    ];

    // for common
    traits.map((trait) => {
      let block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-common-${trait}-trait`,
          [types.utf8("testing-rle")],
          deployer.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectOk().expectBool(true);

      block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `get-common-${trait}-trait-idx`,
          [types.uint(0)],
          wallet_1.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectSome().expectUtf8("testing-rle");

      block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-common-${trait}-trait`,
          [types.utf8("testing-rle")],
          wallet_1.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectErr().expectUint(401);
    });

    // for rare
    traits.map((trait) => {
      let block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-rare-${trait}-trait`,
          [types.utf8("testing-rle")],
          deployer.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectOk().expectBool(true);

      block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `get-rare-${trait}-trait-idx`,
          [types.uint(0)],
          wallet_1.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectSome().expectUtf8("testing-rle");

      block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-rare-${trait}-trait`,
          [types.utf8("testing-rle")],
          wallet_1.address
        ), // increment counter by 3
      ]);
      block.receipts[0].result.expectErr().expectUint(401);
    });
  },
});
