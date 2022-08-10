(define-constant ERR-NOT-AUTHORIZED (err u401))


(define-data-var contract-owner principal tx-sender)
(define-data-var common-trait-value uint u2)
(define-data-var rare-trait-value uint u3)
(define-data-var traits {body: uint,mast: uint,telescope: uint,windows: uint,anchor: uint,sails: uint} {  
                body : u0,
                mast : u0,
                telescope : u0,
                windows : u0,
                anchor : u0,
                sails : u0
            })
;; A map that creates a id => rle string relation.
;; body 
(define-map common-body-trait uint (string-utf8 20))
(define-data-var last-common-body-id uint u0)
(define-map rare-body-trait uint (string-utf8 20))
(define-data-var last-rare-body-id uint u0)
;; mast
(define-map common-mast-trait uint (string-utf8 20))
(define-data-var last-common-mast-id uint u0)
(define-map rare-mast-trait uint (string-utf8 20))
(define-data-var last-rare-mast-id uint u0)
;; telescope
(define-map common-telescope-trait uint (string-utf8 20))
(define-data-var last-common-telescope-id uint u0)
(define-map rare-telescope-trait uint (string-utf8 20))
(define-data-var last-rare-telescope-id uint u0)
;; sails
(define-map common-sails-trait uint (string-utf8 20))
(define-data-var last-common-sails-id uint u0)
(define-map rare-sails-trait uint (string-utf8 20))
(define-data-var last-rare-sails-id uint u0)
;; anchor
(define-map common-anchor-trait uint (string-utf8 20))
(define-data-var last-common-anchor-id uint u0)
(define-map rare-anchor-trait uint (string-utf8 20))
(define-data-var last-rare-anchor-id uint u0)
;; windows
(define-map common-windows-trait uint (string-utf8 20))
(define-data-var last-common-windows-id uint u0)
(define-map rare-windows-trait uint (string-utf8 20))
(define-data-var last-rare-windows-id uint u0)

