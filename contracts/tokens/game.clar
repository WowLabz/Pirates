

(define-public (mint (recipient principal))
    (if (is-eq true true)
        ;; mint pirates
        (print 	(contract-call? .pirate-nft mint tx-sender))
        
        ;; mint ship
        (print 	(contract-call? .ship-nft mint tx-sender))
        
    )
)