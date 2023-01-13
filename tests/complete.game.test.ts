import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v1.0.5/index.ts";
import { assert } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "Complete game flow",
  async fn(chain: Chain, accounts: Map<string, Account>) {
    let deployer = accounts.get("deployer")!; // instantiate a deployer
    let wallet_1 = accounts.get("wallet_1")!;

    // let's add all traits for ships and pirates
    const pirate_traits: any = [
      "bottom",
      "hat",
      "hand",
      "sword",
      "face",
      "top",
    ];
    pirate_traits.map((trait) => {
      // for common

      let block = chain.mineBlock([
        Tx.contractCall(
          "pirates-factory",
          `add-common-${trait}-trait`,
          [types.utf8("testing-common-rle")],
          deployer.address
        ),
      ]);
      block.receipts[0].result.expectOk().expectBool(true);

      // for rare
      block = chain.mineBlock([
        Tx.contractCall(
          "pirates-factory",
          `add-rare-${trait}-trait`,
          [types.utf8("testing-rare-rle")],
          deployer.address
        ),
      ]);
      block.receipts[0].result.expectOk().expectBool(true);
    });

    const ship_traits: any = [
      "body",
      "mast",
      "telescope",
      "sail",
      "anchor",
      "window",
    ];
    ship_traits.map((trait) => {
      // for common

      let block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-common-${trait}-trait`,
          [types.utf8("testing-common-rle")],
          deployer.address
        ),
      ]);
      block.receipts[0].result.expectOk().expectBool(true);

      // for rare
      block = chain.mineBlock([
        Tx.contractCall(
          "ships-factory",
          `add-rare-${trait}-trait`,
          [types.utf8("testing-rare-rle")],
          deployer.address
        ),
      ]);
      block.receipts[0].result.expectOk().expectBool(true);
    });

    // all traits are added, let's mint an nft
    // let's set the account who receives stx

    /*
        Here I will test complete game flow
    */
  },
});