;; function related to body trait of ship
;; handled ship common traits
(define-read-only (get-common-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for mast
    (if (is-eq trait-type "Mas")
        (map-get? common-mast-trait id)
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (map-get? common-telescope-trait id)
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (map-get? common-sails-trait id)
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (map-get? common-body-trait id)
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (map-get? common-windows-trait id)
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (map-get? common-anchor-trait id)
                            none
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-common-trait (trait-rle (string-utf8 20)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for mast 
        (if (is-eq trait-type "Mas")
            (begin 
                (map-set common-mast-trait (var-get last-common-mast-id) trait-rle)
                (var-set last-common-mast-id (+ (var-get last-common-mast-id) u1))
            )
            ;; for telescope 
            (if (is-eq trait-type "Tel")
                (begin 
                    (map-set common-telescope-trait (var-get last-common-telescope-id) trait-rle)
                    (var-set last-common-telescope-id (+ (var-get last-common-telescope-id) u1))
                )
                ;; for sails 
                (if (is-eq trait-type "Sai")
                    (begin 
                        (map-set common-sails-trait (var-get last-common-sails-id) trait-rle)
                        (var-set last-common-sails-id (+ (var-get last-common-sails-id) u1))
                    )
                    ;; for body
                    (if (is-eq trait-type "Bod")
                        (begin 
                            (map-set common-body-trait (var-get last-common-body-id) trait-rle)
                            (var-set last-common-body-id (+ (var-get last-common-body-id) u1))
                        )
                        ;; for windows 
                        (if (is-eq trait-type "Win")
                            (begin 
                                (map-set common-windows-trait (var-get last-common-windows-id) trait-rle)
                                (var-set last-common-windows-id (+ (var-get last-common-windows-id) u1))
                            )
                            ;; for anchor mast
                            (if (is-eq trait-type "Anc")
                                (begin 
                                    (map-set common-anchor-trait (var-get last-common-anchor-id) trait-rle)
                                    (var-set last-common-anchor-id (+ (var-get last-common-anchor-id) u1))
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

;; handled ship rare traits
(define-read-only (get-rare-trait-at-index (id uint) (trait-type (string-ascii 3)))
    ;; for Mas 
    (if (is-eq trait-type "Mas")
        (map-get? rare-mast-trait id)
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (map-get? rare-telescope-trait id)
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (map-get? rare-sails-trait id)
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (map-get? rare-body-trait id)
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (map-get? rare-windows-trait id)
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (map-get? rare-anchor-trait id)
                            none
                        )
                    )
                )
            )
        )
    )        
)

(define-public (add-rare-trait (trait-rle (string-utf8 20)) (trait-type (string-ascii 3)))
    (begin
		(asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
        ;; for mast
        (if (is-eq trait-type "Mas")
            (begin 
                (map-set rare-mast-trait (var-get last-rare-mast-id) trait-rle)
                (var-set last-rare-mast-id (+ (var-get last-rare-mast-id) u1))
            )
            ;; for telescope 
            (if (is-eq trait-type "Tel")
                (begin 
                    (map-set rare-telescope-trait (var-get last-rare-telescope-id) trait-rle)
                    (var-set last-rare-telescope-id (+ (var-get last-rare-telescope-id) u1))
                )
                ;; for sails 
                (if (is-eq trait-type "Sai")
                    (begin 
                        (map-set rare-sails-trait (var-get last-rare-sails-id) trait-rle)
                        (var-set last-rare-sails-id (+ (var-get last-rare-sails-id) u1))
                    )
                    ;; for body 
                    (if (is-eq trait-type "Bod")
                        (begin 
                            (map-set rare-body-trait (var-get last-rare-body-id) trait-rle)
                            (var-set last-rare-body-id (+ (var-get last-rare-body-id) u1))
                        )
                        ;; for windows
                        (if (is-eq trait-type "Win")
                            (begin 
                                (map-set rare-windows-trait (var-get last-rare-windows-id) trait-rle)
                                (var-set last-rare-windows-id (+ (var-get last-rare-windows-id) u1))
                            )
                            ;; for anchor 
                            (if (is-eq trait-type "Swo")
                                (begin 
                                    (map-set rare-anchor-trait (var-get last-rare-anchor-id) trait-rle)
                                    (var-set last-rare-anchor-id (+ (var-get last-rare-anchor-id) u1))
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

(define-private (get-random (max uint))
    (unwrap-panic 
        (contract-call? .random-number get-random max u489420)
    )
)

(define-private (select-from-common (trait-type (string-ascii 3)))
   ;; for mast
    (if (is-eq trait-type "Mas")
            (get-random (var-get last-common-mast-id))
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (get-random (var-get last-common-telescope-id))
            ;; for sails 
            (if (is-eq trait-type "Sai")
                (get-random (var-get last-common-sails-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-common-body-id))
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-common-windows-id))
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                             (get-random (var-get last-common-anchor-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                             (get-random (var-get last-common-anchor-id))
                        )
                    )
                )
            )
        )
    )  
)

(define-private (select-from-rare (trait-type (string-ascii 3)))
   ;; for mast
    (if (is-eq trait-type "Mas")
        (get-random (var-get last-rare-mast-id))
        ;; for telescope 
        (if (is-eq trait-type "Tel")
            (get-random (var-get last-rare-telescope-id))
            ;; for sails 
            (if (is-eq trait-type "Sai")
                 (get-random (var-get last-rare-sails-id))
                ;; for body 
                (if (is-eq trait-type "Bod")
                    (get-random (var-get last-rare-body-id))
                    ;; for windows 
                    (if (is-eq trait-type "Win")
                        (get-random (var-get last-rare-windows-id))
                        ;; for anchor 
                        (if (is-eq trait-type "Anc")
                            (get-random (var-get last-rare-anchor-id))
                            ;; solve this, have to return err saying no trait found with given trait type
                            (get-random (var-get last-rare-anchor-id))
                        )
                    )
                )
            )
        )
    )  
)

(define-private (select-random-trait (trait-type (string-ascii 3))) 
    (let
        (
            (chance-random (contract-call? .random-number get-random u89 u328)) 
        )
        ;; (if (> (+ chance-random (contract-call? .game get-user-buffer tx-sender) u90) 
        (if (> u89 u90) 
           
            (begin
                ;; if 1 then choose from rare else from common
                (if (is-eq (unwrap-panic (contract-call? .random-number get-random u2 u328)) u1)
                    (select-from-rare trait-type)
                    (select-from-common trait-type)
                )
            )
            ;; always common
             (select-from-common trait-type)
        )
	)
)

;; minting random pirates
(define-public (get-random-traits)
    (ok {
            traits: {  
                body : (select-random-trait "Bod"),
                mast : (select-random-trait "Mas"),
                telescope : (select-random-trait "Tel"),
                windows : (select-random-trait "Win"),
                anchor : (select-random-trait "Anc"),
                sails : (select-random-trait "Sai")
            },
            is-rare: true,
            tov: u9
        }
    )
)


