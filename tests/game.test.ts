import {
  Clarinet,
  Tx,
  Chain,
  Account,
  types,
} from "https://deno.land/x/clarinet@v1.0.5/index.ts";
import { assert } from "https://deno.land/std@0.90.0/testing/asserts.ts";

Clarinet.test({
  name: "minting of nft",
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

    // MINTING OF NFT
    block = chain.mineBlock([
      Tx.contractCall(
        "game",
        `mint`,
        [types.principal(wallet_1.address)],
        wallet_1.address
      ),
    ]);
    block.receipts[0].result.expectOk().expectBool(true);
    //
    let events = {};
    block.receipts[0].events.map((ent) => {
      events[ent.type] = ent[ent.type];
    });

    // lets verify the stx transfer first
    assert(
      events["stx_transfer_event"].sender == wallet_1.address,
      "stx didn't transferred from sender"
    );
    assert(
      events["stx_transfer_event"].recipient == deployer.address,
      "stx didn't transferred to deployer address"
    );
    block = chain.mineBlock([
      Tx.contractCall("game", `get-minting-stx-amount`, [], wallet_1.address),
    ]);
    assert(
      events["stx_transfer_event"].amount == block.receipts[0].result.slice(1),
      "amount didn't transferred as defined"
    );
    //verify nft-minting
    assert(
      events["nft_mint_event"].recipient == wallet_1.address,
      "nft didn't transferred to correct recipient"
    );
    assert(events["nft_mint_event"].value == "u0", "nft tokenid invalid");

    // let's mint for 100 times and count pirates occurence and ships
    let pirates_cnt = 0,
      ships_cnt = 0;
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
      events = {};
      block.receipts[0].events.map((ent) => {
        events[ent.type] = ent[ent.type];
      });
      if (events["nft_mint_event"].asset_identifier.endsWith("ships"))
        ships_cnt++;
      else pirates_cnt++;
    }
    console.log(
      `ships occurs ${ships_cnt} and pirates occurs for ${pirates_cnt}`
    );
  },
});
