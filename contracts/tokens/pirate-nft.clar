(impl-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-not-found (err u404))
(define-constant err-already-stacked (err u102))
(define-constant err-not-already-stacked (err u103))


(define-non-fungible-token pirates uint)

(define-data-var last-token-id uint u0)

;; mapping token-id => attribute
(define-map nft-details uint { is-stacked: bool, nft-rle: (string-utf8 3), stacked-unstacked-count: uint, trs-token: uint })
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
        (asserts! (is-eq tx-sender sender) err-not-token-owner)
        (nft-transfer? pirates token-id sender recipient)
    )
)

(define-public (mint (recipient principal))
    (let
        (
            (token-id (+ (var-get last-token-id) u1))
            (random-traits 	(contract-call? .pirate-factory get-random-traits))
        )        
        (var-set last-token-id token-id)
        (try! (nft-mint? pirates token-id tx-sender))
        ;; will send request to external api and will get NFT RLE
        (map-insert nft-details token-id { is-stacked : false, nft-rle : u"pir", stacked-unstacked-count : u0, trs-token : u0})
        (ok random-traits)
    )
)

(define-public (stack-pirate (token-id uint))
    (let
        (
            (nft-detail (unwrap! (map-get? nft-details token-id) err-already-stacked))
        )
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) err-not-token-owner)
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
        (asserts! (is-eq tx-sender (unwrap-panic (nft-get-owner? pirates token-id))) err-not-token-owner)
        (asserts! (is-eq true (get is-stacked nft-detail)) err-not-already-stacked)
        ;; (map-set stack-unstack-interval token-id ) --set here
        (map-set nft-details token-id (merge nft-detail { is-stacked : false }))
        (ok nft-detail)
    )
)

(define-read-only (pirate-details (token-id uint))
    (if (< token-id (var-get last-token-id))
        (ok (unwrap-panic (map-get? nft-details token-id)))
        err-not-found
    )
)