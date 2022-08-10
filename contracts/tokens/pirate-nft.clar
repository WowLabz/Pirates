(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant contract-owner tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-TOKEN-OWNER (err u101))
(define-constant ERR-NOT-FOUND (err u404))
(define-constant err-already-stacked (err u102))
(define-constant err-not-already-stacked (err u103))
(define-constant err-rle-already-combined (err u104))


(define-non-fungible-token pirates uint) 

(define-data-var last-token-id uint u0)

;; mapping token-id => attribute
(define-map nft-details uint {traits: {  Bottom : uint,
    Face : uint,
    Hand : uint,
    Hat : uint,
    Top : uint,
    Sword : uint
}, fear-factor: uint, is-rare: bool, is-stacked: bool, nft-rle: (string-utf8 1000), stacked-unstacked-count: uint, trs-token: uint })

(define-map stack-unstack-interval uint (list 5000 {stacked-at: uint, unstacked-at: uint}))

;; functions
(define-read-only (get-last-token-id)
    (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
    (ok none)
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
            (nft-property (unwrap-panic (contract-call? .pirate-factory get-random-traits)))
            (traits (get traits nft-property))
            (fear-factor (get fear-factor nft-property))
            (is-rare (get is-rare nft-property))
        )        
        (var-set last-token-id (+ token-id u1))
        (try! (nft-mint? pirates token-id tx-sender))
        ;; will send request to external api and will get NFT RLE : future
        (map-insert nft-details token-id { fear-factor: fear-factor, is-rare: is-rare, is-stacked : false, nft-rle : u"", stacked-unstacked-count : u0, trs-token : u0, traits: traits})
        (ok true)
    )
)

(define-public (combine-traits-to-one (token-id uint) (pirate-rle (string-utf8 1000)))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq (get nft-rle nft-detail) u"") err-rle-already-combined)
        (map-set nft-details token-id (merge nft-detail { nft-rle : pirate-rle }))
        (ok true)
    )
)

(define-public (stack-pirate (token-id uint))
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq false (get is-stacked nft-detail)) err-already-stacked)
        ;; (map-set stack-unstack-interval token-id ) --set here
        (map-set nft-details token-id (merge nft-detail { is-stacked : true, stacked-unstacked-count : (+ (get stacked-unstacked-count nft-detail) u1)  }))
        (ok nft-detail)
    )
)

(define-public (unstack-pirate (token-id uint))
     (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) ERR-NOT-TOKEN-OWNER)
        (asserts! (is-eq true (get is-stacked nft-detail)) err-not-already-stacked)
        ;; (map-set stack-unstack-interval token-id ) --set here
        (map-set nft-details token-id (merge nft-detail { is-stacked : false }))
        (ok nft-detail)
    )
)

(define-read-only (pirate-details (token-id uint))
    (if (< token-id (var-get last-token-id))
        (ok (unwrap-panic (map-get? nft-details token-id)))
        ERR-NOT-FOUND
    )
)