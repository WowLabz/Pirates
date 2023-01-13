(impl-trait .sip009-nft-trait.sip009-nft-trait)


(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-TOKEN-OWNER (err u101))
(define-constant ERR-ALREADY-STACKED (err u102))
(define-constant ERR-NOT-STACKED (err u103))
(define-constant ERR-RLE-ALREADY-COMBINED (err u104))
(define-constant ERR-BLOCK-TIME-ERROR (err u105))
(define-constant ERR-TRS-TRANSFER-FAILED (err u106))
(define-constant ERR-MIN-STACK-TIME-NOT-REACHED (err u107))
(define-constant ERR-NOT-PART-OF-LOOTING (err u108))
(define-constant ERR-NOT-IN-TIME (err u109))
(define-constant ERR-ZERO-ELIGIBLE-PIRATES  (err u110))
(define-constant ERR-TRS-ADD-FAILED (err u111))
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant OUT-OF-BOUND (err 405))


(define-constant contract-owner tx-sender)

(define-non-fungible-token pirates uint) 
(define-data-var min-stacked-time-needed uint u43200) ;; 12 hours
(define-data-var last-token-id uint u0)
(define-data-var day uint u0)
(define-data-var base-time uint u0) ;;(unwrap-panic (get-block-info? time (- block-height u1)))
(define-data-var total-fear-factor uint u0)
;; mapping token-id => attribute
(define-map nft-details uint {traits: {  bottom : { idx : uint, is-rare : bool},
    face : { idx : uint, is-rare : bool},
    hand : { idx : uint, is-rare : bool},
    hat : { idx : uint, is-rare : bool},
    top : { idx : uint, is-rare : bool},
    sword : { idx : uint, is-rare : bool}
}, fear-factor: uint, is-rare: bool, is-stacked: bool, nft-rle: (string-utf8 20000), total-stacked-time: uint, stacked-at: uint, trs-token: uint, will-loot : bool })

(define-map stacked-pirates uint principal)
(define-data-var total-stacked-pirates uint u0)

;; functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
   (ok none)
   ;; (get nft-rle (unwrap-panic (map-get? nft-details token-id)))
)

(define-read-only (get-owner (token-id uint))
    (ok (nft-get-owner? pirates token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
    (begin
        (asserts! (not (is-eq (unwrap-panic (get-owner token-id)) none)) ERR-OWNER-ONLY)
        (asserts! (is-eq tx-sender sender) ERR-NOT-TOKEN-OWNER)
        (nft-transfer? pirates token-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let
        (
            (token-id (var-get last-token-id))
            (nft-property (unwrap-panic (contract-call? .pirates-factory get-random-traits)))
            (traits (get traits nft-property))
            (fear-factor (get fear-factor nft-property))
            (is-rare (get is-rare nft-property))
        )        
        (asserts! (is-eq .game tx-sender) ERR-NOT-AUTHORIZED) ;; only game contract can call it
        (var-set last-token-id (+ token-id u1))
        (try! (nft-mint? pirates token-id recipient))
        ;; will send request to external api and will get NFT RLE : future
        (map-insert nft-details token-id { fear-factor: fear-factor, is-rare: is-rare, is-stacked : false, nft-rle : u"", total-stacked-time : u0, stacked-at : u0, trs-token : u0, traits : traits, will-loot : false})
        (ok true)
    )
)

(define-public (combine-traits-to-one (token-id uint) (pirate-rle (string-utf8 20000)))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq (get nft-rle nft-detail) u"") ERR-RLE-ALREADY-COMBINED)
        (map-set nft-details token-id (merge nft-detail { nft-rle : pirate-rle }))
        (ok true)
    )
)

(define-read-only (pirate-details (token-id uint))
    (if (< token-id (var-get last-token-id))
        (ok (unwrap-panic (map-get? nft-details token-id)))
        ERR-NOT-FOUND
    )
)
(define-public (stack-pirate (token-id uint))
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq false (get is-stacked nft-detail)) ERR-ALREADY-STACKED)
        (asserts! (is-some (get-block-info? time (- block-height u1))) ERR-BLOCK-TIME-ERROR)
        (map-set nft-details token-id (merge nft-detail { is-stacked : true, stacked-at : (unwrap-panic (get-block-info? time (- block-height u1)))  }))
        
        (map-insert stacked-pirates (var-get total-stacked-pirates) tx-sender)
        (var-set total-stacked-pirates (+ (var-get total-stacked-pirates) u1))
        
        (ok true)
    )
)

