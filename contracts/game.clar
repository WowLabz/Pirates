(define-constant err-minting-amount-transfer-failed (err u1))
(define-constant err-insufficient-value (err u2)) 
(define-constant ERR-NOT-AUTHORIZED (err u401))
(define-constant err-minting-failed (err u402))

(define-data-var contract-owner principal tx-sender)

(define-data-var total-nft uint u0)
(define-data-var stx-nft-count uint u1000)
(define-data-var minting-stx-amount uint u42)
(define-data-var minting-trs-amount uint u2000)
(define-map user-buffer principal uint)
(define-data-var base-time uint u0) ;;(unwrap-panic (get-block-info? time (- block-height u1)))
(define-data-var wowlabz principal 'STNHKEPYEPJ8ET55ZZ0M5A34J0R3N5FM2CMMMAZ6)

(define-private (mint-nft)
    (let 
        (
            (chance (unwrap-panic (contract-call? .random-number get-random u100 u243)))
        )
        (if (< chance u95)
            (begin
                (asserts! (is-eq (unwrap-panic (contract-call? .ship-nft mint tx-sender)) true) err-minting-failed)
                (ok true)                
            )
            (begin 
                (asserts! (is-eq (unwrap-panic (contract-call? .pirate-nft mint tx-sender)) true) err-minting-failed)
                (ok true)  
            )
        )
    )
)

(define-public (mint (recipient principal))
    (let 
        (
            (game-recipient (var-get wowlabz))
        )
        (if (<= (var-get total-nft) (var-get stx-nft-count))
            ;; mint from stx till stx-nft-count
            (begin 
                (asserts! (<= (var-get minting-stx-amount) (stx-get-balance tx-sender)) err-insufficient-value)
                (asserts! (is-eq (unwrap-panic (mint-nft)) true) (err u34))
                (asserts! (is-eq (unwrap-panic (stx-transfer? (var-get minting-stx-amount) tx-sender game-recipient)) true) err-minting-amount-transfer-failed) 
                (var-set total-nft (+ (var-get total-nft) u1))
                (map-set user-buffer tx-sender (+ (get-user-buffer tx-sender) u1))
                (ok true)
            )
            ;; mint from trs
            (begin 
                (asserts! (<= (var-get minting-trs-amount) (unwrap-panic (contract-call? .token-trs get-balance tx-sender))) err-insufficient-value)
                (asserts! (is-eq (unwrap-panic (mint-nft)) true) (err u34))
                (asserts! (is-eq (unwrap-panic (contract-call? .token-trs transfer (var-get minting-trs-amount) tx-sender game-recipient none)) true) err-minting-amount-transfer-failed)
                (var-set total-nft (+ (var-get total-nft) u1))
                (map-set user-buffer tx-sender (+ (get-user-buffer tx-sender) u1))
                (ok true)
            )
        )

    )
)


(define-read-only (get-user-buffer (user-principal principal)) 
    (default-to u0  (map-get? user-buffer user-principal))
)

(define-read-only (get-wowlabz) 
    (var-get wowlabz)
)

(define-public (update-wowlabz (new-wowlabz principal)) 
    (begin 
        (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        (var-set wowlabz new-wowlabz)
        (ok true)
    )
)

;; INCREMENT DAY ONCE LOOTING IS COMPLETED AFTER LOOTING
(define-public (inc-day) 
    (begin 
        (unwrap-panic (contract-call? .pirate-nft inc-day))
        (unwrap-panic  (contract-call? .ship-nft inc-day))
        (ok true)
    )
)