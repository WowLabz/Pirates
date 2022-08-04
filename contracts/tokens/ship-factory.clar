(define-constant ERR-NOT-AUTHORIZED (err u1000))


(define-data-var contract-owner principal tx-sender)

;; A map that creates a id => rle string relation.
;; body
(define-map common-body-trait uint (string-utf8 3))
(define-data-var last-common-body-id uint u0)
(define-map rare-body-trait uint (string-utf8 3))
(define-data-var last-rare-body-id uint u0)
;; flag
(define-map common-flag-trait uint (string-utf8 3))
(define-data-var last-common-flag-id uint u0)
(define-map rare-flag-trait uint (string-utf8 3))
(define-data-var last-rare-flag-id uint u0)

;; function related to hat trait of ship
;; handled common traits
(define-read-only (get-common-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate body
    (if (is-eq trait-type "Bod")
        (map-get? common-body-trait id)
        ;; for flag body
        (if (is-eq trait-type "Fla")
            (map-get? common-flag-trait id)
            ;; error
            (map-get? common-flag-trait id)
        )
    )        
)

(define-public (add-common-trait (trait-rle (string-utf8 3)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for pirate body
        (if (is-eq trait-type "Bod")
            (begin 
                (map-set common-body-trait (var-get last-common-body-id) trait-rle)
                (var-set last-common-body-id (+ (var-get last-common-body-id) u1))
            )
            ;; for flag body
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set common-flag-trait (var-get last-common-flag-id) trait-rle)
                    (var-set last-common-flag-id (+ (var-get last-common-flag-id) u1))
                )
                ;; error
                false
            )
        )
        (ok true)
	)
)

;; handled rare traits
(define-read-only (get-rare-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate body
    (if (is-eq trait-type "Bod")
        (map-get? rare-body-trait id)
        ;; for flag body
        (if (is-eq trait-type "Fla")
            (map-get? rare-flag-trait id)
            ;; error
            (map-get? rare-flag-trait id)
        )
    )        
)

(define-public (add-rare-trait (trait-rle (string-utf8 3)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for pirate body
        (if (is-eq trait-type "Bod")
            (begin 
                (map-set rare-body-trait (var-get last-rare-body-id) trait-rle)
                (var-set last-rare-body-id (+ (var-get last-rare-body-id) u1))
            )
            ;; for flag body
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set rare-flag-trait (var-get last-rare-flag-id) trait-rle)
                    (var-set last-rare-flag-id (+ (var-get last-rare-flag-id) u1))
                )
                ;; for hand body
                false
            )
        )
        (ok true)
	)
)

;; minting random ships
(define-public (get-random-traits)
	(begin
		;; random
		(ok (list 0 0))
	)
)