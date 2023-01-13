import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v1.0.5/index.ts";
import { assert } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "All Pirates Functions",
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

    let block = chain.mineBlock([
      Tx.contractCall(
        "game",
        `update-wowlabz`,
        [types.principal(deployer.address)],
        deployer.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectBool(true);

    block = chain.mineBlock([
      Tx.contractCall("game", `get-wowlabz`, [], deployer.address),
    ]);
    block.receipts[0].result.expectPrincipal(deployer.address);

    // let's minting nft untill unless we get pirate
    let pirate = 0;
    for (let turn = 0; turn < 100; turn++) {
      block = chain.mineBlock([
        Tx.contractCall(
          "game",
          `mint`,
          [types.principal(wallet_1.address)],
          wallet_1.address
        ),
      ]);
      block.receipts[0].result.expectOk().expectBool(true);
      let events = {};
      block.receipts[0].events.map((ent) => {
        events[ent.type] = ent[ent.type];
      });
      if (events["nft_mint_event"].asset_identifier.endsWith("pirates")) {
        pirate = events["nft_mint_event"];
        break;
      }
    }
    // now i have minted a pirate for wallet_1

    // testing combine
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `combine-traits-to-one`,
        [
          types.uint(parseInt(pirate.value.slice(1))),
          types.utf8("combined-rle"),
        ],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectBool(true);

    // let's try to combine again, it should fail
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `combine-traits-to-one`,
        [
          types.uint(parseInt(pirate.value.slice(1))),
          types.utf8("combined-rle-will-fail"),
        ],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectErr().expectUint(104);

    // let's stack
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `stack-pirate`,
        [types.uint(parseInt(pirate.value.slice(1)))],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectBool(true);

    // let's stack again, since it's already stacked, it should fail
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `stack-pirate`,
        [types.uint(parseInt(pirate.value.slice(1)))],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectErr().expectUint(102);

    // get get-total-stacked-pirates, should be one
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `get-total-stacked-pirates`,
        [],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectUint(1);

    // let's unstack
    block = chain.mineBlock([
      Tx.contractCall(
        "pirate-nft",
        `unstack-pirate`,
        [types.uint(parseInt(pirate.value.slice(1)))],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectBool(true);
  },
});
