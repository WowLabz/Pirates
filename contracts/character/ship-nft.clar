(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-TOKEN-OWNER (err u101))
(define-constant ERR-ALREADY-STACKED (err u102))
(define-constant ERR-NOT-STACKED  (err u103))
(define-constant ERR-RLE-ALREADY-COMBINED (err u104))
(define-constant ERR-BLOCK-TIME-ERROR (err u105))
(define-constant ERR-TRS-TRANSFER-FAILED (err u106))
(define-constant ERR-NOT-IN-TIME (err u109))
(define-constant ERR-TRS-ADD-FAILED (err u111))
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant OUT-OF-BOUND (err 405))

(define-non-fungible-token ships uint)
(define-constant contract-owner tx-sender)

(define-data-var last-token-id uint u0)
(define-data-var trs-token-per-second uint u1)
(define-data-var pirates-tax uint u20)
(define-data-var total-pool-collection uint u0)
(define-data-var day uint u0)
(define-data-var base-time uint u0) ;;(unwrap-panic (get-block-info? time (- block-height u1)))
(define-data-var prev-pool-collection uint u0)
(define-data-var total-stacked-ships uint u0)
;; mapping token-id => attribute
(define-map nft-details uint { traits: {body : {idx : uint, is-rare: bool},mast : {idx : uint, is-rare: bool},telescope : {idx : uint, is-rare : bool}, window : {idx : uint, is-rare: bool}, anchor : {idx : uint, is-rare: bool}, sail : {idx : uint, is-rare: bool}}, is-rare: bool, tov: uint, is-stacked: bool, nft-rle: (string-utf8 20000), total-stacked-time: uint, stacked-at: uint , trs-token: uint })

;; functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (ok none)
    ;;(get nft-rle (unwrap-panic (map-get? nft-details token-id)))
)

(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? ships token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (is-eq tx-sender sender) ERR-NOT-TOKEN-OWNER)
        (nft-transfer? ships token-id sender recipient) 
    )
)
 
(define-public (mint (recipient principal))
    (let
        (
            
            (token-id (var-get last-token-id))
            (nft-property (unwrap-panic (contract-call? .ships-factory get-random-traits)))
            (traits (get traits nft-property))
            (is-rare (get is-rare nft-property))
            (tov (get tov nft-property))
        )    
        (asserts! (is-eq .game tx-sender) ERR-NOT-AUTHORIZED) ;; only game contract can call it
        (var-set last-token-id (+ token-id u1))
        (try! (nft-mint? ships token-id recipient))
        ;; will send request to external api and will get NFT RLE
        (map-insert nft-details token-id { traits : traits ,  is-rare : is-rare, tov : tov, is-stacked : false, nft-rle : u"",  total-stacked-time : u0, stacked-at : u0, trs-token : u0 })
        (ok true)
    )
)

(define-public (combine-traits-to-one (token-id uint) (ship-rle (string-utf8 20000)))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq (get nft-rle nft-detail) u"") ERR-RLE-ALREADY-COMBINED)
        (map-set nft-details token-id (merge nft-detail { nft-rle : ship-rle }))
        (ok true)
    )
)


(define-public (stack-ship (token-id uint))
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq false (get is-stacked nft-detail)) ERR-ALREADY-STACKED)
        (asserts! (is-some (get-block-info? time (- block-height u1))) ERR-BLOCK-TIME-ERROR)
        (map-set nft-details token-id (merge nft-detail { is-stacked : true, stacked-at : (unwrap-panic (get-block-info? time (- block-height u1))) }))
        (var-set total-stacked-ships (+ (var-get total-stacked-ships) u1))
        (ok true)
    )
)

(define-public (unstack-ship (token-id uint))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))

        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq true (get is-stacked nft-detail)) ERR-NOT-STACKED)
        (asserts! (is-some (get-block-info? time (- block-height u1))) ERR-BLOCK-TIME-ERROR)
        (map-set nft-details token-id (merge nft-detail { is-stacked : false, total-stacked-time : (+ (get total-stacked-time nft-detail) (- (unwrap-panic (get-block-info? time (- block-height u1))) (get stacked-at nft-detail))) }))
        (var-set total-stacked-ships (- (var-get total-stacked-ships) u1))
        (ok true)
    )
)

(define-private (set-pool-collection (rel-time uint) (pirates-amount uint))
    (if (<= rel-time (+ u20 (* u24 (var-get day))))
        (var-set total-pool-collection (+ (var-get total-pool-collection) pirates-amount))
        (var-set prev-pool-collection (+ (var-get total-pool-collection) pirates-amount))
    )
)

(define-public (claim-trs (token-id uint)) 
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
            (amount (* (var-get trs-token-per-second) (get total-stacked-time nft-detail)))
            (pirates-amount (/ (* amount (var-get pirates-tax)) u100)) ;; to be collected somewhere
            (sender-amount (- amount pirates-amount))
            (curr-time (unwrap-panic (get-block-info? time (- block-height u1))))
            (rel-time (- curr-time (var-get base-time)))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-some (get-block-info? time (- block-height u1))) ERR-BLOCK-TIME-ERROR)
        (map-set nft-details token-id (merge nft-detail { total-stacked-time : u0, trs-token : amount, stacked-at : u0}))
        (set-pool-collection rel-time pirates-amount)
        (asserts! (is-eq (unwrap-panic (as-contract (contract-call? .trs-token transfer-claimed-trs sender-amount tx-sender))) true) ERR-TRS-TRANSFER-FAILED)        ;; (asserts! (is-eq (unwrap-panic (as-contract (contract-call? .leaderboard add-trs-value sender-amount tx-sender))) true) ERR-TRS-ADD-FAILED)
        (ok true)
    )
)

(define-read-only (ship-details (token-id uint))
    (if (< token-id (var-get last-token-id))
        (ok (unwrap-panic (map-get? nft-details token-id)))
        ERR-NOT-FOUND
    )
)

(define-read-only (get-total-stacked-ships) 
    (var-get total-stacked-ships)
)

(define-public (get-total-trs-pool-collection) 
    (ok (var-get total-pool-collection))
)

(define-read-only (get-total-pool-collection) 
    (var-get total-pool-collection)
)

(define-public (inc-day) 
     (let
        (
            (curr-time (unwrap-panic (get-block-info? time (- block-height u1))))
            (rel-time (- curr-time (var-get base-time)))
        )
        (asserts! (is-eq .game tx-sender) ERR-NOT-AUTHORIZED) ;; only game contract can call it
        (asserts! (>= rel-time (* u24 (var-get day))) ERR-NOT-IN-TIME)
        (var-set day (+ (var-get day) u1))
        (var-set total-pool-collection (var-get prev-pool-collection))
        (var-set prev-pool-collection u0)
        (ok true)
    )
)

