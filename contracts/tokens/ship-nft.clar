(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant contract-owner tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-TOKEN-OWNER (err u101))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant err-already-stacked (err u102))
(define-constant err-not-already-stacked (err u103))
(define-constant err-rle-already-combined (err u104))

(define-non-fungible-token ships uint)

(define-data-var last-token-id uint u0)

;; mapping token-id => attribute
(define-map nft-details uint { traits: {body: uint,mast: uint,telescope: uint,windows: uint,anchor: uint,sails: uint}, is-rare: bool, tov: uint, is-stacked: bool, nft-rle: (string-utf8 1000), stacked-unstacked-count: uint, trs-token: uint })
(define-map stack-unstack-interval uint (list 5000 {stacked-at: uint, unstacked-at: uint}))


;; functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (ok none)
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
            (token-id (+ (var-get last-token-id) u1))
            (nft-property (unwrap-panic (contract-call? .ship-factory get-random-traits)))
            (traits (get traits nft-property))
            (is-rare (get is-rare nft-property))
            (tov (get tov nft-property))
        )        

        (var-set last-token-id token-id)
        (try! (nft-mint? ships token-id tx-sender))
        ;; will send request to external api and will get NFT RLE
        (map-insert nft-details token-id { traits : traits ,is-rare : is-rare, tov : tov, is-stacked : false, nft-rle : u"", stacked-unstacked-count : u0, trs-token : u0})
        (ok true)
    )
)

(define-public (combine-traits-to-one (token-id uint) (ship-rle (string-utf8 1000)))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq (get nft-rle nft-detail) u"") err-rle-already-combined)
        (map-set nft-details token-id (merge nft-detail { nft-rle : ship-rle }))
        (ok true)
    )
)

(define-public (stack-ship (token-id uint))
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq false (get is-stacked nft-detail)) err-already-stacked)
        ;; (map-set stack-unstack-interval token-id ) --set here
        (map-set nft-details token-id (merge nft-detail { is-stacked : true, stacked-unstacked-count : (+ (get stacked-unstacked-count nft-detail) u1)  }))
        (ok nft-detail)
    )
)

(define-public (unstack-ship (token-id uint))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? ships token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq true (get is-stacked nft-detail)) err-not-already-stacked)
        ;; (map-set stack-unstack-interval token-id ) --set here
        (map-set nft-details token-id (merge nft-detail { is-stacked : false }))
        (ok nft-detail)
    )
)

(define-read-only (ship-details (token-id uint))
    (if (< token-id (var-get last-token-id))
        (ok (unwrap-panic (map-get? nft-details token-id)))
        ERR-NOT-FOUND
    )
)