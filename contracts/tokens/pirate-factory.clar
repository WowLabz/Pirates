(define-constant ERR-NOT-AUTHORIZED (err u1000))


(define-data-var contract-owner principal tx-sender)

;; A map that creates a id => rle string relation.
;; hat 
(define-map common-hat-trait uint (string-utf8 3))
(define-data-var last-common-hat-id uint u0)
(define-map rare-hat-trait uint (string-utf8 3))
(define-data-var last-rare-hat-id uint u0)
;; bottom
(define-map common-bottom-trait uint (string-utf8 3))
(define-data-var last-common-bottom-id uint u0)
(define-map rare-bottom-trait uint (string-utf8 3))
(define-data-var last-rare-bottom-id uint u0)
;; face
(define-map common-face-trait uint (string-utf8 3))
(define-data-var last-common-face-id uint u0)
(define-map rare-face-trait uint (string-utf8 3))
(define-data-var last-rare-face-id uint u0)
;; hand
(define-map common-hand-trait uint (string-utf8 3))
(define-data-var last-common-hand-id uint u0)
(define-map rare-hand-trait uint (string-utf8 3))
(define-data-var last-rare-hand-id uint u0)
;; sword
(define-map common-sword-trait uint (string-utf8 3))
(define-data-var last-common-sword-id uint u0)
(define-map rare-sword-trait uint (string-utf8 3))
(define-data-var last-rare-sword-id uint u0)
;; top
(define-map common-top-trait uint (string-utf8 3))
(define-data-var last-common-top-id uint u0)
(define-map rare-top-trait uint (string-utf8 3))
(define-data-var last-rare-top-id uint u0)

;; function related to hat trait of pirate
;; handled common traits
(define-read-only (get-common-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate bottom
    (if (is-eq trait-type "Bot")
        (map-get? common-bottom-trait id)
        ;; for face bottom
        (if (is-eq trait-type "Fac")
            (map-get? common-face-trait id)
            ;; for hand bottom
            (if (is-eq trait-type "Han")
                (map-get? common-hand-trait id)
                ;; for hat bottom
                (if (is-eq trait-type "Hat")
                    (map-get? common-hat-trait id)
                    ;; for top bottom
                    (if (is-eq trait-type "Top")
                        (map-get? common-top-trait id)
                        ;; for sword bottom
                        (if (is-eq trait-type "Swo")
                            (map-get? common-sword-trait id)
                            ;; solve this, have to return err saying no trait found with given trait type
                            (map-get? common-sword-trait id)
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-common-trait (trait-rle (string-utf8 3)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for pirate bottom
        (if (is-eq trait-type "Bot")
            (begin 
                (map-set common-bottom-trait (var-get last-common-bottom-id) trait-rle)
                (var-set last-common-bottom-id (+ (var-get last-common-bottom-id) u1))
            )
            ;; for face bottom
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set common-face-trait (var-get last-common-face-id) trait-rle)
                    (var-set last-common-face-id (+ (var-get last-common-face-id) u1))
                )
                ;; for hand bottom
                (if (is-eq trait-type "Han")
                    (begin 
                        (map-set common-hand-trait (var-get last-common-hand-id) trait-rle)
                        (var-set last-common-hand-id (+ (var-get last-common-hand-id) u1))
                    )
                    ;; for hat bottom
                    (if (is-eq trait-type "Hat")
                        (begin 
                            (map-set common-hat-trait (var-get last-common-hat-id) trait-rle)
                            (var-set last-common-hat-id (+ (var-get last-common-hat-id) u1))
                        )
                        ;; for top bottom
                        (if (is-eq trait-type "Top")
                            (begin 
                                (map-set common-top-trait (var-get last-common-top-id) trait-rle)
                                (var-set last-common-top-id (+ (var-get last-common-top-id) u1))
                            )
                            ;; for sword bottom
                            (if (is-eq trait-type "Swo")
                                (begin 
                                    (map-set common-sword-trait (var-get last-common-sword-id) trait-rle)
                                    (var-set last-common-sword-id (+ (var-get last-common-sword-id) u1))
                                )
                                ;; have to return error here
                                false
                            )
                        )
                    )
                )
            )
        )
        (ok true)
	)
)

;; handled rare traits
(define-read-only (get-rare-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for pirate bottom
    (if (is-eq trait-type "Bot")
        (map-get? rare-bottom-trait id)
        ;; for face bottom
        (if (is-eq trait-type "Fac")
            (map-get? rare-face-trait id)
            ;; for hand bottom
            (if (is-eq trait-type "Han")
                (map-get? rare-hand-trait id)
                ;; for hat bottom
                (if (is-eq trait-type "Hat")
                    (map-get? rare-hat-trait id)
                    ;; for top bottom
                    (if (is-eq trait-type "Top")
                        (map-get? rare-top-trait id)
                        ;; for sword bottom
                        (if (is-eq trait-type "Swo")
                            (map-get? rare-sword-trait id)
                            ;; solve this, have to return err saying no trait found with given trait type
                            (map-get? rare-sword-trait id)
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-rare-trait (trait-rle (string-utf8 3)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for pirate bottom
        (if (is-eq trait-type "Bot")
            (begin 
                (map-set rare-bottom-trait (var-get last-rare-bottom-id) trait-rle)
                (var-set last-rare-bottom-id (+ (var-get last-rare-bottom-id) u1))
            )
            ;; for face bottom
            (if (is-eq trait-type "Fac")
                (begin 
                    (map-set rare-face-trait (var-get last-rare-face-id) trait-rle)
                    (var-set last-rare-face-id (+ (var-get last-rare-face-id) u1))
                )
                ;; for hand bottom
                (if (is-eq trait-type "Han")
                    (begin 
                        (map-set rare-hand-trait (var-get last-rare-hand-id) trait-rle)
                        (var-set last-rare-hand-id (+ (var-get last-rare-hand-id) u1))
                    )
                    ;; for hat bottom
                    (if (is-eq trait-type "Hat")
                        (begin 
                            (map-set rare-hat-trait (var-get last-rare-hat-id) trait-rle)
                            (var-set last-rare-hat-id (+ (var-get last-rare-hat-id) u1))
                        )
                        ;; for top bottom
                        (if (is-eq trait-type "Top")
                            (begin 
                                (map-set rare-top-trait (var-get last-rare-top-id) trait-rle)
                                (var-set last-rare-top-id (+ (var-get last-rare-top-id) u1))
                            )
                            ;; for sword bottom
                            (if (is-eq trait-type "Swo")
                                (begin 
                                    (map-set rare-sword-trait (var-get last-rare-sword-id) trait-rle)
                                    (var-set last-rare-sword-id (+ (var-get last-rare-sword-id) u1))
                                )
                                ;; have to return error here
                                false
                            )
                        )
                    )
                )
            )
        )
        (ok true)
	)
)


;; minting random pirates
(define-public (get-random-traits)
	(begin
		;; random
		(ok (list 0 0 0 0 0))
	)
)