(define-public (unstack-pirate (token-id uint))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq true (get is-stacked nft-detail)) ERR-NOT-STACKED)
        (asserts! (is-some (get-block-info? time (- block-height u1))) ERR-BLOCK-TIME-ERROR)
        (map-set nft-details token-id (merge nft-detail { is-stacked : false, total-stacked-time : (+ (get total-stacked-time nft-detail) (- (unwrap-panic (get-block-info? time (- block-height u1))) (get stacked-at nft-detail))) }))
        
        (var-set total-stacked-pirates (- (var-get total-stacked-pirates) u1))
        (map-set stacked-pirates token-id (default-to tx-sender (map-get? stacked-pirates (var-get total-stacked-pirates))))
        (map-delete stacked-pirates (var-get total-stacked-pirates))
        (ok true)
    )
)

(define-read-only (get-total-stacked-pirates) 
    (var-get total-stacked-pirates)
)

(define-public (get-rd-total-stacked-pirates) 
    (ok (map-get? stacked-pirates (unwrap-panic (contract-call? .random-number get-random (get-total-stacked-pirates) u697))))
)

(define-private (pirate-amount (token-id uint)) 
    (begin 
        (asserts! (>= (var-get total-fear-factor) u1) ERR-ZERO-ELIGIBLE-PIRATES)
        (ok (/ (* (get fear-factor (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND)) (unwrap-panic  (contract-call? .ship-nft get-total-trs-pool-collection))) (var-get total-fear-factor)))
    )
)

(define-public (loot (token-id uint)) 
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
            (curr-time (unwrap-panic (get-block-info? time (- block-height u1))))
            (total-time (+ (get total-stacked-time nft-detail) (- curr-time (get stacked-at nft-detail))))
            (rel-time (- curr-time (var-get base-time)))
            (amount-will-get (unwrap-panic (pirate-amount token-id)))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        ;; in range [20 24]
        (asserts! (and (>= rel-time (+ u20 (* u24 (var-get day)))) (<= rel-time (+ u24 (* u24 (var-get day))))) ERR-NOT-IN-TIME)
        (asserts! (get will-loot nft-detail) ERR-NOT-PART-OF-LOOTING)
        (map-set nft-details token-id (merge nft-detail { will-loot : false , stacked-at : curr-time, trs-token : (+ (get trs-token nft-detail) amount-will-get) }))
        (asserts! (is-eq (unwrap-panic (as-contract (contract-call? .trs-token transfer-claimed-trs amount-will-get tx-sender))) true) ERR-TRS-TRANSFER-FAILED)
        ;; (asserts! (is-eq (unwrap-panic (as-contract (contract-call? .leaderboard add-trs-value amount-will-get tx-sender))) true) ERR-TRS-ADD-FAILED)
        (ok true)
    )
)

(define-public (will-loot (token-id uint))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) ERR-NOT-FOUND))
            (curr-time (unwrap-panic (get-block-info? time (- block-height u1))))
            (total-time (+ (get total-stacked-time nft-detail) (- curr-time (get stacked-at nft-detail))))
            (rel-time (- curr-time (var-get base-time)))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        ;; will be in range [18 20]
        (asserts! (and (>= rel-time (+ u18 (* u24 (var-get day)))) (<= rel-time (+ u20 (* u24 (var-get day))))) ERR-NOT-IN-TIME)
        (asserts! (>= total-time (var-get min-stacked-time-needed)) ERR-MIN-STACK-TIME-NOT-REACHED)
        (var-set total-fear-factor (+ (var-get total-fear-factor) (get fear-factor nft-detail)))
        (map-set nft-details token-id (merge nft-detail { will-loot : true }))
        (ok true)
    )
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
        (var-set total-fear-factor u0)
        (ok true)
    )
)


